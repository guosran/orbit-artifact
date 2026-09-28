# Pinned source inventory

Audit target: `git@github.com:guosran/amoeba.git`, branch hint `orbit/joint-semantic-closure`, commit `a57376e7043b1681e64e7169c5a8cb02eb192331`. The existing original AMOEBA checkout is dirty and was not used or altered. The historical `SEMANTIC_CLOSURE_REPORT.md` and `publication_provenance.json` were read from an earlier local review directory; they are context, not inputs to the artifact run.

| Ownership | Item | Entry or source |
|---|---|---|
| Source-owned functionality | Canonical 8×8×8 i32 Taskflow fixture | `test/multi-cgra/taskflow/joint-scheduling/orbit_joint_pipeline_8x8_i32.mlir` |
| Source-owned functionality | C++ action enumeration, legality, deduplication, graph IDs | `EnumerateJointSemanticRewritePass.cpp`; `--enumerate-joint-semantic-rewrites` |
| Source-owned functionality | Standalone M/N/K tiling and fusion, executable witness materialization | `MaterializeJointSemanticRewritePass.cpp`, `JointReductionRewritePasses.cpp`; witness pass pipelines in manifest |
| Source-owned functionality | C++ typed graph facts | `ExtractJointTaskGraphFactsPass.cpp`; `--extract-joint-task-graph-facts` |
| Source-owned functionality | Exact comparison | `tools/orbit_joint_witness_audit.py` and `tools/orbit_joint_facts_compare.py` |
| Source-owned functionality | Host lowering and task-write snapshots | `LowerJointTaskflowForHostPass.cpp`; `--lower-joint-taskflow-to-host-scf=capture-task-states` |
| Source-owned functionality | Four-case host JIT numeric audit and deliberate fault | `tools/orbit_joint_host_numeric_audit.py`; invokes `mlir-opt` and `mlir-runner` |
| Source-owned tests | 114 collected Python tests | Ten `tools/test_*.py` files, run by pytest |
| Source-owned tests | Two focused lit tests | `orbit-joint-standalone-passes.mlir`, `host-lowering.mlir` |
| Artifact-owned orchestration | Pin checks, build, smoke/full run, logging, collection, validation, tables | `artifact.sh`, `scripts/`, `schemas/` |
| Checked-in reference metadata | Expected invariants and 126 graph IDs | `config/expected_semantic_closure.json`, `reference/semantic_closure_summary.json` |
| Reproduction-generated output | Fresh manifest, witness replay, JIT audit, summaries, logs | `results/<run>/`; gitignored |

The manifest's `statistics.action_attempts` and `candidates` produce action and graph counts. Witness replay records produce materialized, verifier, and fact-match counts. Numeric records provide `candidate_case_comparisons` and per-graph `element_checks_per_case`/mismatch counts; the negative control has its own observed mismatch count. The harness derives every summary and table from these machine outputs. It strips pre-existing source manifest file-hash fields from retained results and never uses them as artifact identity.

**Frozen-count discrepancy:** the earlier `orbit/joint-tiling-fusion-mlir-passes` checkpoint yielded 5,280 attempts; the pinned semantic-closure commit's source-owned manifest recorded 5,920 attempts with the same 126 graph IDs. The latter source commit changed sequential-K action/replay behavior. This is a source-versus-expected invariant conflict, not permission to update the frozen expectation. The fresh artifact validator reports the first observed difference.

The older local report describes six broader lit failures as legacy FileCheck/schema issues, while the supplied task context attributes six failures to missing PyTorch/`torch_mlir`. We do not rerun or diagnose that broad suite here. Its six failures and one fixture without a `RUN` line are outside the core semantic verdict; they are not counted as passing. See [optional dependencies](optional_dependencies.md).
