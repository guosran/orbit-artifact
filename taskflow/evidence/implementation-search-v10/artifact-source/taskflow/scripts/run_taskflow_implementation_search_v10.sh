#!/usr/bin/env bash
# Original C++ search/planners own every candidate and production cost. This is
# experiment orchestration; only the coordinator invokes hardware phases.
set -euo pipefail
if [[ ${1:-} == --help ]]; then
  echo 'usage: run_taskflow_implementation_search_v10.sh cpu|all NEW_OUTPUT_DIRECTORY'
  echo 'Existing dependencies: ORBIT_SRC LLVM_BUILD AIE_TOY_ROOT ORBIT_TEST_PYTHON'
  echo 'ORBIT_BUILD_ROOT defaults to NEW_OUTPUT_DIRECTORY/build; no historical NPU labels/fitted models or frozen tools are inputs.'
  echo 'Existing delivered CGRA models are read only for identity/contract checks; never retrained.'
  exit 0
fi
[[ $# == 2 && ( "$1" == cpu || "$1" == all ) ]] || { echo 'usage: run_taskflow_implementation_search_v10.sh cpu|all NEW_OUTPUT_DIRECTORY' >&2; exit 2; }
mode=$1
out=$(realpath -m "$2")
[[ ! -e "$out" && "$out" != *[[:space:]]* ]] || { echo 'Use a new directory without whitespace.' >&2; exit 2; }
export ORBIT_BUILD_ROOT=${ORBIT_BUILD_ROOT:-$out/build}
source "$(dirname "${BASH_SOURCE[0]}")/taskflow_paths.sh"
export AIE_TOY_ROOT=${AIE_TOY_ROOT:-$ARTIFACT_REPO/../aie-toy}
source "$AIE_TOY_ROOT/scripts/env.sh"
python_bin=$ORBIT_TEST_PYTHON
mkdir -p "$out"
exec > >(tee "$out/reproduce.log") 2>&1
cd "$ARTIFACT_ROOT"
cp scripts/run_taskflow_implementation_search_v10.sh "$out/reproduction-source.sh"
"$python_bin" python/taskflow_paths.py > "$out/paths.json"
# Includes original CGRA contracts, Core/Amoeba/AIR and v9 compiler/profiler
# regressions. The legacy CGRA model is checked, never retrained.
bash scripts/run_taskflow_ffn_profiling_v9.sh cpu "$out/cpu-regression"
"$python_bin" test/TaskflowAIR/implementation_protocol_v10.py --output "$out/protocol-cpu"
"$python_bin" test/TaskflowAIR/implementation_fit_v10.py --output "$out/fit-cpu"
"$python_bin" test/TaskflowAIR/implementation_validation_v10.py --output "$out/validation-cpu"
"$python_bin" test/TaskflowAIR/implementation_flow_v10.py --output "$out/flow-cpu"
"$python_bin" test/TaskflowAIR/channel_port_scope_v10.py --output "$out/channel-port-scope-cpu"
"$python_bin" test/TaskflowAIR/implementation_closure_v10.py --output "$out/closure-cpu"
if [[ "$mode" == cpu ]]; then
  echo '{"status":"passed","cpu_regression":true,"model_fit":false,"hardware_execution":false}' > "$out/result.json"
  exit 0
fi
OPENBLAS_NUM_THREADS=1 "$python_bin" test/TaskflowAIR/prepare_implementation_search_v10.py \
  --matrix test/TaskflowAIR/implementation_matrix_v10.json --output "$out/prepared"
"$python_bin" scripts/taskflow_implementation_search_v10.py propose --prepared "$out/prepared" \
  --tool "$AIR_BUILD/tools/taskflow-opt/taskflow-opt" --output "$out/proposals"
# Must pass before any labels are collected; condition/rank failure stops here.
"$python_bin" scripts/fit_implementation_cost_v10.py design --proposals "$out/proposals" --output "$out/design"
"$python_bin" scripts/taskflow_implementation_search_v10.py compile --proposals "$out/proposals" --output "$out/compiled"
"$python_bin" scripts/taskflow_implementation_experiment_v10.py profile \
  --design "$out/design" --compiled "$out/compiled" --split train --output "$out/train"
"$python_bin" scripts/fit_implementation_cost_v10.py fit --design "$out/design" --compiled "$out/compiled" \
  --profile "$out/train/profile-train" --audit "$out/train/independent-audit/profile-train.json" \
  --holdout-profile "$out/holdout/profile-holdout" --output "$out/frozen-model"
"$python_bin" scripts/taskflow_implementation_experiment_v10.py predict --frozen "$out/frozen-model" --output "$out/predictions"
"$python_bin" scripts/taskflow_implementation_experiment_v10.py predictive-search \
  --predictions "$out/predictions/prediction-freeze.json" --output "$out/native-predictive-search"
"$python_bin" scripts/taskflow_implementation_closure_v10.py controls \
  --predictions "$out/predictions/prediction-freeze.json" --output "$out/search-controls"
"$python_bin" scripts/taskflow_implementation_experiment_v10.py select \
  --search "$out/native-predictive-search" --frozen "$out/frozen-model" \
  --control "$out/search-controls/tiling-only" --control "$out/search-controls/implementation-residency" \
  --exploration-budget 1 --output "$out/selected"
"$python_bin" scripts/taskflow_implementation_experiment_v10.py compile-selected \
  --selection "$out/selected" --output "$out/selected-compiled" --jobs 2
"$python_bin" scripts/taskflow_implementation_experiment_v10.py prepare-selected-profile \
  --selection "$out/selected" --compiled "$out/selected-compiled" --output "$out/selected-profile"
"$python_bin" scripts/taskflow_implementation_closure_v10.py run-profile \
  --command "$out/selected-profile/profile-command.json"
"$python_bin" test/TaskflowAIR/audit_selected_implementation_v10.py \
  --selection "$out/selected" --compiled "$out/selected-compiled" \
  --profile "$out/selected-profile/profile-selected" --output "$out/selected-validation"
"$python_bin" scripts/taskflow_implementation_closure_v10.py ffn \
  --selection "$out/selected" --output "$out/representative-ffn"
"$python_bin" scripts/taskflow_implementation_experiment_v10.py profile \
  --design "$out/design" --compiled "$out/compiled" --split holdout --frozen "$out/frozen-model" \
  --predictions "$out/predictions/prediction-freeze.json" --output "$out/holdout"
"$python_bin" test/TaskflowAIR/audit_implementation_search_v10.py --frozen "$out/frozen-model" \
  --predictions "$out/predictions/prediction-freeze.json" --profile "$out/holdout/profile-holdout" --output "$out/validation"
"$python_bin" - "$out" <<'PY'
import json,sys
from pathlib import Path
from taskflow_paths import ARTIFACT_ROOT
sys.path.insert(0,str(ARTIFACT_ROOT/'test/TaskflowAIR'))
from prepare_implementation_search_v10 import cgra_identity
out=Path(sys.argv[1]);registration=json.loads((out/'prepared/preregistration.json').read_text())
if cgra_identity(Path(registration['cgra']['models']))!=registration['cgra']:
 raise SystemExit('CGRA models changed; do not claim unchanged baseline')
(out/'result.json').write_text(json.dumps(dict(status='passed',cpu_regression=True,hardware_execution=True,
 model_fit=True,cgra_models_unchanged=True,old_v9_labels_reused=False,validation='validation/validation.json',
 selected_validation='selected-validation/validation.json',representative_ffn='representative-ffn/independent-audit/profile-ffn.json',
 scope='complete prepared-command host wall; independent finite FP32 raw checks; descriptive prediction errors/ranking/regret, not significance'),indent=2)+'\n')
PY
