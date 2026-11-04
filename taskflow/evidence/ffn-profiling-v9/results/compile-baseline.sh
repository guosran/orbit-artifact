#!/usr/bin/env bash
set -euo pipefail
cd /home/shiran/project/orbit-artifact
source /home/shiran/project/aie-toy/scripts/env.sh
out=$PWD/results/taskflow/ffn-profiling-v9
printf '%s\n' '{"generic_air":{"tile_sizes":[8,64,64]}}' > "$out/target.json"
for m in 1 5 8; do
  OPENBLAS_NUM_THREADS=1 python taskflow/test/TaskflowAIR/prepare_ffn_stages_v7.py --m "$m" --seeds 11 23 47 --output "$out/inputs/m$m"
  for stage in gate up activation down full; do
    echo "COMPILING m$m $stage"
    bash taskflow/scripts/run_taskflow_direct_air_v6_case.sh --compile-only --diagnostic --input "$out/inputs/m$m/$stage" --output "$out/baseline/m$m/$stage" --tool "$out/frozen-tools/taskflow-opt" --target-config "$out/target.json" --distribute-initialization --approx-exp --runtime-transfer-audit
  done
done
