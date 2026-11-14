# Standalone ORBIT GEMM experiment sources

The adapter consumes the public ORBIT beam implementation. It lives in the artifact repository; no experiment target is required in the compiler repository. The Python runtime and lifecycle tests are colocated here. This directory does not contain a replacement compiler or a full-Qwen graph optimizer.

Configure into a new directory, using a compatible ORBIT checkout and LLVM/MLIR installation:

```sh
cmake -G Ninja -S /path/to/orbit-artifact/taskflow/scripts/taskflow-unification-20261114 \
  -B /tmp/orbit-artifact-gemm-build \
  -DORBIT_SOURCE_DIR=/path/to/orbit \
  -DLLVM_DIR=/path/to/llvm/build/lib/cmake/llvm \
  -DMLIR_DIR=/path/to/llvm/build/lib/cmake/mlir \
  -DORBIT_ENABLE_NEURA=OFF -DORBIT_ENABLE_AIR=OFF \
  -DORBIT_ENABLE_ORTOOLS=OFF -DORBIT_ENABLE_SCIP=OFF
cmake --build /tmp/orbit-artifact-gemm-build --target taskflow-gemm-operator-search -j2
```

The configure step was actually validated with the local LLVM/MLIR installation and all four optional backends/solvers disabled. Configuration and generation passed. The standalone build command above is provided for reproduction and was **not executed**; it can compile the public ORBIT library in its isolated build directory. The already tested frozen adapter binary came from the earlier compiler build. Exact validation commands and log are in `artifact-standalone-commands.json` and `artifact-configure.log` under the corresponding evidence directory.

CPU-only checks, with a Python containing NumPy and ml_dtypes:

```sh
python qwen_gemm_lifecycle.py
python gemm_operator_search.py /path/to/taskflow-gemm-operator-search
```

These passed 9 lifecycle and 4 adapter contract tests after migration. Future domain generation must use this directory's `npu-gemm-runtime.py` via the explicit `--runtime-source` argument. The historical compiler runtime path was restored to its original version; old manifests retain their original path/hash provenance and are not rewritten.

Search and performance work are paused at the user's request. No search, accelerator execution, full-model routing, or additional performance validation was started by the standalone configure check.
