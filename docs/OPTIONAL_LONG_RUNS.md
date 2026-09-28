# Optional long runs

The current semantic core does not require PyTorch, VectorCGRA RTL, blocked-GEMM, or full-workload native mapping. Final artifact acceptance does not require RTL. Future full-system publication may require long native mapper runs for selected candidates and matched baselines. Those runs must use durable per-case output and `resume`, retain censored failures as null cost, and identify exact source/backend protocols. A separate VectorCGRA DMA/SPM study cannot substitute for a multi-CGRA NoC measurement.

This repository has not measured durations or disk for those future runs. Their resource estimates and commands will be added only after the source/protocol audit and a pilot case complete.
