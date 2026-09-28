# Paper handoff: action count remains outside the claim set

This handoff applies to the artifact at `git@github.com:guosran/orbit-artifact.git`, branch `main`, after the action-ledger audit. The audit began from public commit `a815e5b2e2f9d06b76fcbe6c05022db0fd78caec`; use this file's containing Git commit for the updated audit revision. The published tag `semantic-closure-v0.1` still points to that original commit and records a failed frozen action-count contract. **No `semantic-closure-v0.1.1` tag or GitHub Release has been created.** Pinned AMOEBA remains `a57376e7043b1681e64e7169c5a8cb02eb192331`.

| Item | Current evidence / verdict |
|---|---|
| Source C++ queue-visit action count | 5,920, deterministic in two fresh enumerations |
| Historical pre-closure queue-visit count | 5,280 from old commit `7111e8d...`; 32 witnesses missing then |
| Stable distinct canonical input/action combinations | 3,960 in both ledgers; this is a different metric |
| Canonical semantic graphs | Same 126 graph IDs in old and current manifests |
| Current structural validation | 126/126 materialized witnesses, MLIR verification, and exact C++ graph facts |
| Current host correctness | 504 executions, 172,800 element comparisons, zero mismatches; negative control detected one injected error |
| Semantic artifact contract | **NO-GO**: frozen 5,280 differs from pinned-source 5,920 |
| Selected native replay | **NO-GO / pending**: no current-protocol baseline or selected native replay pair |
| Matched baseline | Absent |

The `640 = 32 × 20` relationship is proven by record multiset and graph ID, not inferred from totals. The 32 formerly nonexecutable sequential-K witness graphs each gain one second 20-action expansion after a new executable K-first history is found. All added input/action combinations already existed; 64 new calls lead to existing graphs, and 576 are deterministic rejections. [Provenance](ACTION_COUNT_PROVENANCE.md) and [reconciliation](ACTION_COUNT_RECONCILIATION.md) contain the exact source and result locations.

**Safe paper wording while this contract remains unresolved:** “The canonical front-end test space contains 126 semantic graphs.” Do not quote either 5,280 or 5,920 as an authoritative semantic-space size, and do not describe the semantic artifact as GO. The 126/126 and host numeric results are reproducible audit evidence, but their presentation in a paper must state the unresolved action-count gate rather than implying complete artifact acceptance.

Do not put analytical fixture ranking, historical CNN/GPT/FFT values, native speedups, per-layer contribution claims, or matched end-to-end performance into current paper tables. Resource replication, dynamic spatial/temporal policies, selected-candidate materialization and native replay, matched baseline, and full paper table generation remain incomplete. RTL simulation is optional and is **not** a final artifact gate; a future native mapper replay must use its own measured evidence and cannot be replaced with an analytical estimate.
