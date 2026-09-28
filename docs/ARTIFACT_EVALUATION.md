# ORBIT full-system artifact evaluation

## Claims and present gate

The repository is structured for seven independently validated modules: semantic rewrite, shape/replication, spatial orchestration, temporal scheduling, cost/ranking, selected native replay, and paper reproduction. Run `./artifact.sh status` for machine-derived module verdicts. Current source-backed resource/spatial/temporal fixtures are limited to small cases; there is no complete replica/policy/replay/paper path at the pinned source. Full-system GO is unavailable. RTL simulation is optional and is not an acceptance gate; native mapper replay remains a separate required evidence class.

## Hardware and software

Use Linux, Python 3.10+, CMake, Ninja, Clang/C++17, Git, and pinned LLVM/MLIR. A cold LLVM build may require hours and more than 20 GiB disk. For the current 4×4 backend fixtures, the architecture is 16 physical CGRAs; each has a mapper-visible 4×4 PE tile. The per-task cap is set separately, commonly four CGRAs. Docker has not been validated on this host.

## Setup and smoke

```bash
./artifact.sh doctor
./artifact.sh setup
./artifact.sh build
./artifact.sh smoke semantic
./artifact.sh smoke backend
./artifact.sh smoke scheduler
./artifact.sh status
```

The backend smoke command records completed source-backed shape, placement/route, and analytical fixture runs but returns nonzero until selected native replay is included. Inspect each `results/<run>/validation.json`: `pass=true, scope=fixture_only` means its small fixture passed, not that the full module passed.

## Reproduction tiers

```bash
./artifact.sh reproduce semantic
./artifact.sh reproduce resource
./artifact.sh reproduce spatial
./artifact.sh reproduce temporal
./artifact.sh reproduce cost
./artifact.sh reproduce replay
./artifact.sh reproduce core
./artifact.sh reproduce paper
./artifact.sh reproduce full
```

The semantic command is a real 126-graph, four-case host run. Resource uses a one-task 4×4 shape fixture with explicit four-CGRA per-task cap. Spatial uses a two-task placement fixture plus one routed channel. Temporal checks a resource-release event. Cost currently runs a declared analytical fixture; the production score pass's file-hash protocol is not used. Replay/core/paper/full fail closed pending adapters and comparable native evidence.

## Result interpretation and expected failures

`run.json` and `validation.json` distinguish completed execution from passed frozen invariants. Semantic may complete all numeric checks but fail the frozen 5,280 action count because the pinned source emits 5,920. Missing PyTorch/`torch_mlir` is optional scope and does not explain or mask that mismatch. Broad lit failures are not counted as passing. See [semantic AE instructions](artifact_evaluation.md), [comparability](RESULT_COMPARABILITY.md), and [evidence classes](EVIDENCE_CLASSES.md).

## Long runs, troubleshooting, cleanup

No full workload or RTL long run is scheduled. Future plans use independent case files and `./artifact.sh resume <run-directory>`; completed cases are skipped and interrupted cases remain incomplete. See [long-run status](LONG_RUN_STATUS.md). Use `commands.jsonl` and `logs/` to diagnose failures. `./artifact.sh clean-results` removes only recognized generated runs; it leaves source/build caches and checked-in reference metadata.
