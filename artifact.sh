#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")" && pwd)"
python_bin="${ORBIT_PYTHON:-python3}"
case "${1:-}" in
  doctor) exec "$python_bin" "$root/scripts/check_environment.py" ;;
  setup)
    "$root/scripts/fetch_sources.sh"
    if [ ! -f "${ORBIT_LLVM_BUILD:-$root/.work/llvm-build}/lib/cmake/mlir/MLIRConfig.cmake" ]; then
      "$root/scripts/setup_llvm.sh"
    fi
    exec "$root/scripts/configure.sh" ;;
  build) exec "$root/scripts/build.sh" ;;
  smoke)
    case "${2:-semantic}" in
      semantic) exec "$python_bin" "$root/scripts/run_semantic_closure.py" --mode smoke ;;
      backend|scheduler) exec "$python_bin" "$root/scripts/system_entry.py" smoke "$2" ;;
      *) echo 'usage: artifact.sh smoke {semantic|backend|scheduler}' >&2; exit 2 ;;
    esac ;;
  reproduce)
    case "${2:-}" in
      semantic) exec "$python_bin" "$root/scripts/run_semantic_closure.py" --mode semantic ;;
      resource|spatial|temporal|cost|replay|core|paper|full)
        exec "$python_bin" "$root/scripts/system_entry.py" reproduce "$2" ;;
      *) echo 'usage: artifact.sh reproduce {semantic|resource|spatial|temporal|cost|replay|core|paper|full}' >&2; exit 2 ;;
    esac ;;
  status) exec "$python_bin" "$root/scripts/system_status.py" ;;
  resume)
    if [ -z "${2:-}" ]; then echo 'usage: artifact.sh resume <run-directory>' >&2; exit 2; fi
    exec "$python_bin" "$root/scripts/resume.py" "$2" ;;
  validate)
    if [ "$#" -ge 2 ]; then exec "$python_bin" "$root/scripts/validate_results.py" "$2"; fi
    exec "$python_bin" "$root/scripts/validate_results.py" ;;
  tables)
    if [ "$#" -ge 2 ]; then exec "$python_bin" "$root/scripts/generate_tables.py" "$2"; fi
    exec "$python_bin" "$root/scripts/generate_tables.py" ;;
  clean-results)
    exec "$python_bin" "$root/scripts/clean_results.py" ;;
  *) echo 'usage: artifact.sh {doctor|setup|build|smoke {semantic|backend|scheduler}|reproduce {semantic|resource|spatial|temporal|cost|replay|core|paper|full}|status|validate [run-dir]|tables [run-dir]|resume <run-dir>|clean-results}' >&2; exit 2 ;;
esac
