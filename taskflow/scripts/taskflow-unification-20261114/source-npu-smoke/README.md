# Public Taskflow source to AIR/AIE smoke

`pointwise64.mlir` is a source-owned counter/hyperblock graph computing
`Y = (X + X) * (X + X)` with a private intermediate, FP32 64×64 tensors,
and an initial physical tile of 32×32. The capacity contract is 24 KiB.
This path targets AIR → AIE. It does not use the Neura/AmoebaCGRA backend.

Use the installed AIR toolchain environment before each command:

```sh
source /home/shiran/project/aie-toy/scripts/env.sh
python run.py --tool /tmp/orbit-review-full-build/tools/taskflow-opt/taskflow-opt \
  --output /absolute/new/evidence/path --stage prepare
python run.py --tool /tmp/orbit-review-full-build/tools/taskflow-opt/taskflow-opt \
  --output /absolute/new/evidence/path --stage compile --cases original
python run.py --tool /tmp/orbit-review-full-build/tools/taskflow-opt/taskflow-opt \
  --output /absolute/new/evidence/path --stage execute --cases original
```

Preparation materializes the public fusion, fission and source tiling passes,
normalizes/checks AIR for each original structural form, then runs the common
source search with native mapping and task-local tile proposals. Selected
sources are lowered and checked again. The theoretical coefficients select
contracts; they are not calibration or evidence of speedup. Shape is explicitly
1×1 because this adapter does not implement arbitrary physical placement.

Compilation invokes the existing direct AIR executor, converts the actual final
`npu.input.air.mlir` to generic syntax, then calls the independent production
C++ AIE checker against the selected normalized source. SHA256 bindings cover
source, AIR, actual AIE, ELF and the checker receipt. Execution verifies these
bindings, owns `/tmp/npu.lock`, and compares three independent CPU reference
inputs, with one numerical correctness launch per seed and no warmups. Search optimization
is paused; this execution phase performs no performance comparison. Timings of this small
smoke should not be interpreted as Qwen performance.

The fission fixture splits the original `double` DFG after its load/add.
The later compiler change also repairs fusion→fission composition; this
campaign preserves its earlier selected sources and ELFs and does not claim
that the board run exercises that new composition path. Arbitrary physical
placement, intrinsic decoder kernel block changes and full Qwen performance
are outside this numerical smoke.

The completed campaign passed all four independent final AIE checks, the
repeated-BD positive case and nine negative mutations, and 12 board numerical
checks (four forms × three seeds). Every output matched the independent CPU
reference exactly. See the results namespace's `campaign-status.json` and
`artifact-allowlist.json`. Search optimization remained paused during recheck
and board validation.
