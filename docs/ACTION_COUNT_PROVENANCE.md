# Action count provenance

## First recoverable 5,280 record

The first recoverable machine-readable occurrence is `statistics.action_attempts=5280` in the historical `orbit_joint_tiling_fusion/joint_variant_space.json`. The corresponding `rewrite_dag_statistics.json` copies that source statistic; `ORBIT_JOINT_TILING_FUSION.md` later summarizes it. These files are in the archived `orbit_vectorcgra_memory_blocking_review` bundle, outside this repository. The raw manifest records 638 accepted and 4,642 rejected calls, 198 construction states, 126 complete semantic graphs, and a 20-entry action registry. It records 94 executable witnesses; **32 nonexecutable sequential-K witnesses were still enumerated as input states**, with 20 action calls each on their first visit.

The archive's `version_manifest.json` and `publication_provenance.json` associate this result with `guosran/amoeba` branch `orbit/joint-tiling-fusion-mlir-passes`, committed as `7111e8d772fc18f564654f576f7854e63a5c788a`. They record source worktree `/tmp/orbit-joint-tiling-fusion-worktree` and optimizer `/tmp/orbit-joint-mlir-build/tools/mlir-amoeba-opt/mlir-amoeba-opt`. Its `REPRODUCIBILITY.md` gives this command from that source worktree:

```bash
cd /tmp/orbit-joint-tiling-fusion-worktree
EVIDENCE=/tmp/amoeba-joint-scheduling-review/orbit_vectorcgra_memory_blocking_review/orbit_joint_tiling_fusion
OPT=/tmp/orbit-joint-mlir-build/tools/mlir-amoeba-opt/mlir-amoeba-opt
python3 tools/orbit_joint_mlir_pass_entry.py \
  --input test/multi-cgra/taskflow/joint-scheduling/orbit_joint_pipeline_8x8_i32.mlir \
  --output-dir "$EVIDENCE" --amoeba-opt "$OPT"
```

The wrapper invokes the C++ `enumerate-joint-semantic-rewrites` pass with `max-depth=8 max-actions=50000 tile-factor=0`. The original invocation's independent argv log was not preserved; the archive's raw manifest predates the publication commit. Thus the commit and command are **documented, reconstructable provenance**, rather than an immutable observation of the original process at launch. The archive's `final_patch.diff` is not the full pushed commit diff and is not a suitable source pin.

## Current pinned protocol

The artifact pins `guosran/amoeba` commit `a57376e7043b1681e64e7169c5a8cb02eb192331`. A newly built C++ optimizer and clean pinned checkout produced `results/2026-09-28T193254+0800-semantic/raw/joint_variant_space.json`: 5,920 action calls, 702 accepted, 5,218 rejected, 198 construction states, the same 126 complete graph IDs, and 126 executable witnesses. The artifact command was `./artifact.sh reproduce semantic`; its `commands.jsonl` records the exact C++ argv. The older semantic-closure archive at this same pinned commit also records 5,920. Two additional fresh C++ enumerations and a reconstructed action ledger are under `results/action-count-reconciliation/` when this audit is run locally.

## Comparable protocol inputs

The two protocols use the same Git-tracked canonical 8×8×8 i32 GEMM-to-elementwise fixture; the reconciliation script compares its content directly across the two Git commits without creating a file hash. The manifests also agree on function, shape, dtype, layout, arithmetic semantics, M/N/K factor set `{2,4,8}`, 20 action names/parameter tuples, maximum depth 8, and action budget 50,000. The ordered 126 candidate graph IDs agree. Action *executability metadata* differs: the old checkpoint marked K/reduction paths pending; the pinned source implements them and recognizes sequential-K-first followed by M/N tiling as an executable witness order. Input equality and action registry equality are checked by `scripts/reconcile_action_counts.py` before it publishes its comparison.

## Exact operational definition

In `EnumerateJointSemanticRewritePass.cpp`, one attempt is one `applyAction(current.state, action)` call for a concrete registry action when the BFS queue pops a state. The counter increments **before** legality. The 20 parameterized registry entries each count separately. A rejected action, including a full-domain no-op, counts. An accepted transition that canonicalizes to an existing graph counts. A witness-upgrade requeue causes the same canonical input/action combinations to count again. An identity root is not itself an attempt. Neither materialization, missing witness status, MLIR verification, host execution, Python reference actions, nor a whole-run retry contributes to this pass counter. The source emits accepted and rejected records in separate arrays; the ledger's chronological `attempt_index`, `rewrite_order`, and input executable-witness metadata are explicitly reconstructed from source FIFO and requeue rules, then checked against all records and final witness flags.

This definition describes the existing production counter. It does **not** establish that its changing queue-visit count is an appropriate frozen semantic-space invariant. See [reconciliation](ACTION_COUNT_RECONCILIATION.md).
