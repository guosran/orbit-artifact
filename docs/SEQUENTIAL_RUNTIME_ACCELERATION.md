# Runtime acceleration of the matched comparison

Both Joint and Sequential use the same accelerated compiler. The action
registry, objective cap, per-frontier quota, beam, canonical deduplication,
mapper, predictor and production scheduler remain the comparison contract in
[SEQUENTIAL_COMPARISON.md](SEQUENTIAL_COMPARISON.md). Caches stay private to
each method; Sequential retains its own caches across A and B.

## Changes

Apply the two incremental patches after the prerequisite and Sequential patches:

- `reference/sequential-comparison/runtime-acceleration.patch` indexes pending
  action queues by family while retaining the original stable ordinal, caches
  successfully proved full generic IR facts, and caches authenticated typed
  replay prefixes. The original 128-attempt checkpoint boundaries remain;
  periodic persistence occurs once per 32 windows, with mandatory phase,
  frontier and final persistence. Interrupted searches remain excluded, with
  durable lower/upper budget bounds rather than invented exact counts.
- `reference/sequential-comparison/runtime-materializer-proof-cache.patch`
  reuses successful proof certificates only when the complete printed generic
  module IR, including proof attributes, is identical within the same run.
  Graph changes retain the existing post-edit proofs. A strictly classified
  shape-only transaction can reuse its first proved identity rewrite, while
  still calling the original action application, shape/task checks, clone and
  MLIR verification. Final typed history, source-partition and phase-B freeze
  authentication remain. Freeze history compares exact typed action JSON.

No rejected proof is cached. Runtime counters use `runtime_*`; these proof
hits do not provide free objective evaluations. The switches
`runtime-pending-index=false`, `runtime-fact-cache=false`,
`runtime-replay-cache=false`, `runtime-materializer-proof-cache=false`, and
`checkpoint-write-period=1` disable the corresponding accelerations. Both arms
use the same defaults. The fact cache has 128 entries; replay prefixes have 64
entries and an estimated 128 MiB limit, not a promised resident memory limit.

The remaining measured bottleneck is printing generic IR: it took 74 seconds
of the accelerated GCN diagnostic's 170-second compiler search. The patch does
not replace the materializer or scheduler.

## Verification and timing

`diagnostics/sequential-comparison-4096/runtime-fast2-acceptance.json` records
**9/9** accepted comparisons: all four flows/splits on LU and Radar, plus GCN
Sequential50 with the main experiment's quota512. Each pair has identical
inputs, hardware, objective allowance and search configuration. LU/Radar use
allowance32/quota4; GCN uses allowance32/quota512 and exhausts A after five
objective calls. These are acceleration checks, not primary results.

The checker compares ordered action attempts/frontiers, score batches and
objective trajectories; selected IDs and all candidate IR bytes; predictor
counts and cache contents; aggregate mapper requests and exact full mapper
input/output bytes; and all seven native, numeric and independent-trace gates.
Documented runtime telemetry and per-rank attribution of concurrent shared
mapper-cache requests are separate; aggregate counts remain exact.

GCN compiler timing was 287.017 -> 169.742 seconds (observed 1.69x); the full
Python search interval was 288.193 -> 171.073 seconds. Radar Joint compiler
timing was 378.710 -> 286.939 seconds. Historical background loads differ, so
these are diagnostic observations, not isolated causal measurements or a
prediction of the full4096 batch speed. Fast1 alone had little overall benefit.
The targeted tests pass 27/27. Nine real compressed cells also pass the budget,
phase and final-validation auditors, and a post-compression GCN equivalence
check passes.

## Storage and restart

The original `results/sequential-comparison-4096-final` batch exited on ENOSPC.
Its three validated cells and failed checkpoints remain preserved; all its
costs are excluded from the fresh primary batch and reported separately by
`scripts/export_sequential_extra_costs.py`. The two lost final process-status
writes are recorded as unknown exit codes with observed process exit and
bounded objective counts. A prelaunch seed-copy failure is also recorded.

`scripts/compact_sequential_raw.py` archives completed auxiliary catalogues,
proofs and archive journals, and gzip-compresses the four long search journals.
It verifies exact raw and compressed SHA-256/size before removing plain copies.
Readers accept authenticated gzip storage; selected MLIR, traces, numerical
evidence and summaries remain plain. Restoring exact bytes is supported:

```sh
python3 scripts/compact_sequential_raw.py --restore-cell RESULTS/WORKLOAD/METHOD
```

Live cells are never compacted. Interrupted diagnostics require an explicit
process-exit record and budget audit. `--compact-completed` compacts each cell
synchronously after all seven validation gates, before starting the next cell.
`storage-overhead.json` reports this time separately from search/validation;
batch wall time includes it. Shared input-copy and per-cell binding/private
seed-copy wall time are also recorded as coordinator initialization. There is
no results-polling watcher.

The current primary namespace is `results/sequential-comparison-4096-fast2-host`.
The preceding fast2 tool-session run disappeared without a final exit record
after a durable2285-call GCN Joint checkpoint. Its actual budget is bounded
[2285,4096], retained separately and excluded; its exit cause is unconfirmed.
The new run has an independent host supervisor, with process state and exact
exit code recorded in `batch-process.json`, independent of tool session state.
Every method starts with its own identical seed and empty mapper cache. No old
partial search is resumed and no old validated cell is mixed into the new
batch. At the user-requested live scaling transition, two disjoint four-CPU lanes
run cells concurrently (eight cores total). Per-cell scoring and mapper workers
remain four, so the registry, batch size and candidate decisions do not change.
The already-running GCN Joint search is retained without interruption or
restart; Harris Joint starts on the additional lane.
`runtime-parallelism.json` records the transition and source/runtime bindings.
The original coordinator finishes its current search and all seven validation
gates, then hits an owned next-cell protocol guard before starting another
search. The parallel controller adopts the exact completed execution record
and continues the remaining cells; this handoff consumes no objective budget.

A read-only source audit confirmed that catalogues listed in a durable
checkpoint's `graph_cost_catalogues` array are written once and subsequently
read by their unchanged path. Only these completed immutable catalogue files
are migrated to private `/tmp` storage, with exact SHA-256 verification and
atomic symlinks at the original paths. Mutable caches, checkpoints, logs and
MLIR are untouched. The auxiliary tar archive dereferences these links and
verifies original bytes before the temporary copies are removed. Storage
migration time/bytes are retained in per-cell relocation journals.

Three repository Python scripts changed during the long run in separate
ablation work. Those edits are preserved. The additional lanes use exact
source-contract replay payloads and the recorded coordinator body in
`.work/sequential-source-bound-runtime`; shared artifact resources are
aliased to the original repository. Historical byte bindings are verified
against these exact retained source files, and new cells bind their actual
snapshot paths. The current process already loaded its original replay code;
its mapper/numeric/trace code is unchanged. Neither arm adopts the new
ablation stage scheme.

The filesystem relocation/archive/restore checks and existing targeted checks
pass 31/31. The transition changes external concurrency during the current
cell, so search wall curves retain their actual timestamps and are not
interpreted as an isolated causal speedup measurement. The allowance remains 4096, quota 512, beam 16,
diversity 4 and the 8192 safety ceiling, with all three prescribed splits.

## Reproduce

Use fresh source/build/pin/result paths. The baseline build must first be
created with the prerequisite and Sequential patches, as documented in
`SEQUENTIAL_COMPARISON.md`. The incremental builder verifies all relevant
source files, requires only `JointNeighborhoodSearchPass.cpp` to differ, and
reuses unchanged objects without modifying the baseline build or executable.
Its compile/link vectors and hashes are recorded in build provenance.

```sh
git -C ../orbit worktree add --detach "$PWD/.work/sequential-runtime-repro-source" 99ded7396f31c71ee0946389c6946a5f58c770c6
git -C .work/sequential-runtime-repro-source apply "$PWD/reference/sequential-comparison/existing-source-prerequisite.patch"
git -C .work/sequential-runtime-repro-source apply "$PWD/reference/sequential-comparison/compiler-sequential.patch"
git -C .work/sequential-runtime-repro-source apply "$PWD/reference/sequential-comparison/runtime-acceleration.patch"
git -C .work/sequential-runtime-repro-source apply "$PWD/reference/sequential-comparison/runtime-materializer-proof-cache.patch"
python3 scripts/build_sequential_runtime_acceleration.py \
  --baseline-build /tmp/orbit-sequential-build-final \
  --source-root .work/sequential-runtime-repro-source \
  --work-dir /tmp/orbit-sequential-runtime-repro-build \
  --optimizer .work/sequential-runtime-repro/bin/mlir-amoeba-opt
python3 scripts/write_neighborhood_source_contract.py \
  --source-root .work/sequential-runtime-repro-source --build-root /tmp/orbit-sequential-build-final \
  --optimizer .work/sequential-runtime-repro/bin/mlir-amoeba-opt \
  --model-root reference/input0-neighborhood/models/per-cgra-2x2 \
  --source-commit 6a1b6fcf6e155651e96b3b881565ad58fdf0c03e \
  --sram-config config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json \
  --inter-task-network config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml \
  --output .work/sequential-runtime-repro/source-model-contract.json
export ORBIT_LLVM_BUILD=/home/x/shiran/llvm-project/build
python3 scripts/run_sequential_comparison.py \
  --config .work/input0-neighborhood-2x2-v38/source-domain-prep/input0-chain.json \
  --optimizer .work/sequential-runtime-repro/bin/mlir-amoeba-opt \
  --source-contract-file .work/sequential-runtime-repro/source-model-contract.json \
  --model reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json \
  --architecture config/architectures/amoeba_4x4_cgra_2x2_context6.yaml \
  --inter-task-network config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml \
  --sram-config config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json \
  --output-root results/sequential-comparison-4096-runtime-repro \
  --budget 4096 --max-rounds 8192 --round-score-quota 512 \
  --workers 1 --cpus-per-worker 4 --compact-completed
```

For the running batch, query once and export all final evidence when ready:

```sh
cd /home/x/shiran/project/orbit-artifact
python3 scripts/show_sequential_comparison.py
```

The active-run pointer chooses the new result namespace. Explicit
`--results-root` and `--output-dir` override it. The command does not poll or
restart experiments. On completion it audits bindings and phases and exports
tables, budget/wall curves, sensitivity, final-plan index and a factual paper
paragraph. All acceleration, retired experiment, compilation and compaction
costs are retained outside the primary comparison.
