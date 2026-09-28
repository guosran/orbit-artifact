# Long-run status

No full-workload native mapper, RTL, or blocked-GEMM long run has been started by this artifact. They are pending audit and protocol selection. Existing saved results are not promoted into current paper evidence.

The `./artifact.sh resume <run-directory>` interface consumes a `plan.json` of independent cases. It writes each case's argv, cwd, PID, start/end, exit status, and logs before and after execution, skips completed cases on resume, and leaves interrupted/failed cases incomplete or failed. This mechanism is tested with tiny fixtures; it is not evidence that a native long run has completed. A future long run should declare expected wall time, disk, memory, parallelism, and case IDs in its plan before launch.

