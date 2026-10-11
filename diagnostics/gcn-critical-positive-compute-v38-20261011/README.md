# GCN critical-positive compute research, Source38

This independent research addon closes the Source38 Replica/Full comparison. Both searches started independently from the canonical GCN program and used **256 objective calls**. Each original five-candidate native shortlist passed all five strict numeric validations.

| Search space | Calls | Best native cycles | Native / numeric validated |
|---|---:|---:|---:|
| Replica | 256 | 920639 | 5 / 5 |
| Full | 256 | 918724 | 5 / 5 |

The same-version difference, **Full − Replica = −1915 cycles**, is recorded in [results.csv](results.csv) and the [matched comparison](matched-comparison/REPORT.json). No free winner, warm start, candidate replacement or historical minimum entered either search. The separate 64-call mechanism diagnostic adds 64 calls, making **576 original objective calls** across these three runs; capture and audit add zero calls.

Source38 changes one compute-target ordering rule: known, supported positive shape opportunities on critical or terminal tasks enter the first tier. Weighted gain and lexical ties remain inside each tier. Shape parameters, legal actions, windows, beam, predictor and evaluator are unchanged by this patch. The [64-call audit](mechanism64/REPORT.json) reconstructed all 284 parent/round catalogues and observed six paid first-tier guided selections, without native or numeric calls.

The [native explanation](reports/source38-full-replica-native-difference/EXPLANATION.md) accounts for the actual completing-chain difference: task duration −1916, transfer +1, reservation wait and residual differences zero. Full selected 17 shape actions and replication of Task14 by two; its winner contains **no fusion, fission or tiling**. The selected geometry is feasible in the Replica space, so these schedules show a different search trajectory rather than direct fusion/fission benefit. [Membership evidence](reports/source38-matched-membership/REPORT.json) still finds the exact Replica winner absent from the Full archive and shortlist, with its first missing typed prefix at depth five. A better final result does not establish that every missed branch was repaired.

The [closed performance report](reports/source38-closed-pair-performance/REPORT.json) records Full search time 3928.00 seconds and 201377 attempts, including 201122 zero-debit attempts; Replica records 350.14 seconds and 4651 attempts, including 4396 zero-debit attempts. These parallel-host observations are not an isolated profile. Zero-debit attempts include legality failures and duplicates. GNU time filesystem outputs remain raw block accounting, not retained bytes or measured bandwidth. The [family audit](reports/source38-action-family-budget/REPORT.json) records 110226 fusion-related attempts with zero materialized/paid candidates; 4122 pending fusion-related entries were unattempted and cannot all be classified as illegal. The prepared fission menu contained zero cuts.

| Role | Public ORBIT commit | Recorded optimizer SHA-256 |
|---|---|---|
| Source38 search | `76345481683a2e199c0cad155de2acb51149f350` | `9996d1b97787242cea42d88511ce530bfa4cb523883705b0746a72a1ff17d7cc` |
| Frozen native mapper/scheduler | `9e7015c3bd4d44dd2ec37df6f02c09aaa0372e55` | `80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761` |

The public search pin is on [diagnostic/v38-critical-positive-compute](https://github.com/guosran/orbit/tree/76345481683a2e199c0cad155de2acb51149f350). [protocol.json](protocol.json) separates actual compiler identity from the captured `6a1b...` predictor/cost namespace. Source proof, patch, actual build dependencies/link/archive receipts, prepared-v1/v2 controls, original native/numeric receipts and independent reports are included. The four prepared manifests retain their exact historical payloads through explicit aliases under `history/`.

Shared canonical inputs are pinned by relative path and SHA in [inputs-reference.json](inputs-reference.json). The published [Source37 package](../gcn-research-resumed-20261011/README.md) remains unchanged, including Replica 922559, Full 931310 and its +8751 negative result. Cross-policy native references remain separate from the matched Source38 comparison. The [original-five predictor audit](reports/source38-replica-original-five-predictor-rank/SUMMARY.json) has zero Top1 regret within those five; it makes no full-archive accuracy claim. The [fusion proof-cache proposal](reports/first-fusion-negative-proof-cache-proposal/REPORT.json) is unimplemented and reports no measured speedup. The [disk-admission receipt](reports/disk-admission-recovery/RECEIPT.json) preserves the unchanged 50-GiB gate and verified lossless archival recovery; its compressed host archives are not bundled.

```sh
python3 diagnostics/gcn-critical-positive-compute-v38-20261011/check_package.py
```

The checker verifies packaged hashes, history, identities, budgets and sealed evidence without running an experiment. Absolute host paths in copied receipts record provenance; public source pins and the [build guide](../../docs/INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md) supply portable code/build context. ELF binaries, caches and large journals/checkpoints are omitted, and fresh-machine end-to-end reproduction has not been tested. This package makes no default, formal or paper admission. The four-program evaluation and Source37 package are unchanged; a separately prepared Tiling256 run is outside this closed pair.
