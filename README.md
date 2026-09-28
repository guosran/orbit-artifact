# ORBIT reproduction artifact

This repository is the reproduction artifact for ORBIT, a cross-layer framework that jointly explores semantic task-graph rewrites, per-task CGRA shapes and DFG replication, spatial placement/routing, and temporal scheduling. The artifact is organized into independently verifiable modules so that semantic correctness, analytical estimates, native mapper replay, and RTL measurements are never conflated.

The current Module A reproduces the front-end semantic closure of joint task tiling, K-reduction, and fusion for the canonical 8×8×8 i32 GEMM-to-elementwise pipeline. It does not claim backend performance or whole-workload speedup. The remaining system modules are under integration. `./artifact.sh status` reads generated validation results; a semantic run alone never yields full-system GO.

| Module | Current state |
|---|---|
| Semantic rewrite | Reproduced; frozen action-count mismatch requires resolution |
| Shape and replication | Pending current-protocol reproduction |
| Spatial orchestration | Pending current-protocol reproduction |
| Temporal scheduling | Pending current-protocol reproduction |
| Cost and ranking | Pending current-protocol reproduction |
| Selected native replay | Pending current-protocol reproduction |
| Paper reproduction | Pending matched results |

The artifact repository owns setup, orchestration, result validation, and tables. The pinned [AMOEBA source](https://github.com/guosran/amoeba/tree/a57376e7043b1681e64e7169c5a8cb02eb192331) owns all rewrite semantics, MLIR passes, graph facts, host lowering, and numeric execution. No source checkout, binary, or runtime log is committed here.

## Requirements

Use a native Ubuntu or compatible Linux host with Git, Python 3.10+, CMake, Ninja, Clang, a C++17 toolchain, at least 16 GiB RAM and roughly 20 GiB free disk for a cold build. LLVM/MLIR is pinned to `6146a88f60492b520a36f8f8f3231e15f3cc6082`. A cold LLVM build can take hours and may need more disk; set `ORBIT_LLVM_BUILD` to a clean build of that exact revision when available. Docker is not part of this validated route.

PyTorch and `torch_mlir` are optional for this semantic artifact. `./artifact.sh doctor` records their status. The core verdict does not run the broader joint scheduling lit directory.

## Smoke path (Module A)

```bash
git clone git@github.com:guosran/orbit-artifact.git
cd orbit-artifact
./artifact.sh doctor
./artifact.sh setup
./artifact.sh build
./artifact.sh smoke semantic
```

Once LLVM is built, smoke should take about 5–10 minutes on a typical workstation. It selects identity, M×N tiling, sequential K state carry, parallel K numeric reduction, tile-local fusion, and reduction-consumer fusion witnesses. It actually host-lowers and JIT-executes their generated Taskflow IR on four inputs, then checks a deliberate one-element fault.

For an already built pinned LLVM tree:

```bash
export ORBIT_LLVM_BUILD=/path/to/llvm-project/build
export ORBIT_PYTHON=/path/to/python3.11
./artifact.sh setup
./artifact.sh build
./artifact.sh smoke
```

`setup` clones source into gitignored `.work/amoeba` and checks out the pinned commit detached. It initializes the required Neura submodule. `ORBIT_SOURCE_DIR` may point to an existing clean checkout at that exact commit. The script refuses a wrong commit or dirty source. `ORBIT_AMOEBA_MIRROR` and `ORBIT_NEURA_MIRROR` support local Git mirrors. The pinned predictor is unused by the semantic build and is fetched only with `ORBIT_FETCH_OPTIONAL_PREDICTOR=1`.

## Full semantic reproduction

```bash
./artifact.sh reproduce semantic
./artifact.sh validate
./artifact.sh tables
```

Full reproduction enumerates the C++ action space, replays and verifies every executable witness, compares exact C++ graph facts, and runs the generated Taskflow IR for every graph on four input sets. It also runs the 114 pinned Python tests and two focused lit fixtures. Allow tens of minutes to a few hours, depending on CPU and LLVM build state.

Each invocation creates a new `results/<timestamp>-{smoke,semantic}/` directory with `run.json`, `environment.json`, `commands.jsonl`, summaries, graph inventory, negative control, tables, and ignored raw/log output. `results/environment.json` is the standalone doctor result. See [expected results](docs/expected_results.md) and the [AE guide](docs/artifact_evaluation.md).

## Full-system command surface and time tiers

```bash
./artifact.sh smoke backend
./artifact.sh smoke scheduler
./artifact.sh reproduce resource
./artifact.sh reproduce spatial
./artifact.sh reproduce temporal
./artifact.sh reproduce cost
./artifact.sh reproduce replay
./artifact.sh reproduce core
./artifact.sh reproduce paper
./artifact.sh reproduce full
./artifact.sh status
./artifact.sh resume results/<long-run-directory>
```

Today the resource, spatial, temporal, and cost commands run small pinned-source fixtures and mark their module outcome **PARTIAL**. `smoke backend` intentionally exits nonzero after those fixtures because selected native replay is not yet available under the no-file-hash contract. `reproduce replay`, `core`, `paper`, and `full` fail closed with missing-module information; they never substitute historical results. `resume` is a tested per-case mechanism for future long runs.

The broader smoke target is 10–20 minutes after setup. The currently executable semantic/backend/scheduler fixtures are shorter on this host, but replay remains a gate. Core and full wall time, disk, memory, and parallelism are **not yet measured** because the required native/full-workload protocols are pending. Long runs will be planned case by case with explicit resource estimates before launch. See [long-run status](docs/LONG_RUN_STATUS.md) and the [full-system AE guide](docs/ARTIFACT_EVALUATION.md).

The frozen expected action-attempt count is **5,280**, while the pinned source's prior machine result reports **5,920**. The validator deliberately keeps 5,280 and fails on the first observed difference. This discrepancy is recorded in [source inventory](docs/source_inventory.md); a fresh run, not the older report, determines the delivered result.

## Scope and citation

The validated scope so far is the static canonical i32 pipeline, its generated semantic graphs, and host numeric checks. The full-system module contracts, evidence taxonomy, and comparability gate are in [system scope](docs/SYSTEM_SCOPE.md), [evidence classes](docs/EVIDENCE_CLASSES.md), and [result comparability](docs/RESULT_COMPARABILITY.md). Dynamic shapes, f32, native cost, RTL, PolyBench, and whole-workload speedup are pending reproduction. See [extension guide](docs/extending_the_artifact.md). Cite the checkpoint through [CITATION.cff](CITATION.cff).

The harness is MIT licensed. AMOEBA, LLVM, Neura, and the predictor retain their own licenses.
