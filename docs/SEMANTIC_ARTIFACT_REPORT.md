# ORBIT semantic artifact report

**SEMANTIC MODULE NO-GO.** The fresh run completed computation; frozen validation failed.

Artifact repository: `https://github.com/guosran/orbit-artifact`, branch `main`, checkpoint tag `semantic-closure-v0.1`. Source: `git@github.com:guosran/amoeba.git` at `a57376e7043b1681e64e7169c5a8cb02eb192331`. Artifact harness commit used by the run: `af2e01b03490f8f7d7d7b23193f447efd9052429`. Full result: `results/2026-09-28T193254+0800-semantic`. Smoke result: `results/2026-09-28T193132+0800-smoke`.

| Invariant | Observed | Frozen expected |
|---|---:|---:|
| Action attempts | 5920 | 5280 |
| Unique semantic graphs | 126 | 126 |
| Materialized witnesses | 126 | 126 |
| MLIR verifier passes | 126 | 126 |
| C++ graph fact matches | 126 | 126 |
| Host executions | 504 | 504 |
| Element comparisons | 172800 | 172800 |
| Numeric mismatches | 0 | 0 |
| Negative injected | 1 | 1 |
| Negative detected | 1 | 1 |

The first validation difference is `attempted_actions: expected 5280, observed 5920`. The expected file was not changed. Smoke validation: `True` (6 graphs, 24 host executions, 5632 element comparisons, 0 mismatches, negative control 1). The full run recorded 114 focused Python passes and 2 focused lit passes. Optional dependency state: `optional_dependency_missing`; six historical broader-suite cases remain out of scope and were not rerun or marked passed. Full wall time: 50.182 seconds.

The source was fetched into a new checkout with pinned Neura, and this run used a new Python virtual environment. The C++ optimizer was built in a separate artifact build directory. Docker reproduction was not verified. Reproduce with `./artifact.sh setup && ./artifact.sh build && ./artifact.sh smoke semantic && ./artifact.sh reproduce semantic`. The result is limited to the canonical static 8×8×8 i32 front end; no backend performance, RTL, or whole-workload speedup is inferred. Tables under the result directory are generated from its JSON summaries.

The action ledger reconciles the difference as 32 graph IDs gaining one 20-action re-expansion each: 64 added accepted duplicate-output calls and 576 added deterministic rejections. The old and current ledgers each contain 3960 distinct canonical input/action combinations. Every added combination already appeared in the old ledger; the two fresh current enumerations agree exactly. This does not satisfy the frozen contract. See `ACTION_COUNT_PROVENANCE.md` and `ACTION_COUNT_RECONCILIATION.md`.
