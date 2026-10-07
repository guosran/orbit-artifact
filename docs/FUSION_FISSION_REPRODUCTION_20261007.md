# Fresh fusion/fission reproduction

This runbook describes a clean, newly bound six-workload cohort for the current source-owned joint neighborhood search. The five programs other than original Ray use runtime II 20. Original Ray keeps its original 27-task graph and uses the separate diagnostic runtime II 23 architecture; the four-member model remains trained at II 20. Each of five stages starts independently from its prepared canonical program, for 30 stage searches total. The search is bounded and reports best-found candidates, not a global optimum.

As of 2026-10-07, the captured R11b launch record says the six-by-five run is running. No full-cohort completion or performance result is claimed here. That host launch used one four-CPU lane because another sequential experiment occupied the other eight CPUs; this reduces throughput only. The bound search budget is unchanged. New clean-clone work must use a fresh cohort ID, output root, source contract, optimizer pin, protocol, and caches; the captured R11b files are semantic examples, not reusable bindings.

The implementation at source commit `4547a3853452438af0a74f20342b4bc182cc9107` is the final source revision for this workflow. The deployed R11b executable was copied from the j1 build at `2dd2bb327269eaff23e5dc8cdff11d968b0dda15`; the later source change only adjusted a checker, while all 140 implementation files stayed byte-identical. For a clean reproduction, build the selected current source checkout, issue a new read-only pin and regenerate every contract. Do not relabel a new executable as the old pin.

## Inputs and machine-local variables

Start in a clean clone of `orbit-artifact`. The scripts below use absolute variables so generated paths are unambiguous. Keep run outputs and the frozen runtime outside the measured result tree.

```sh
set -euo pipefail
export ARTIFACT_ROOT="${ARTIFACT_ROOT:?path to the clean orbit-artifact clone}"
export LLVM_BUILD="${LLVM_BUILD:?path to the LLVM/MLIR build}"
export ORBIT_SRC="${ORBIT_SRC:?path for the clean ORBIT source checkout}"
export ORBIT_BUILD="${ORBIT_BUILD:?path for the ORBIT build}"
export AMOEBA_TEST_ROOT="${AMOEBA_TEST_ROOT:-$ARTIFACT_ROOT/reference/input0-neighborhood/reference-source}"
export ORBIT_SOURCE_COMMIT=4547a3853452438af0a74f20342b4bc182cc9107
export ORBIT_SOURCE_BASE=2dd2bb327269eaff23e5dc8cdff11d968b0dda15
export MODEL_NAMESPACE=orbit-per-cgra-2x2-direct-4member-v1
export SOURCE_VARIANT=fusion-fission-funnel-cleanclone-20261007
export COHORT_ID="${COHORT_ID:?choose a new unique cohort ID}"
export RUN_HOME="${RUN_HOME:?new scratch directory for this run}"
export PREP_ROOT="$ARTIFACT_ROOT/.work/$COHORT_ID/source-domain-prep"
export PIN_DIR="$ARTIFACT_ROOT/.work/control-variables-and-tiling-20261007"
export OPTIMIZER_PIN_RELATIVE=".work/control-variables-and-tiling-20261007/mlir-amoeba-opt-$COHORT_ID"
export SOURCE_CONTRACT_RELATIVE=".work/control-variables-and-tiling-20261007/source-model-contract-$COHORT_ID.json"
export OPTIMIZER_PIN="$ARTIFACT_ROOT/$OPTIMIZER_PIN_RELATIVE"
export SOURCE_CONTRACT="$ARTIFACT_ROOT/$SOURCE_CONTRACT_RELATIVE"
export RESULTS_ROOT="$RUN_HOME/results/$COHORT_ID"
export RUNTIME_ROOT="$RUN_HOME/runtime-frozen"
export BASE_RUNTIME="$RUN_HOME/runtime-base"
export CENSUS_ROOT="$RUN_HOME/source-cut-census"
export DIAGNOSTICS_ROOT="$RUN_HOME/diagnostics"

case "$COHORT_ID" in
  input0-neighborhood-2x2-*) ;;
  *) echo "COHORT_ID must start with input0-neighborhood-2x2-" >&2; exit 2 ;;
esac
test ! -e "$PREP_ROOT/input0-chain.json"
test ! -e "$OPTIMIZER_PIN"
test ! -e "$SOURCE_CONTRACT"
test ! -e "$RESULTS_ROOT"
test ! -e "$RUNTIME_ROOT"
mkdir -p "$RUN_HOME" "$PREP_ROOT" "$PIN_DIR" "$DIAGNOSTICS_ROOT"
```

The supported direct 2×2 model is [the portable four-member ensemble](../reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json), namespace `orbit-per-cgra-2x2-direct-4member-v1`. The current [source file list](../reference/input0-neighborhood/source-file-list.json) contains 140 implementation files. The fresh source contract embeds those exact source bytes, 26 exact replay payloads, and the ensemble payload that declares all four members. It uses exact payload comparison and does not depend on digest files.

## Build and pin the optimizer

Use the LLVM/MLIR build expected by the repository. The current reproduction guide pins LLVM/MLIR revision `6146a88f60492b520a36f8f8f3231e15f3cc6082`; its complete LLVM prerequisites and build command are in [the input-0 reproducibility guide](INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md#historical-v38-source-and-build-inputs). If that build is already available, point `LLVM_BUILD` at it. In either case, pass that root explicitly to CMake and export it for every native replay and numeric command.

```sh
export ORBIT_LLVM_BUILD="$LLVM_BUILD"
export PATH="$LLVM_BUILD/bin:$PATH"

git clone https://github.com/guosran/orbit.git "$ORBIT_SRC"
git -C "$ORBIT_SRC" checkout --detach "$ORBIT_SOURCE_COMMIT"
test "$(git -C "$ORBIT_SRC" rev-parse HEAD)" = "$ORBIT_SOURCE_COMMIT"
test -z "$(git -C "$ORBIT_SRC" status --porcelain --untracked-files=all)"

cmake -S "$ORBIT_SRC" -B "$ORBIT_BUILD" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DMLIR_DIR="$LLVM_BUILD/lib/cmake/mlir" \
  -DLLVM_DIR="$LLVM_BUILD/lib/cmake/llvm"
ninja -C "$ORBIT_BUILD" tools/mlir-amoeba-opt/mlir-amoeba-opt -j1

install -D -m 0555 \
  "$ORBIT_BUILD/tools/mlir-amoeba-opt/mlir-amoeba-opt" \
  "$OPTIMIZER_PIN"
test -x "$OPTIMIZER_PIN"
```

The source checkout is detached at the recorded source commit. The executable pin is a separate copied file with mode `0555`; it is not a symlink back into the build tree. Keep the LLVM root explicit during input preparation, runtime freezing, and all later native/numeric validation.

## Prepare source-owned programs, catalogs, and the byte contract

The preparer regenerates canonical MLIR, source iteration-domain proofs, model costs, caches, and the prepared pre-Neura source needed for fission. It runs the five ordinary programs at II 20 and original Ray at II 23 by splitting the source-preparation calls internally. Do not set `--ray-fission-split-at`: the cohort uses the original 27-task Ray graph.

```sh
python3 "$ARTIFACT_ROOT/scripts/prepare_input0_neighborhood_reproduction.py" \
  --artifact-root "$ARTIFACT_ROOT" \
  --optimizer "$OPTIMIZER_PIN" \
  --architecture "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml" \
  --model-root "$ARTIFACT_ROOT/reference/input0-neighborhood/models/per-cgra-2x2" \
  --model-namespace "$MODEL_NAMESPACE" \
  --source-repository https://github.com/guosran/orbit.git \
  --source-commit "$ORBIT_SOURCE_COMMIT" \
  --output-root "$PREP_ROOT" \
  --amoeba-test-root "$AMOEBA_TEST_ROOT" \
  --workloads llama lu gcn harris radar raytracing \
  --diagnostic-ii-ceiling 20 \
  --emit-fission-source \
  --original-ray-diagnostic-ii23 \
  --jobs 1
```

The command intentionally omits `--skip-reference-build`: on a clean clone it builds all six independent numeric reference libraries under `.work/selected-native-numeric-gate`. Add `--skip-reference-build` only when all six libraries at that exact location have already been validated for this artifact checkout. The default LLaMA numeric runner is included in the prepared artifact; the preparer also installs the runner copy required by the replay gate.

Create the exact source/model/replay contract from this clean source tree and the new pin. The command’s output should report 140 source files, one direct-ensemble model payload, and 26 replay payloads.

```sh
python3 "$ARTIFACT_ROOT/scripts/write_neighborhood_source_contract.py" \
  --artifact-root "$ARTIFACT_ROOT" \
  --source-root "$ORBIT_SRC" \
  --build-root "$ORBIT_BUILD" \
  --model-root "$ARTIFACT_ROOT/reference/input0-neighborhood/models/per-cgra-2x2" \
  --model-namespace "$MODEL_NAMESPACE" \
  --optimizer "$OPTIMIZER_PIN" \
  --source-file-list "$ARTIFACT_ROOT/reference/input0-neighborhood/source-file-list.json" \
  --source-commit "$ORBIT_SOURCE_COMMIT" \
  --sram-config "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json" \
  --inter-task-network "$ARTIFACT_ROOT/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml" \
  --output "$SOURCE_CONTRACT"
```

The contract captures the selected 140 source files, current replay scripts and configs, exact model bytes, and exact optimizer pin. Keep the source checkout clean: the writer records both the cost/source namespace and the published checkout revision, and later launch validation requires the contract’s published revision to equal `ORBIT_SRC` HEAD.

## Bind the five-stage protocol and freeze the runtime

The committed [fusion/fission protocol template](../reference/input0-neighborhood/protocol-2x2-fusion-fission-funnel-template.json) is a semantic template, not a run binding. Start from a copy. Set both cohort IDs to fresh values; preserve the five stages, all search limits, hardware, network, model, and proof policies. The writer fills current source, pin, contract, model, and canonical/cache bindings and emits the Ray II23 companion protocol plus runtime chain config.

```sh
export TEMPLATE_WORK="$ARTIFACT_ROOT/.work/$COHORT_ID"
export PROTOCOL_TEMPLATE="$TEMPLATE_WORK/fission-template.json"
export PROTOCOL_OUTPUT="$ARTIFACT_ROOT/reference/input0-neighborhood/protocol-$COHORT_ID.json"
export CHAIN_COMMAND_MAIN="$TEMPLATE_WORK/chain-command.json"
mkdir -p "$TEMPLATE_WORK" "$(dirname "$PROTOCOL_OUTPUT")"

python3 - \
  "$ARTIFACT_ROOT/reference/input0-neighborhood/protocol-2x2-fusion-fission-funnel-template.json" \
  "$PROTOCOL_TEMPLATE" "$COHORT_ID" <<'PY'
import json, sys
source, destination, cohort = sys.argv[1:]
document = json.load(open(source, encoding="utf-8"))
document["cohort_id"] = cohort
document["fixed1x1_cohort_id"] = cohort + "-fixed1x1"
document["source_variant"] = "fresh-source-bound-fusion-fission"
document["active"] = False
with open(destination, "x", encoding="utf-8") as stream:
    json.dump(document, stream, indent=2)
    stream.write("\n")
PY

python3 "$ARTIFACT_ROOT/scripts/write_neighborhood_publication_command.py" \
  --artifact-root "$ARTIFACT_ROOT" \
  --source-root "$ORBIT_SRC" \
  --build-root "$ORBIT_BUILD" \
  --source-base "$ORBIT_SOURCE_BASE" \
  --source-variant "$SOURCE_VARIANT" \
  --config "$PREP_ROOT/input0-chain.json" \
  --protocol-template "$PROTOCOL_TEMPLATE" \
  --protocol-output "$PROTOCOL_OUTPUT" \
  --source-contract-file "$SOURCE_CONTRACT" \
  --optimizer "$OPTIMIZER_PIN" \
  --architecture "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml" \
  --sram-config "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json" \
  --inter-task-network "$ARTIFACT_ROOT/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml" \
  --model-root "$ARTIFACT_ROOT/reference/input0-neighborhood/models/per-cgra-2x2" \
  --mapping-cache "$TEMPLATE_WORK/mapping-cache" \
  --output-root "$RESULTS_ROOT" \
  --stage-scheme full-joint-fission \
  --output "$CHAIN_COMMAND_MAIN"
```

The active profile fixes the fabric at 4×4 CGRAs, 2×2 PEs per CGRA, 64 PEs, context memory 6, control memory 20 for the five II20 programs, and at most four CGRAs per task. The common explicit network has 48 directed mesh links, each with one-cycle latency and 32-bit/cycle bandwidth. The per-CGRA SRAM byte-capacity config remains formally pending; the protocol must keep `formal_go=false` and must not convert the pending SRAM gate into a pass.

The stages are S1 `shape-temporal`, S2 `shape-temporal-replica`, S3 `shape-temporal-replica-tiling`, S4 `full-joint`, and S5 `full-joint-fission`. Each stage has four rounds, at most 4,096 unique complete-program scores, beam width 16, four diversity slots, and a global predicted top five plus controls, with no hidden winner. Keep the dimensions, score order, source-fission cap of 64, and independent stage initialization unchanged. The temporal score uses the production critical-path spatial-temporal scheduler with explicit communication. It is not exhaustive.

Build a thin base runtime containing the six prepared numeric libraries and the exact LLaMA runner copy. Then call only the reusable `prepare_frozen_runtime()` helper from `scripts/run_input0_memory_fusion_fission_queue.py`; do not use that script’s old R9 CLI or defaults for a new cohort. The helper overlays the current tracked `scripts`, `config`, and `reference` trees, and copies the accepted pin and contract into the frozen tree. It verifies byte equality for the overlay and exact contract inputs.

```sh
mkdir -p "$BASE_RUNTIME/.work/selected-native-numeric-gate" \
  "$BASE_RUNTIME/.work/cpp-gate-continuation-agent/source/replica-validation" \
  "$BASE_RUNTIME/scripts" "$BASE_RUNTIME/config" "$BASE_RUNTIME/reference"
for library in \
  libgcn_reference.so libharris_reference.so libllama_nonuniform_reference.so \
  liblu_reference.so libradar_reference.so libraytracing_reference.so; do
  install -m 0644 \
    "$ARTIFACT_ROOT/.work/selected-native-numeric-gate/$library" \
    "$BASE_RUNTIME/.work/selected-native-numeric-gate/$library"
done
install -m 0644 \
  "$ARTIFACT_ROOT/.work/cpp-gate-continuation-agent/source/replica-validation/task0-task1-k2.runner.mlir" \
  "$BASE_RUNTIME/.work/cpp-gate-continuation-agent/source/replica-validation/task0-task1-k2.runner.mlir"

PYTHONPATH="$ARTIFACT_ROOT/scripts${PYTHONPATH:+:$PYTHONPATH}" \
python3 - "$ARTIFACT_ROOT" "$BASE_RUNTIME" "$RUNTIME_ROOT" \
  "$OPTIMIZER_PIN" "$SOURCE_CONTRACT" <<'PY'
from pathlib import Path
import sys
from run_input0_memory_fusion_fission_queue import prepare_frozen_runtime
artifact, base, runtime, optimizer, contract = map(Path, sys.argv[1:])
prepare_frozen_runtime(artifact_root=artifact, base_runtime=base,
                       runtime_root=runtime, optimizer=optimizer,
                       source_contract=contract)
PY
```

Freeze after the fresh protocol is written so the new protocol is included in the `reference` overlay. Preserve the following path policy when using the generated chain command from the frozen runtime:

- Keep the generated `input0-chain-runtime-ii23.json` and its cost catalogs in the original artifact clone and pass that config by absolute path. Its parent-cost metadata records that tree’s source preparation paths.
- Pass the shared II20 architecture YAML by its absolute path in the original artifact clone for the same model/cost-byte binding.
- Resolve the model input from the frozen runtime’s `reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json`; this explicit `--model-cache` path takes priority over the config’s model-cache default and must refer to the same four-member bytes captured by the contract.
- Keep the bound protocol, source contract, 0555 optimizer pin, network, SRAM config, mapper cache, replay script, and renderer paths relative to the frozen runtime. Create the new mapper-cache directory there before launching.

The publication-command writer initially emits artifact-relative paths. After freezing, put its command JSON in the runtime and replace the `--config` and `--architecture` values with the absolute paths above; all other artifact-relative paths resolve inside the frozen runtime because the overlay preserves the same relative layout. Do not edit the protocol’s hardware or cost policy to compensate for paths.

Run this relocation after `prepare_frozen_runtime()` succeeds. It keeps the writer-generated protocol and search options intact while making the runtime paths explicit. The only source-tree paths left absolute in the command are the prepared config and common II20 architecture.

```sh
export CHAIN_COMMAND_RUNTIME="$RUNTIME_ROOT/.work/$COHORT_ID/chain-command.json"
mkdir -p "$(dirname "$CHAIN_COMMAND_RUNTIME")" "$RUNTIME_ROOT/.work/$COHORT_ID/mapping-cache"
cp "$CHAIN_COMMAND_MAIN" "$CHAIN_COMMAND_RUNTIME"

python3 - "$CHAIN_COMMAND_RUNTIME" "$PREP_ROOT/input0-chain-runtime-ii23.json" \
  "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml" \
  "$COHORT_ID" "$OPTIMIZER_PIN_RELATIVE" "$SOURCE_CONTRACT_RELATIVE" <<'PY'
import json, sys
from pathlib import Path
command_path, config, architecture, cohort, optimizer, contract = sys.argv[1:]
path = Path(command_path)
command = json.loads(path.read_text(encoding="utf-8"))
if not isinstance(command, list):
    raise SystemExit("chain command must be an argv array")
def set_value(flag, value):
    index = command.index(flag)
    command[index + 1] = value

set_value("--config", str(Path(config).resolve()))
set_value("--architecture", str(Path(architecture).resolve()))
set_value("--optimizer", optimizer)
set_value("--source-contract-file", contract)
set_value("--protocol", f"reference/input0-neighborhood/protocol-{cohort}.json")
set_value("--model-cache", "reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json")
set_value("--sram-config", "config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json")
set_value("--inter-task-network", "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml")
set_value("--mapping-cache", f".work/{cohort}/mapping-cache")
path.write_text(json.dumps(command, indent=2) + "\n", encoding="utf-8")
PY
```

## Launch and resume the 30 stages

Run the coordinator from the frozen runtime. Its worker processes use disjoint workload directories and a maximum of three four-CPU lanes; each lane can run four mapper jobs. There is no mapper wall-clock timeout. C++ search, candidate proofs, ranking, and production scheduling remain in the pinned optimizer, while Python coordinates processes and validates evidence.

```sh
cd "$RUNTIME_ROOT"
mkdir -p ".work/$COHORT_ID/mapping-cache"
python3 scripts/run_neighborhood_parallel_batch.py \
  --chain-command-file ".work/$COHORT_ID/chain-command.json" \
  --workers 3 --cpus-per-worker 4 --jobs-per-worker 4
```

If the host has fewer than 12 available CPUs, lower only `--workers` while retaining four CPUs and four mapper jobs per lane. This limits throughput; do not lower the per-stage search budgets. Resume only with the same fresh result tree, frozen runtime, protocol, contract, pin, and chain command. Do not rerun preparation or silently substitute an older checkpoint, cost cache, model cache, or optimizer.

The stage chain keeps predicted/model II distinct from measured mapper II. Native admission requires real mapper replay, mapper equality, complete-program replay, and independent trace validation. Numeric checks run separately on the global top five and controls; numeric failure, missing evidence, and an SRAM-pending result remain distinct states. A valid source-iteration-domain proof is required for every scored candidate. The run is not formal-GO while SRAM capacity is pending.

## Census, funnel audit, and rendering

Create source-cut census files from the exact freshly prepared `pre-neura.mlir` files before the S5 audit. For each workload, resolve the function name from its canonical module, then run the non-mapper C++ source census with cap 64. It must report the `orbit-taskflow-fission-source-cut-census-v1` schema, `status=complete`, and `mapper_invoked=false`.

```sh
mkdir -p "$CENSUS_ROOT"
for workload in llama lu gcn harris radar raytracing; do
  function_name="$(PYTHONPATH="$RUNTIME_ROOT/scripts" python3 -c \
    'from pathlib import Path; import sys; from neighborhood_replay import infer_function; print(infer_function(Path(sys.argv[1]), None))' \
    "$PREP_ROOT/$workload/canonical.mlir")"
  mkdir -p "$CENSUS_ROOT/$workload"
  "$RUNTIME_ROOT/$OPTIMIZER_PIN_RELATIVE" \
    "$PREP_ROOT/$workload/pre-neura.mlir" \
    "--verify-taskflow-fission-source-replay=enumerate-function=$function_name max-fission-actions-per-task=64 output=$CENSUS_ROOT/$workload/cut-census.json" \
    -o /dev/null
done
```

The optimizer path above is relative to the frozen runtime; the helper preserves the same artifact-relative path. The census command reads prepared source and does not invoke the mapper. It is separate from a search attempt and cannot be counted as a scored candidate.

Audit S4/S5 family funnels with the tracked read-only auditor. Its current-edge counts and complete typed-path-presence counts have different semantics; candidates can contain multiple families, so family presence counts are not additive. Keep fission in `action_history.fissionActions`, separate from ordinary actions, when reviewing native top-five histories.

```sh
python3 "$RUNTIME_ROOT/scripts/audit_fusion_fission_funnel.py" \
  --results-root "$RESULTS_ROOT" \
  --census-root "$CENSUS_ROOT" \
  --output-root "$DIAGNOSTICS_ROOT/funnel" \
  --audit-label "$COHORT_ID"

python3 "$RUNTIME_ROOT/scripts/render_neighborhood_table.py" \
  --results-root "$RESULTS_ROOT" \
  --output-dir "$DIAGNOSTICS_ROOT/stage-table"
```

For the cross-cohort comparison, point the renderer at independently validated fixed-1×1 and common-AMOEBA summaries plus the preserved R9 summary/receipts. These historical evidence files may be distributed separately from a clean artifact clone; if they are unavailable, render the fresh stage table and funnel only, and do not fabricate comparison rows. Put renderer output outside every measured result root. A public stage summary supplies status and provenance, not cycle values.

```sh
export FIXED1X1_SUMMARY="${FIXED1X1_SUMMARY:?validated fixed-1x1 summary path}"
export COMMON_AMOEBA_SUMMARY="${COMMON_AMOEBA_SUMMARY:?validated common-AMOEBA summary path}"
export COMMON_AMOEBA_RAY_RESULT="${COMMON_AMOEBA_RAY_RESULT:?validated common-AMOEBA Ray result path}"
export HISTORICAL_SUMMARY="${HISTORICAL_SUMMARY:?preserved R9 summary path}"
export HISTORICAL_STAGE_RECEIPTS="${HISTORICAL_STAGE_RECEIPTS:?preserved R9 stage-receipts path}"

python3 "$RUNTIME_ROOT/scripts/render_fusion_fission_comparison.py" \
  --full-results-root "$RESULTS_ROOT" \
  --fixed-summary "$FIXED1X1_SUMMARY" \
  --common-amoeba-summary "$COMMON_AMOEBA_SUMMARY" \
  --common-amoeba-ray-result "$COMMON_AMOEBA_RAY_RESULT" \
  --historical-summary "$HISTORICAL_SUMMARY" \
  --historical-stage-receipts "$HISTORICAL_STAGE_RECEIPTS" \
  --output-root "$DIAGNOSTICS_ROOT/comparison"
```

The common-DFG AMOEBA Ray II23 record is an independent completed reference from the authenticated original F45 profiles: it covers the original 27 tasks, 216 profile queries, and 177,426 whole-program cycles. The other five common-AMOEBA workloads are not rerun for this reproduction. Preserve the authenticated F45 task count, shape, active replicas, trip-count, and II choices. Replicated task duration is `ceil(full common-parent mapped duration / active replicas)`. Do not remap fission children or derive new II/task-count choices from the search. This reference does not seed the candidate search or alter the fission result.

## Acceptance and reporting limits

A report is ready only when all 30 stage records, source contracts, search summaries, native top-five/control replays, numeric records, independent traces, and source-cut censuses are accounted for. Preserve partial and pending states instead of filling missing records from historical cohorts. Report the formal SRAM status as pending, and label any selected candidate as best-found under the stated budget. Do not call a census, a controlled rewrite probe, an incomplete stage, or the in-progress R11b run a full-cohort result.
