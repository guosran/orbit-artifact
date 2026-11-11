# Public ProgramGraph joint v23 evidence

See [the validation and reproduction report](../../docs/taskflow-program-joint-v23-validation.md).
`inputs/` holds the two source graphs/five target cases. `hardware/` contains
frozen selected/baseline public plans, realization manifests, final AIE receipts,
toolchain/compiler records and both fresh-process numerical results. `cpu/`
contains23 solver-on/off contracts and16 scaling runs. The three AIE contract
files contain39 positive/corruption cases. Core44/combined61 are in `regressions/`.

The accepted full output is `results/taskflow/program-joint-v23/delivery-final`;
`DELIVERY.json` and `raw-manifest.json` bind all full output arrays and compiler
artifacts. Prior pilots and the failed one-launch host-temporary compilation are
preserved. Source/binary identities are in `compiler-source.json`.

Model optimality is finite and assumption-driven. Hardware correctness is
established for the stated pointwise subset; hardware acceleration is not.
