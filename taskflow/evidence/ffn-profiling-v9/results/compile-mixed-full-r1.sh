#!/usr/bin/env bash
set -euo pipefail
cd /home/shiran/project/orbit-artifact
source /home/shiran/project/aie-toy/scripts/env.sh
out=$PWD/results/taskflow/ffn-profiling-v9
for m in 1 5 8; do
 bash taskflow/scripts/run_taskflow_direct_air_v6_case.sh --compile-only --diagnostic --input "$out/inputs/m$m/full" --output "$out/mixed-full-r1/m$m" --tool "$out/frozen-tools/taskflow-opt-v9-final-r1" --target-config "$out/target.json" --distribute-initialization --approx-exp --implementation scalar-product-vector-add-f32 --vector-lanes 8 --runtime-transfer-audit
 python taskflow/test/TaskflowAIR/audit_storage_v6.py "$out/mixed-full-r1/m$m/hardware" --plan "$out/mixed-full-r1/m$m/plan.json" --output "$out/mixed-full-r1/m$m/storage-audit.json"
done
