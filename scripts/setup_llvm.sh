#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
llvm_src="${ORBIT_LLVM_SOURCE:-$root/.work/llvm-project}"
llvm_build="${ORBIT_LLVM_BUILD:-$root/.work/llvm-build}"
commit=6146a88f60492b520a36f8f8f3231e15f3cc6082
if [ ! -e "$llvm_src" ]; then git clone https://github.com/llvm/llvm-project.git "$llvm_src"; fi
if [ -n "$(git -C "$llvm_src" status --porcelain --ignore-submodules=all)" ]; then
  echo 'LLVM source is dirty; refusing to alter it' >&2; exit 1
fi
if [ "$(git -C "$llvm_src" rev-parse HEAD)" != "$commit" ]; then
  git -C "$llvm_src" fetch origin "$commit"
  git -C "$llvm_src" checkout --detach "$commit"
fi
cmake -G Ninja -S "$llvm_src/llvm" -B "$llvm_build" \
  -DLLVM_ENABLE_PROJECTS='mlir;clang' -DLLVM_TARGETS_TO_BUILD=Native \
  -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_RTTI=ON -DCMAKE_CXX_FLAGS='-std=c++17 -frtti' \
  -DCMAKE_C_COMPILER="${CC:-clang}" -DCMAKE_CXX_COMPILER="${CXX:-clang++}"
cmake --build "$llvm_build" --target mlir-opt mlir-runner llvm-lit --parallel "${ORBIT_BUILD_JOBS:-2}"
