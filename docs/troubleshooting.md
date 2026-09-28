# Troubleshooting

| Symptom | Check |
|---|---|
| Source checkout rejected | Compare `git rev-parse HEAD` with `config/sources.lock`; inspect `git status --short`. Use a new checkout; never reset a valuable dirty tree. |
| GitHub clone cannot connect | Check DNS, SSH or HTTPS access, and mirror environment variables. Existing clean pinned source can be selected with `ORBIT_SOURCE_DIR`. |
| LLVM config missing | Build the pinned LLVM/MLIR revision or set `ORBIT_LLVM_BUILD` to its build directory. |
| CMake cannot find Neura | Run `./artifact.sh setup`; the pinned Neura submodule is required. Predictor and nested benchmark submodules are not required for semantic evaluation. |
| Python syntax error | Set `ORBIT_PYTHON` to Python 3.10 or newer. |
| Run exits nonzero | Inspect the newest run's `run.json.error`, `commands.jsonl`, and `logs/`. An incomplete run cannot validate. |
| 5,920 vs 5,280 actions | This is the known pinned-source/frozen-expectation conflict. Keep both values, report the failed invariant, and resolve it in a separately reviewed source or expectation decision. |
| Optional modules absent | Expect `optional_dependency_missing`; core semantic evaluation proceeds. |
