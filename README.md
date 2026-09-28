# ORBIT semantic artifact

This artifact reproduces the front-end semantic closure of ORBIT’s joint task tiling, K-reduction, and fusion space for the canonical 8×8×8 i32 GEMM-to-elementwise pipeline. It does not claim backend performance or whole-workload speedup.

The artifact repository owns setup, orchestration, result validation, and tables. The pinned [AMOEBA source](https://github.com/guosran/amoeba/tree/a57376e7043b1681e64e7169c5a8cb02eb192331) owns all rewrite semantics, MLIR passes, graph facts, host lowering, and numeric execution. No source checkout, binary, or runtime log is committed here.

## Requirements

Use a native Ubuntu or compatible Linux host with Git, Python 3.10+, CMake, Ninja, Clang, a C++17 toolchain, at least 16 GiB RAM and roughly 20 GiB free disk for a cold build. LLVM/MLIR is pinned to `6146a88f60492b520a36f8f8f3231e15f3cc6082`. A cold LLVM build can take hours and may need more disk; set `ORBIT_LLVM_BUILD` to a clean build of that exact revision when available. Docker is not part of this validated route.

PyTorch and `torch_mlir` are optional for this semantic artifact. `./artifact.sh doctor` records their status. The core verdict does not run the broader joint scheduling lit directory.

## Smoke path

```bash
git clone git@github.com:guosran/orbit-artifact.git
cd orbit-artifact
./artifact.sh doctor
./artifact.sh setup
./artifact.sh build
./artifact.sh smoke
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

`setup` clones source into gitignored `.work/amoeba` and checks out the pinned commit detached. `ORBIT_SOURCE_DIR` may point to an existing clean checkout at that exact commit. The script refuses a wrong commit or dirty source. Separate `ORBIT_AMOEBA_MIRROR`, `ORBIT_NEURA_MIRROR`, and `ORBIT_PREDICTOR_MIRROR` values support local Git mirrors.

## Full semantic reproduction

```bash
./artifact.sh reproduce semantic
./artifact.sh validate
./artifact.sh tables
```

Full reproduction enumerates the C++ action space, replays and verifies every executable witness, compares exact C++ graph facts, and runs the generated Taskflow IR for every graph on four input sets. It also runs the 114 pinned Python tests and two focused lit fixtures. Allow tens of minutes to a few hours, depending on CPU and LLVM build state.

Each invocation creates a new `results/<timestamp>-{smoke,semantic}/` directory with `run.json`, `environment.json`, `commands.jsonl`, summaries, graph inventory, negative control, tables, and ignored raw/log output. `results/environment.json` is the standalone doctor result. See [expected results](docs/expected_results.md) and the [AE guide](docs/artifact_evaluation.md).

The frozen expected action-attempt count is **5,280**, while the pinned source's prior machine result reports **5,920**. The validator deliberately keeps 5,280 and fails on the first observed difference. This discrepancy is recorded in [source inventory](docs/source_inventory.md); a fresh run, not the older report, determines the delivered result.

## Scope and citation

The scope is the static canonical i32 pipeline, its generated semantic graphs, and host numeric checks. Dynamic shapes, f32, backend capability projection, native cost, RTL, PolyBench, and whole-workload speedup are future work. See [extension guide](docs/extending_the_artifact.md). Cite the checkpoint through [CITATION.cff](CITATION.cff).

The harness is MIT licensed. AMOEBA, LLVM, Neura, and the predictor retain their own licenses.

