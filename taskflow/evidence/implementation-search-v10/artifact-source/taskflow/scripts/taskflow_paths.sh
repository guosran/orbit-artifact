#!/usr/bin/env bash
# Source-only root configuration. No build, runtime import, or device action.
ARTIFACT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ARTIFACT_REPO=$(cd "$ARTIFACT_ROOT/.." && pwd)
ORBIT_SRC=$(realpath -m "${ORBIT_SRC:-$ARTIFACT_REPO/../orbit}")
ORBIT_BUILD_ROOT=$(realpath -m "${ORBIT_BUILD_ROOT:-$ARTIFACT_REPO/builds/taskflow}")
CORE_BUILD=$ORBIT_BUILD_ROOT/core
AIR_BUILD=$ORBIT_BUILD_ROOT/air
AMOEBA_BUILD=$ORBIT_BUILD_ROOT/amoeba
RESULTS_ROOT=$(realpath -m "${ORBIT_RESULTS_ROOT:-$ARTIFACT_REPO/results/taskflow}")
ORBIT_TEST_PYTHON=${ORBIT_TEST_PYTHON:-${AIE_TOY_ROOT:-/home/shiran/project/aie-toy}/.venv/bin/python}
export ARTIFACT_ROOT ARTIFACT_REPO ORBIT_SRC ORBIT_BUILD_ROOT CORE_BUILD AIR_BUILD AMOEBA_BUILD RESULTS_ROOT ORBIT_TEST_PYTHON
export PYTHONPATH="$ARTIFACT_ROOT/python:$ARTIFACT_ROOT/scripts${PYTHONPATH:+:$PYTHONPATH}"
taskflow_test_path() {
  local relative=$1
  [[ "$relative" != /* && "/$relative/" != */../* ]] || { echo "test path must be relative without parent traversal" >&2; return 2; }
  [[ "$relative" == test/* ]] || relative=test/$relative
  case "$relative" in
    test/TaskflowAIR/audit_channel_ports_v6.py|\
    test/TaskflowAIR/audit_compare_v7.py|\
    test/TaskflowAIR/audit_comparison.py|\
    test/TaskflowAIR/audit_hardware.py|\
    test/TaskflowAIR/audit_metrics_v6.py|\
    test/TaskflowAIR/audit_program_v7.py|\
    test/TaskflowAIR/audit_runtime_transfers_v7.py|\
    test/TaskflowAIR/audit_storage_v6.py|\
    test/TaskflowAIR/classify_exp_edges_v6.py|\
    test/TaskflowAIR/diagnose_stage_v6.py|\
    test/TaskflowAIR/make_fixtures.py|\
    test/TaskflowAIR/prepare_exp_probe_v6.py|\
    test/TaskflowAIR/prepare_ffn_stages_v7.py|\
    test/TaskflowAIR/prepare_inputs.py|\
    test/TaskflowAIR/prepare_program_mapping_v7.py|\
    test/TaskflowAIR/prepare_v6.py|\
    test/TaskflowAIR/search_cases_v7.py|\
    test/TaskflowAIR/summarize_program_timing_v7.py|\
    test/TaskflowAIR/summarize_v6.py|\
    test/TaskflowAIR/summarize_v7.py|\
    test/TaskflowAIR/test_program_manifest_v7.py|\
    test/TaskflowMapping/calibrated_evidence_v4.py|\
    test/TaskflowMapping/calibrated_original_search_v4.py|\
    test/TaskflowMapping/compute_contract_v8.py|\
    test/TaskflowMapping/fixtures/compute-contract-baseline-v8.jsonl|\
    test/TaskflowMapping/fixtures/compute-contract-baseline-v8.provenance.json|\
    test/TaskflowMapping/hardware_evidence.py|\
    test/TaskflowMapping/structural_hardware_v4.py|\
    test/TaskflowMapping/trace_v4.py|\
    test/TaskflowValidation/evaluation_cache.py) printf '%s/%s\n' "$ARTIFACT_ROOT" "$relative";;
    *) printf '%s/%s\n' "$ORBIT_SRC" "$relative";;
  esac
}
