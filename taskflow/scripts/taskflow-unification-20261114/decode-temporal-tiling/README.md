# Full-decoder temporal tiling adapter (compiler-only)

These scripts preserve the full original Qwen AIR decoder ABI and strip-mine
weight-distribution / projection K-block loops. They do not replace the fixed
intrinsic microkernel, its Q4 packing, attention recurrence or KV-cache logic.
The test independently interprets before/after event order and rejects stale
source/replay bindings. A transformed AIR example and its provenance are in the
corresponding evidence directory. No physical compile, board execution or
speedup is established for this decoder adapter. Further search and performance
work is paused by user instruction.

Run in the installed AIR Python environment:

```sh
python taskflow-decode-tiling-test.py --original-dir /absolute/pinned-decoder-emission
```

The directory must contain source.air.mlir, request.json and emitted.json from
the original full-decoder emission. Inputs are authenticated by the adapter;
a different graph must not reuse the saved example's source identity.
