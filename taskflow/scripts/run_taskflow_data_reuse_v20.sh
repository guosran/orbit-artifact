#!/usr/bin/env bash
set -euo pipefail
mode=${1:?usage: run_taskflow_data_reuse_v20.sh generate|npu|cpu ARGS}; shift
script_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
if [[ "$mode" == cpu ]]; then
  [[ $# -ge 3 && $# -le 4 ]] || { echo 'cpu requires CORE_BUILD AIR_BUILD NEW_OUTPUT [PRESERVED_AMOEBA_TOOL]' >&2; exit 2; }
  core_build=$(realpath "$1")
  air_build=$(realpath "$2")
  cpu_output=$(realpath -m "$3")
  bash /home/shiran/project/orbit/scripts/run-subgraph-execution-v19-cpu.sh "$@"
  source /home/shiran/project/aie-toy/scripts/env.sh
  python3 /home/shiran/project/orbit/test/TaskflowGeneric/pure_order_reuse_v20.py \
    --tool "$core_build/tools/taskflow-opt/taskflow-opt" \
    --air-tool "$air_build/tools/taskflow-opt/taskflow-opt" \
    --output "$cpu_output/pure-order-v20"
  exit 0
fi
source /home/shiran/project/aie-toy/scripts/env.sh
case "$mode" in
  generate) exec python3 "$script_root/generate_data_reuse_study_v20.py" "$@";;
  npu) exec timeout --signal=TERM --kill-after=10s 120s python3 "$script_root/taskflow_data_reuse_probe_v20.py" "$@";;
  *) echo 'mode must be generate, npu or cpu' >&2; exit 2;;
esac
