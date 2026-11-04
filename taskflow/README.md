# Taskflow program mapping and direct AIR experiments

This is the companion experiment namespace for the [ORBIT compiler](https://github.com/guosran/orbit). C++/MLIR owns computation semantics, transformations, planning, checking, search and lowering. Python here creates inputs and independent references, launches existing tools/runners, measures, audits and reports.

- `scripts/`: reproduction, execution, measurement and reporting.
- `python/`: execution adapters and shared artifact/core path configuration.
- `test/`: hardware-evidence and real-model experiment checks.
- `docs/`: validation, timing scopes, limitations and reproduction.
- Compiler semantics and small code-generation fixtures stay in `orbit/test`.

The repository's existing `reference/`, `config/`, `diagnostics/`, `scripts/` and `tests/` keep the original input-0 artifact. Model bundles are reused from `reference/input0-neighborhood/models`, with unchanged C++ inference and explicit provenance.

## Reproduction

Clone this repository and `orbit` beside each other. With the documented LLVM/AIR/AIE/XRT installation and Python environment:

```sh
export ORBIT_SRC=/path/to/orbit
export ORBIT_BUILD_ROOT=/path/to/orbit-artifact/builds/taskflow
export ORBIT_RESULTS_ROOT=/path/to/orbit-artifact/results/taskflow
export LLVM_BUILD=/path/to/llvm-project/build
bash taskflow/scripts/run_taskflow_data_organization_v8.sh cpu \
  "$ORBIT_RESULTS_ROOT/NEW_CPU_RUN"
```

`all` additionally executes the two actual compiler-selected residency candidates and the complete M5 FFN regression. Every output directory must be new. Independent Core needs only its compiler checkout and standard-library tests; see `orbit/scripts/build-core.sh`.

See [the v8 validation report](docs/taskflow-data-organization-v8-validation.md), [v7 FFN evidence](docs/taskflow-direct-air-v7-validation.md), and [the reproduction contract](docs/taskflow-program-mapping-reproduce-v7.md). Plan bytes are not hardware DDR-counter measurements. All FP32 tolerance and timing boundaries remain explicit.

## Local archives and migration

Full generated IR, binaries, raw arrays and timings stay in ignored `results/taskflow/`; build caches stay in ignored `builds/` or `.work/legacy/`. On the original host, earlier `orbit/build*`, `orbit-data-v8` and `aie-toy/results/orbit*` references are compatibility symlinks to this storage. Frozen commands, manifests, tools and measurements have not been rewritten. Archived CMake caches are not treated as relocatable fresh builds.

The local migration receipt and all verification logs are in `.work/repository-split/`. Historical source/plan/runtime identities remain distinct from newly compiled tools. This source separation itself makes no new hardware-performance claim.
