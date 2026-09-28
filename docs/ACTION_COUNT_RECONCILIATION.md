# Reconciliation of 5,280 and 5,920

**Verdict: ACTION COUNT RECONCILIATION PARTIAL; semantic contract NO-GO.** The 640-call difference is completely traced, but the corrected counting contract and fresh full validation are pending. The current source's operational count is 5,920; the frozen artifact expectation remains 5,280 and fails closed. No expected value, source pin, or public tag was changed in this audit.

## Reproduce the ledger

From the artifact root, after `./artifact.sh setup && ./artifact.sh build`, provide the archived old raw C++ manifest:

```bash
python3 scripts/reconcile_action_counts.py \
  --old-manifest /path/to/orbit_joint_tiling_fusion/joint_variant_space.json \
  --output results/action-count-reconciliation
```

The output directory must be new. The command runs the pinned C++ pass **twice** with the same canonical source and explicit `max-depth=8 max-actions=50000 tile-factor=0`, records both exact argv in `commands.jsonl`, and fails if the manifest records, inputs, or rerun ledger disagree. The old manifest is read, not copied; source-owned file-binding fields are not carried into this artifact's generated ledgers. Outputs include `old_protocol_actions.jsonl`, `current_protocol_actions.jsonl`, `current_protocol_rerun_actions.jsonl`, `action_count_summary.json`, and `action_count_diff.json`. The historical raw manifest's commit attribution has the limitation described in [provenance](ACTION_COUNT_PROVENANCE.md).

`reference/action_count_reconciliation.json` checks in only a compact summary and the 32 affected graph IDs. It is reference metadata, not a substitute for generating the ledgers.

Each ledger row contains the canonical input ID, action and parameters, reconstructed rewrite order and chronological attempt index, derived input witness availability, legality and rejection reason, output ID, duplicate-output flag, depth, and an explicit marker that materialization is outside the attempt count. The C++ manifest separates accepted and rejected arrays. The adapter reconstructs their interleaving with the source pass's FIFO queue, registry order, and executable-witness upgrade rule. It checks that every source row is consumed exactly once, duplicate-state markers match, 198 states are reached, and final witness flags match all 126 candidates. The reconstructed fields are labeled in every row; no absent historical field is represented as a directly observed value. For incomplete construction states, K/fusion mode is `unavailable_in_manifest`, not guessed.

## Exact multiset difference

The old and current ledgers have **3,960 identical distinct `(canonical input graph, action, parameter)` combinations**. The full record multiset comparison, including action depth, output, rejection reason, and duplicate flag, has 640 additions and zero removals. All 640 additions repeat combinations present in the old ledger. They are interleaved BFS visits, not a suffix of the current file.

| Difference class | Old | Current | Delta | Explanation |
|---|---:|---:|---:|---|
| Accepted, duplicate output | 441 | 505 | +64 | Each extra accepted transition reaches an already known graph |
| Rejected: `ALREADY_TILED` | 3,294 | 3,726 | +432 | Revisited tiled inputs |
| Rejected: `FUSION_ALREADY_PRESENT` | 218 | 266 | +48 | Revisited fused inputs |
| Rejected: `K_POLICY_CONFLICT` | 56 | 88 | +32 | Revisited sequential-K inputs |
| Rejected: `COMPLETION_JOIN_ALREADY_PRESENT` | 240 | 272 | +32 | Join already materialized |
| Rejected: `FUSION_REQUIRES_UNTILED_SOURCE` | 24 | 40 | +16 | Revisited output tiling |
| Rejected: `TILE_FACTOR_NOOP` | 222 | 238 | +16 | Full-domain tile-size action |
| **All action calls** | **5,280** | **5,920** | **+640** | **32 requeues × 20 catalog actions** |

Other rejection categories have zero delta. The added calls occur at action depths 3:160, 4:320, and 5:160. Every extra input has sequential K; 320 have no fusion and 320 have sequential-last fusion. The 32 input graph IDs each gain exactly 20 records, and their set is **exactly** the 32 old candidate IDs whose witness was marked nonexecutable. Their first visit was present in the old run; the added current visit has an executable action history. The old 32 split into M-only 8, N-only 8, and M×N 16; BK=2 and BK=4 split 16/16. There are no new graph IDs or output states: both runs have 198 construction states and the same ordered 126 candidate graph IDs.

## Cause and counting meaning

At old AMOEBA commit `7111e8d...`, 32 sequential-K graphs had pending M/N-then-K witness orders. At pinned commit `a57376e...`, the production pass and standalone materializer support sequential K followed by output tiling. The pass prefers a newly executable witness for a graph previously reached by a nonexecutable order, requeues that **already seen canonical graph**, and expands its 20 actions again to propagate executable histories. This updates all 32 final witnesses and produces the 640 extra C++ `applyAction` calls. It is not witness validation or host execution being added to the metric; it is an additional traversal of existing graph/action pairs.

The old 5,280 was already a queue-visit counter: 198 distinct states × 20 actions = 3,960 distinct input/action pairs, plus 66 prior witness-upgrade requeues × 20 = 1,320 repeat calls. The current 5,920 has 98 requeues, or 1,960 repeat calls. Thus 5,280 is a **pre-closure source-protocol count**, not a stable unique semantic action-space size. The current 5,920 is stable as a queue-visit count, but the 640 additions are not new canonical input states. Dropping those requeues merely to recover 5,280 could prevent propagation of executable witnesses; subtracting them after execution would misstate what the pass counted. A principled source protocol would distinguish queue invocations from distinct semantic input/action pairs and version the expected invariant. Neither change is made here.

## Determinism and gate decision

Two fresh pinned-source C++ enumerations from empty raw result paths both generated 5,920 records and exactly equal ordered action registries, candidate ID lists, accepted arrays, rejected arrays, and reconstructed ledgers. The earlier complete semantic runs also each recorded 5,920. This establishes deterministic behavior, not contractual correctness.

**Case 1 is excluded:** the 640 additions repeat existing canonical input/action combinations and do not arise from newly added semantic input states. **Case 2 has a localized cause but is not yet complete:** no reviewed source protocol fix and new full semantic reproduction have established an appropriate corrected invariant; simply suppressing 640 would preserve 1,320 older repeats. Case 3's nondeterminism/unknown-cause condition does not apply. The fail-closed outcome remains `SEMANTIC MODULE NO-GO`, no `semantic-closure-v0.1.1` tag, and no selected-candidate native replay. The first blocking discrepancy is `attempted_actions: expected 5280, observed 5920`; there is no unexplained ledger record or observed nondeterminism. Resolving the gate requires an explicit, reviewed action-count contract and source/harness change followed by fresh full semantic validation.
