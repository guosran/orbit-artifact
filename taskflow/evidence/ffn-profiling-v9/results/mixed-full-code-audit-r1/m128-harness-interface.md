# Existing M128 partition harness interface (not executed here)

The existing program executor consumes a compiler-issued manifest. It has no implementation-selection flag: implementation is already materialized in each template AIR and checked plan. The compiler therefore receives the new choice while lowering the parent M128 program. There is no new runtime, host numerical fallback or subkernel dispatch.

Use fresh output directories. The following is a command template for the main agent, not a record of an execution:

```bash
ART=/home/shiran/project/orbit-artifact/taskflow
RESULT=/home/shiran/project/orbit-artifact/results/taskflow/ffn-profiling-v9
TOOL="$RESULT/frozen-tools/taskflow-opt-v9-final-r1"
PY=/home/shiran/project/aie-toy/.venv/bin/python
OUT="$RESULT/mixed-m128-partition-NEW"
mkdir "$OUT"
"$PY" "$ART/test/TaskflowAIR/prepare_v6.py" --case ffn --m 128 --k 2048 --n 11008 --output "$OUT/input"
"$TOOL" "$OUT/input/source.mlir" --air-distribute-initialization \
  --tile-m=8 --tile-n=64 --tile-k=64 \
  --implementation=scalar-product-vector-add-f32 --vector-lanes=8 \
  --program-partition=8 --air-approximate-exp \
  --lower-program-to-air="$OUT/native-plan"
"$PY" "$ART/scripts/taskflow_direct_air_program.py" \
  --manifest "$OUT/native-plan/manifest.json" \
  --inputs "$OUT/input/inputs-11.npz" --reference "$OUT/input/reference-11.npz" \
  --inputs "$OUT/input/inputs-23.npz" --reference "$OUT/input/reference-23.npz" \
  --inputs "$OUT/input/inputs-47.npz" --reference "$OUT/input/reference-47.npz" \
  --output-dir "$OUT/hardware" --long-acceptance
"$PY" "$ART/test/TaskflowAIR/audit_program_v7.py" "$OUT/hardware" --output "$OUT/hardware/program-audit.json"
"$PY" "$ART/test/TaskflowAIR/audit_metrics_v6.py" "$OUT/hardware" --output "$OUT/hardware/error-metrics.json"
```

`--long-acceptance` requires at least three input/reference pairs, executes one complete M128 pass per seed and uses zero warmups. Ordinary mode instead requires at least three seeds and three hot iterations plus two warmups. `--diagnostic` allows a short explicitly diagnostic run. The existing executor takes `/tmp/npu.lock` around device operations. It compiles each unique template through installed aircc, then runs strict storage and per-stage runtime-transfer audits before acquiring the device lock. It validates manifest output partition coverage, ABI slices, dependencies, template/parent plan identity and counts. Sixteen M8 invocations use full four-stage main kernels and assemble only their independent output slices.

Before execution, inspect the new manifest: one extent8 template, sixteen invocations, scalar activation and initializers, three mixed GEMM tasks at lanes8, complete Y[128,2048] coverage. Bind the newly compiled ELF/source/plan identities. Do not reuse the standalone M8 ELF identity automatically or call the old scalar M128 package a mixed run. Equivalent template IR can be compared, but only the new executor output establishes the actual command package and full-output acceptance.
