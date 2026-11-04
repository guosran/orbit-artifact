#!/usr/bin/env bash
set -euo pipefail
if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  echo 'usage: run_taskflow_ffn_optimization_v9.sh AUDITED_BASELINE_ROOT NEW_OUTPUT [--stages] [--m128] [--trace]'
  exit 0
fi
[[ $# -ge 2 ]] || { echo 'usage: run_taskflow_ffn_optimization_v9.sh AUDITED_BASELINE_ROOT NEW_OUTPUT [--stages] [--m128] [--trace]' >&2; exit 2; }
source "$(dirname "${BASH_SOURCE[0]}")/taskflow_paths.sh"
source "${AIE_TOY_ROOT:-$ARTIFACT_REPO/../aie-toy}/scripts/env.sh"
base=$(realpath "$1")
out=$(realpath -m "$2")
shift 2
OPENBLAS_NUM_THREADS=1 "$ORBIT_TEST_PYTHON" "$ARTIFACT_ROOT/scripts/taskflow_ffn_optimize_v9.py" \
  --baseline-root "$base" --output "$out" "$@"
