# Public physical placement and persistent-state correctness smoke

`waves.py` uses the normal `taskflow-opt --lower-program-to-air=<directory>`
entry point. The C++ adapter transforms the immutable source, constructs one
source-backed global physical ProgramGraph, proves configuration cuts, and emits
`waveN.air.mlir`. Python does not choose graph transformations, placement, cuts,
or compute kernels.

Each actual AIR file is compiled by the installed AIR→AIE compiler. Its final
AIE is independently checked with the original source, target configuration,
`--check-placed-wave=N`, and `--check-aie=<final generic AIE>`. The checker rebuilds
the global graph and deterministic configuration ranges rather than trusting the
artifact manifest. The global manifest, actual AIR/AIE, ELF, and independent
checker receipts are hashed before execution.

Execution takes `/tmp/npu.lock` itself. All waves run serially, one actual device
submission per wave and no warmup. A single set of actual XRT device BOs survives
all waves; traces assert that only the first wave stages host data. State sources
also retain that same BO across three complete calls. The test uses three seeds
and compares final device values with independent NumPy references. Trace clocks
are for submission/synchronization evidence; this experiment makes no speedup or
performance claim.

`run.py` is the earlier single-ELF preparation driver, retained as preparation
history. The current global-graph validation must use `waves.py` and normal CLI
output, including the 2-column × 3-row source and state repeated-call source.

Example (after compiling the focused C++ fixture generator and tool):

```
python waves.py --stage compile --tool /path/to/taskflow-opt \
  --source /path/to/source.mlir --target /path/to/target.json \
  --output /new/result/directory
python waves.py --stage execute --tool /path/to/taskflow-opt \
  --output /new/result/directory
```

Current status: scripts syntax-checked; actual new multicore compilation and
board numerical validation are pending. Existing older four-form single-core
success receipts do not certify this new path.
