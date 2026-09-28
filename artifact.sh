#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")" && pwd)"
python_bin="${ORBIT_PYTHON:-python3}"
case "${1:-}" in
  doctor) exec "$python_bin" "$root/scripts/check_environment.py" ;;
  setup)
    "$root/scripts/fetch_sources.sh"
    if [ ! -f "${ORBIT_LLVM_BUILD:-$root/.work/llvm-project/build}/lib/cmake/mlir/MLIRConfig.cmake" ]; then
      "$root/scripts/setup_llvm.sh"
    fi
    exec "$root/scripts/configure.sh" ;;
  build) exec "$root/scripts/build.sh" ;;
  smoke) exec "$python_bin" "$root/scripts/run_semantic_closure.py" --mode smoke ;;
  reproduce)
    if [ "${2:-}" != semantic ]; then echo 'usage: artifact.sh reproduce semantic' >&2; exit 2; fi
    exec "$python_bin" "$root/scripts/run_semantic_closure.py" --mode semantic ;;
  validate) exec "$python_bin" "$root/scripts/validate_results.py" "${2:-}" ;;
  tables) exec "$python_bin" "$root/scripts/generate_tables.py" "${2:-}" ;;
  clean-results)
    exec "$python_bin" "$root/scripts/clean_results.py" ;;
  *) echo 'usage: artifact.sh {doctor|setup|build|smoke|reproduce semantic|validate [run-dir]|tables [run-dir]|clean-results}' >&2; exit 2 ;;
esac

