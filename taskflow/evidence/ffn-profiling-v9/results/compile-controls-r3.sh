#!/usr/bin/env bash
set -euo pipefail
cd /home/shiran/project/orbit-artifact
out=$PWD/results/taskflow/ffn-profiling-v9
for dir in "$out"/controls-input-r3/{train,holdout}-*; do
 name=$(basename "$dir")
 echo "COMPILING $name"
 if ! bash taskflow/scripts/run_taskflow_direct_air_v6_case.sh --compile-only --diagnostic --input "$dir" --output "$out/controls-compiled-r3/$name" --tool "$out/frozen-tools/taskflow-opt" --target-config "$dir/target.json" --runtime-transfer-audit; then
  echo "FAILED $name"
 fi
done
