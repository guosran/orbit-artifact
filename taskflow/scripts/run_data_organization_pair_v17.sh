#!/usr/bin/env bash
# Replay one exact frozen pair. The Python runner owns /tmp/npu.lock.
set -euo pipefail
DATA_ORGANIZATION_ARTIFACT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
DATA_ORGANIZATION_RESULTS="$DATA_ORGANIZATION_ARTIFACT/results/taskflow/data-organization-v17"
DATA_ORGANIZATION_MODE=cpu
DATA_ORGANIZATION_PAIR=broadcast-m16n512
DATA_ORGANIZATION_PROTOCOL=
DATA_ORGANIZATION_OUTPUT=
while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode) DATA_ORGANIZATION_MODE=$2; shift 2;;
    --pair) DATA_ORGANIZATION_PAIR=$2; shift 2;;
    --protocol) DATA_ORGANIZATION_PROTOCOL=$(realpath "$2"); shift 2;;
    --output) DATA_ORGANIZATION_OUTPUT=$(realpath -m "$2"); shift 2;;
    *) echo "unknown argument: $1" >&2; exit 2;;
  esac
done
[[ "$DATA_ORGANIZATION_MODE" == cpu || "$DATA_ORGANIZATION_MODE" == npu ]] || { echo 'mode must be cpu or npu' >&2; exit 2; }
[[ -n "$DATA_ORGANIZATION_OUTPUT" && ! -e "$DATA_ORGANIZATION_OUTPUT" ]] || { echo '--output must be a new absolute destination' >&2; exit 2; }
if [[ -z "$DATA_ORGANIZATION_PROTOCOL" ]]; then
  DATA_ORGANIZATION_PROTOCOL="$DATA_ORGANIZATION_RESULTS/compiled-pairs-r1/$DATA_ORGANIZATION_PAIR-protocol.json"
  if [[ ! -f "$DATA_ORGANIZATION_PROTOCOL" ]]; then
    DATA_ORGANIZATION_PROTOCOL="$DATA_ORGANIZATION_RESULTS/compiled-pairs-r2extra/$DATA_ORGANIZATION_PAIR-protocol.json"
  fi
fi
[[ -f "$DATA_ORGANIZATION_PROTOCOL" ]] || { echo 'exact frozen pair protocol was not found' >&2; exit 2; }
source "${AIE_TOY_ROOT:-/home/shiran/project/aie-toy}/scripts/env.sh"
DATA_ORGANIZATION_COMMAND=(python "$DATA_ORGANIZATION_ARTIFACT/taskflow/scripts/taskflow_data_probe_v17.py" --protocol "$DATA_ORGANIZATION_PROTOCOL" --output "$DATA_ORGANIZATION_OUTPUT")
if [[ "$DATA_ORGANIZATION_MODE" == cpu ]]; then
  "${DATA_ORGANIZATION_COMMAND[@]}" --validate-only
else
  timeout 120s "${DATA_ORGANIZATION_COMMAND[@]}"
fi
