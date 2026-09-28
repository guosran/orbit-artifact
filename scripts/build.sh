#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${ORBIT_BUILD_DIR:-$root/.work/build}"
cmake --build "$build_dir" --target mlir-amoeba-opt --parallel "${ORBIT_BUILD_JOBS:-2}"
test -x "$build_dir/tools/mlir-amoeba-opt/mlir-amoeba-opt"

