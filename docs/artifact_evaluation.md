# Artifact evaluation guide

## Claims

The artifact evaluates front-end semantic graph enumeration, executable MLIR witness replay, exact C++ graph facts, generated Taskflow host execution, and a one-element fault control for the canonical static 8×8×8 i32 GEMM-to-elementwise pipeline. It makes no backend, RTL, native cost, or whole-workload speedup claim.

## Hardware and software requirements

A Linux workstation with 16 GiB RAM, several CPU cores, and 20 GiB free disk is a practical starting point. A cold LLVM build can need more. Install Git, Python 3.10+, CMake, Ninja, Clang/C++17, and a network path to GitHub. LLVM/MLIR and AMOEBA commits are fixed in `config/sources.lock`. The supported setup is native Linux; no Docker validation is claimed.

## Setup

```bash
./artifact.sh doctor
./artifact.sh setup
./artifact.sh build
```

If a pinned LLVM build already exists, set `ORBIT_LLVM_BUILD` to its build directory before setup. `doctor` writes `results/environment.json`. `setup` refuses dirty or wrong-commit source directories. Build output remains under `.work/build`; source under `.work/amoeba`.

## Smoke test

```bash
./artifact.sh smoke
```

Read the newest `results/*-smoke/run.json`, `validation.json`, `tables/correctness.md`, and `commands.jsonl`. The negative control must detect exactly one mismatch. The selected graphs are truly compiled through the pinned C++ host lowering and run by `mlir-runner`.

## Full reproduction

```bash
./artifact.sh reproduce semantic
./artifact.sh validate
./artifact.sh tables
```

The full command can take tens of minutes or longer. It creates a new timestamped result directory on every invocation. `run.json.status=completed` only means all execution stages finished; `validation.json.pass` is the frozen-invariant verdict. A mismatch exits nonzero and remains visible. Do not change expected values to make validation pass.

## Result interpretation

The source manifest owns action counts and graph IDs. The artifact derives semantic, execution, and negative-control summaries from the fresh manifest and audits. Tables consume only these JSON results. Compare `semantic_summary.json`, `execution_summary.json`, `negative_control.json`, `validation.json`, and `test_summary.json`. The pinned closure source previously recorded 5,920 actions, while this evaluation's frozen expected file requires 5,280; a fresh reproduction may therefore finish computation but fail the exact verdict.

## Expected failures and skips

The broader joint scheduling lit directory and optional PyTorch/`torch_mlir` cases are outside the core verdict. Missing optional modules are recorded as `optional_dependency_missing`; six historical broader-suite failures are not called passes. The canonical fixture without `RUN` is not treated as a test. See [optional dependencies](optional_dependencies.md).

## Troubleshooting

Use `run.json.error` and `logs/` for the first failing command. Check `commands.jsonl` for its exact argv and cwd. See [troubleshooting](troubleshooting.md).

## Cleanup

```bash
./artifact.sh clean-results
```

This removes only recognized generated result directories. It leaves source, build caches, and reference metadata intact.

