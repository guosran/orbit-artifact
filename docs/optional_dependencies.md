# Optional PyTorch scope

The front-end semantic artifact uses Python, C++ MLIR passes, LLVM tools, and host JIT execution. PyTorch and `torch_mlir` are optional for this scope. `doctor` records each module and the aggregate `optional_dependency_state`; missing modules do not make `doctor`, smoke, or full core execution fail.

The supplied task context reports six existing broader joint scheduling lit failures caused by missing optional PyTorch/`torch_mlir`. The older local closure report describes six broader lit failures differently, as FileCheck/schema mismatches. We do not investigate or repair that suite in this artifact. Its failures are excluded from the semantic verdict and are never shown as passing. `test_summary.json` records six historical broader cases as **out of scope**, with `broader_lit_executed=false` and `optional_skipped=0`; no lit skip is invented.

If both modules are installed and the reviewer wants the broader scope, run an opt-in command from the configured build:

```bash
"$ORBIT_LLVM_BUILD/bin/llvm-lit" -sv "$ORBIT_BUILD_DIR/test/multi-cgra/taskflow/joint-scheduling"
```

Set the two variables to the actual build paths first. This optional command is not included in core validation and may retain historical failures.
