#!/usr/bin/env bash
set -euo pipefail
cd /home/shiran/project/orbit-artifact
source /home/shiran/project/aie-toy/scripts/env.sh
out=$PWD/results/taskflow/ffn-profiling-v9
tool=$out/frozen-tools/taskflow-opt-v9-final-r1
python taskflow/test/TaskflowAIR/prepare_v6.py --case gemm --m 5 --k 129 --n 16 --output "$out/mixed-control-inputs-r1/k-tail"
python taskflow/test/TaskflowAIR/prepare_v6.py --case add-scale --m 64 --n 64 --output "$out/mixed-control-inputs-r1/add-scale"
printf '%s\n' '{"generic_air":{"tile_sizes":[2,16,64]}}' > "$out/mixed-control-inputs-r1/k-tail/target.json"
printf '%s\n' '{"generic_air":{"tile_sizes":[8,32,64]}}' > "$out/mixed-control-inputs-r1/add-scale/target.json"
for name in k-tail add-scale; do
 bash taskflow/scripts/run_taskflow_direct_air_v6_case.sh --compile-only --diagnostic --input "$out/mixed-control-inputs-r1/$name" --output "$out/mixed-control-compiled-r1/$name" --tool "$tool" --target-config "$out/mixed-control-inputs-r1/$name/target.json" --distribute-initialization --implementation scalar-product-vector-add-f32 --vector-lanes 8 --runtime-transfer-audit
 python taskflow/test/TaskflowAIR/audit_storage_v6.py "$out/mixed-control-compiled-r1/$name/hardware" --plan "$out/mixed-control-compiled-r1/$name/plan.json" --output "$out/mixed-control-compiled-r1/$name/storage-audit.json"
done
bash taskflow/scripts/run_taskflow_direct_air_v6_case.sh --compile-only --diagnostic --input "$out/inputs/trace-gemm" --output "$out/mixed-trace-source-r1" --tool "$tool" --target-config "$out/target.json" --distribute-initialization --implementation scalar-product-vector-add-f32 --vector-lanes 8 --runtime-transfer-audit
