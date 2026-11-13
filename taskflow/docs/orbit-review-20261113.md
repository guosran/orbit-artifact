# ORBIT review artifact, 2026-11-13

This directly published artifact accompanies the final ORBIT implementation review.
Compiler PRs cover the abstraction and search, including all applicable fixes and
correctness tests from their first version. The 22 development commits and former
size buckets do not prescribe one PR each. See [the feature plan](orbit-amoeba-pr-plan.md)
and [the review findings](orbit-amoeba-review-2026-11.md).

The final runtime entry points are `../scripts/execute-heterogeneous.py` and
`../scripts/qwen-node-runtime.py`; their CPU contracts are under `../test/TaskflowGeneric/`.
They are byte-identical to the reviewed compiler checkout. They do not implement
another planner or search algorithm. Old receipts still require their matching
source/runtime identity; this publication does not rewrite their measurements.

CPU validation: the reviewed compiler passed 62 regression groups and 41 lit tests;
298 changed C++/header files passed LLVM clang-format checks. Runtime ownership and
Qwen source-binding contracts passed 39 tests, rerun from this artifact checkout.
There is no new board measurement. Qwen source checks require the original pinned
vendor source checkout and otherwise skip explicitly.

## Archived development history

The portable [CPU evidence archive](../evidence/orbit-review-20261113/cpu-review-evidence.tar.gz)
contains small failure reproducers, source patches, review ledgers and final logs.
Its [receipt](../evidence/orbit-review-20261113/cpu-review-evidence.json) records the
archive digest and exact source/tool binding; `CONTENTS.json` records each member.
Bulk generated IR and full run data remain in ignored `.work/source-snapshots/`;
the portable selection lists exclusions and preserves the full archive digest.

The [original tracked source](../evidence/orbit-review-20261113/original-source-e850af2.tar.gz)
and [its manifest](../evidence/orbit-review-20261113/original-source-e850af2.manifest.json)
preserve removed prototypes and progress logs. The base revision is `e850af2ae623`;
the source tar expands to an `orbit-frozen/` directory. Applying
`reviewed-source.patch` from the CPU bundle inside that directory reconstructs
the reviewed implementation `2043e8ea32d4`. All 813 resulting tracked files
were compared to Git blob identities; see [publication validation](../evidence/orbit-review-20261113/publication-validation.json). Original hardware timing and numerical receipts
retain their original sources; CPU failure reproducers do not constitute speedups.

Run the newly published CPU contracts with a Python providing NumPy/ml_dtypes:

```sh
python taskflow/test/TaskflowGeneric/execute_heterogeneous_v32.py
python taskflow/test/TaskflowGeneric/qwen_node_runtime_v33.py
```
