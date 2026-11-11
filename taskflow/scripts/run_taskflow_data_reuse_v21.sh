#!/usr/bin/env bash
# Clean entry: compiler-only study, actual compilation, or frozen device replay.
set -euo pipefail
if [[ ${ORBIT_V21_CLEAN_ENTRY:-} != 1 ]]; then
  exec env -i HOME="$HOME" PATH=/usr/bin:/bin ORBIT_V21_CLEAN_ENTRY=1 \
    /bin/bash --noprofile --norc "$0" "$@"
fi
[[ $# -gt 0 ]] || { echo 'usage: run_taskflow_data_reuse_v21.sh cpu|matrix|compile|freeze|npu [options]' >&2; exit 2; }
mode=$1; shift
script_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
artifact_root=$(realpath "$script_root/../..")
orbit_root=$(realpath "$artifact_root/../orbit")
aie_root=$(realpath "$artifact_root/../aie-toy")
output= protocol= core_build= air_build= core_tool= air_tool= config= compiled_index= kind=evaluation
matrices=(); extra=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output) output=$(realpath -m "$2"); shift 2;;
    --protocol) protocol=$(realpath "$2"); shift 2;;
    --compiled-index) compiled_index=$(realpath "$2"); shift 2;;
    --core-build) core_build=$(realpath "$2"); shift 2;;
    --air-build) air_build=$(realpath "$2"); shift 2;;
    --core-tool) core_tool=$(realpath "$2"); shift 2;;
    --air-tool) air_tool=$(realpath "$2"); shift 2;;
    --config) config=$(realpath "$2"); shift 2;;
    --matrix) matrices+=(--matrix "$(realpath "$2")"); shift 2;;
    --kind) kind=$2; shift 2;;
    --program|--strategy|--budget|--tile-generator) extra+=("$1" "$2"); shift 2;;
    --wall-window-confirmed|--include-reference) extra+=("$1"); shift;;
    *) echo "Unknown argument: $1" >&2; exit 2;;
  esac
done
[[ -n "$output" && ! -e "$output" ]] || { echo '--output must be a new directory.' >&2; exit 2; }
cd "$orbit_root"
case "$mode" in
  cpu)
    [[ -n "$core_build" && -n "$air_build" ]] || { echo 'cpu requires both build directories.' >&2; exit 2; }
    exec bash "$orbit_root/scripts/run-subgraph-execution-v19-cpu.sh" "$core_build" "$air_build" "$output";;
  matrix)
    [[ -x "$core_tool" && -f "$config" && -f "$protocol" ]] || { echo 'matrix requires --core-tool --config --protocol.' >&2; exit 2; }
    exec /usr/bin/python3 "$script_root/run_data_reuse_search_matrix_v21.py" \
      --tool "$core_tool" --config "$config" --protocol "$protocol" --output "$output" --kind "$kind" "${extra[@]}";;
  compile)
    [[ -x "$air_tool" && ${#matrices[@]} -gt 0 ]] || { echo 'compile requires --air-tool and --matrix.' >&2; exit 2; }
    source "$aie_root/scripts/env.sh"
    exec python "$script_root/compile_data_reuse_representatives_v21.py" \
      "${matrices[@]}" --air-tool "$air_tool" --output "$output" "${extra[@]}";;
  npu)
    [[ -f "$protocol" ]] || { echo 'npu requires --protocol FROZEN.json.' >&2; exit 2; }
    source "$aie_root/scripts/env.sh"
    # Observer owns /tmp/npu.lock. An outer flock would deadlock it.
    exec timeout --signal=TERM --kill-after=10s 120s python \
      "$script_root/taskflow_data_reuse_probe_v21.py" --protocol "$protocol" --output "$output";;
  freeze)
    [[ -f "$compiled_index" && -f "$protocol" ]] || { echo 'freeze requires --compiled-index and --protocol (experiment design).' >&2; exit 2; }
    source "$aie_root/scripts/env.sh"
    exec python "$script_root/freeze_data_reuse_implementations_v21.py" \
      --compiled-index "$compiled_index" --experiment-protocol "$protocol" --output "$output";;
  *) echo 'Modes: cpu, matrix, compile, freeze, npu' >&2; exit 2;;
esac
