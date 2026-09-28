#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="${ORBIT_SOURCE_DIR:-$root/.work/amoeba}"
build_dir="${ORBIT_BUILD_DIR:-$root/.work/build}"
llvm_build="${ORBIT_LLVM_BUILD:-$root/.work/llvm-build}"
python_bin="${ORBIT_PYTHON:-python3}"
PYTHONPATH="$root/scripts" "$python_bin" -c 'from common import require_source_clean; require_source_clean()'
test -f "$llvm_build/lib/cmake/llvm/LLVMConfig.cmake"
test -f "$llvm_build/lib/cmake/mlir/MLIRConfig.cmake"
cmake -G Ninja -S "$source_dir" -B "$build_dir" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_DIR="$llvm_build/lib/cmake/llvm" \
  -DMLIR_DIR="$llvm_build/lib/cmake/mlir" \
  -DCMAKE_C_COMPILER="${CC:-clang}" -DCMAKE_CXX_COMPILER="${CXX:-clang++}"
