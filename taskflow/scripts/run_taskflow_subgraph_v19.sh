#!/usr/bin/env bash
# New output only; compile/check is CPU, only npu acquires the existing observer lock.
set -euo pipefail
mode=${1:?usage: run_taskflow_subgraph_v19.sh generate|freeze|npu ARGS}; shift
script_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source /home/shiran/project/aie-toy/scripts/env.sh
case "$mode" in
 generate) exec python3 "$script_root/generate_subgraph_study_v19.py" "$@";;
 freeze) exec python3 "$script_root/taskflow_subgraph_probe_v19.py" "$@";;
 npu) exec timeout --signal=TERM --kill-after=10s 120s python3 "$script_root/taskflow_subgraph_probe_v19.py" "$@";;
 *) echo 'mode must be generate, freeze or npu' >&2;exit 2;;
esac
