# Original AMOEBA input-0 baseline

This baseline preserves the `hpca-eval` compiler's throughput-guided decisions: replica counts and IDs, oriented CGRA shapes, placement cells, context IDs and parent dispatch order. ORBIT then retimes those decisions using actual current-body mapper II, source-certified macro firings, structural startup and the common inter-task network. Multi-replica tasks retain the original F45 division estimate. The reported value is the resulting compiler schedule makespan; replica estimates are explicitly identified in the result. Original AMOEBA internal placement slots are retained separately.

The new v59 comparison instead passes AMOEBA's selected profile shapes, CGRA counts and replica counts to the same ORBIT communication-aware production scheduler used by the four ablation stages and the fixed 1x1 baseline. Add `--reschedule-with-production-scheduler` together with `--original-f45-replica-scaling`, and use a fresh result root. This mode chooses new placements and critical-path dispatch; it retains the full-parent mapper measurements and the original ceiling replica-duration estimate. Its result and independently validated trace identify `scheduler.backend=orbit-production` and preserve the original decisions separately. The frozen results below continue to describe the original placement/dispatch experiment and must not populate the v59 comparison table.

The standard architecture is [4×4 CGRAs with 2×2 PEs each](../config/architectures/amoeba_4x4_cgra_2x2_context6.yaml), context memory 6, control memory 20 and register count 32. The common [mesh network](../config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml) has 48 directed links, one-cycle latency and 32-bit/cycle bandwidth. SRAM capacity is unknown, so `formal_go=false` throughout. A valid materialization or mapper run does not require formal GO.

## Build the original compiler

Use the LLVM/MLIR build described in [the reproduction guide](INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md). Build and link with one job. The following two patches must be applied **in order** to clean upstream commit `f45a0c5f4cc3163a016250fee865c19ec56f0fa0`:

```sh
export AMOEBA_SRC="${AMOEBA_SRC:?choose a fresh original compiler checkout}"
export AMOEBA_BUILD="${AMOEBA_BUILD:?choose its build directory}"
export ARTIFACT_ROOT="${ARTIFACT_ROOT:?path to this artifact checkout}"
export LLVM_BUILD="${LLVM_BUILD:?path to the pinned LLVM/MLIR build}"
git clone https://github.com/ShangkunLi/neura.git "$AMOEBA_SRC"
git -C "$AMOEBA_SRC" checkout f45a0c5f4cc3163a016250fee865c19ec56f0fa0
git -C "$AMOEBA_SRC" apply \
  "$ARTIFACT_ROOT/reference/input0-neighborhood/patches/TaskProfiler-f45-trace-and-body-evidence.patch"
git -C "$AMOEBA_SRC" apply \
  "$ARTIFACT_ROOT/reference/input0-neighborhood/patches/TaskProfiler-f45-ii23-optin-diagnostic-extension.patch"
cmake -S "$AMOEBA_SRC" -B "$AMOEBA_BUILD" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DMLIR_DIR="$LLVM_BUILD/lib/cmake/mlir" \
  -DLLVM_DIR="$LLVM_BUILD/lib/cmake/llvm"
cmake --build "$AMOEBA_BUILD" --target mlir-neura-opt -- -j1
export AMOEBA_OPTIMIZER="$AMOEBA_BUILD/tools/mlir-neura-opt/mlir-neura-opt"
```

The first patch supplies scheduler decision/dispatch evidence and pre-mapper body export/equivalence checks. The second adds explicit diagnostic II23, selected-task profiling and the opt-in minimum-legal-profile initializer. Both defaults preserve the standard II20 path. Applying both patches to authoritative clean f45 reproduces all 127 implementation files under `include/` and `lib/` byte-for-byte from the measured original-profiler source. This is a source reproduction check; measured mapper and numeric evidence are separate.

## Profile and retime

Profile the complete lowered input-0 companion module. For a parent profile suite, omit `task-names`; for child profiling, take exact child names from the successful C++ materializer report. The selected-task option filters mapper work while keeping the complete module for SSA and source proof.

```sh
"$AMOEBA_OPTIMIZER" "$PENDING_MODULE" --verify-each \
  --architecture-spec="$ARCHITECTURE" \
  --profile-task-candidates="output-json=$PROFILE_ROOT/task-profiles.json max-composed-cgra-count=4 symbol-bound-trip-count=1" \
  --mlir-print-op-generic -o "$PROFILE_ROOT/profiled.mlir"
"$AMOEBA_OPTIMIZER" "$PENDING_MODULE" --verify-each \
  --architecture-spec="$ARCHITECTURE" \
  --verify-task-profiler-body-equivalence="output=$PROFILE_ROOT/profile-body-proof.json" \
  -o /dev/null
```

The eight actual attempts per task are retained, including explicit failures. A failed shape never receives an invented profile or cost. The profiled module must remain byte-identical to its input; body export and the selected orientation must match the current task, actual source trip count and actual mapper body.

The queue `scripts/run_input0_original_amoeba_baselines.py` takes `--inputs` with schema `orbit-original-amoeba-current-profile-inputs-v1` and a `records` object keyed by workload. Each record names `profile_root`, `profile_input` and `caller_shape_proof`; `profile_file` may override the default file beneath `profile_root`. GCN also supplies the source-proved `active_transfer_arguments` 1 through 12. Paths resolve against the artifact root. A fresh run requires `--run-root`, `--optimizer`, `--original-optimizer`, `--source-contract`, `--llvm-build` and `--reference-root`. Its `--help` lists the complete command interface.

Use `--original-f45-replica-scaling` for the original multi-replica baseline. C++ verifies the complete parent body, source trip count and selected mapper profile, then applies the original F45 ceiling division rule to the common full-parent duration:

```text
full_parent_cycles = ceil(structural_startup + compiled_II * (source_macro_firings - 1))
task_cycles = ceil(full_parent_cycles / original_active_replicas)
```

The II is retained unchanged. Every original replica's oriented rectangle, cells and context IDs is preserved; occupancy and network routing use the complete captured cell inventory. Result and trace both carry `replica_timing_policy` with schema `amoeba-original-f45-replica-scaling-v1` and `child_mapper_profiles_used=false`. The historical F45 profile duration, `ceil((compiled_II * (trip - 1) + profile_steps) / active_replicas)`, is independently checked and retained. This reproduces the original replica estimate without claiming that split children were mapped. Actual child materialization remains a separate development path and is not a prerequisite for this baseline.

The queue performs scheduler capture, source binding, caller/noalias import, partition proof, cost adaptation, C++ retiming, independent trace validation and complete input-0 numeric execution. Only results passing mapper equality, numeric and independent trace may enter the cycle table. Keep each new source, optimizer or architecture in a fresh run root. Runtime checks are at least 300 seconds apart; mapper work has no wall-clock timeout. CPU affinity stays within 0–11 and aggregate use within 12 cores.

The [frozen standard results](../diagnostics/input0-original-amoeba-2x2-v56-frozen/README.md) are GCN **106,351**, Harris **1,072,495**, LLaMA **636,723,751**, LU **11,602**, and Radar **1,321,316** cycles. LU's original prepared affine file omitted the carried determinant load. The existing audited input repair, already used by ORBIT, was applied before a fresh 72-profile F45 run. Numeric validation then passed all 4,025 comparisons, and the original counts, shapes, placement cells, contexts, replica IDs and dispatch stayed exactly equal. The unrepaired scalar failure is preserved in the archive and excluded from admission.

## Replay archived parent measurements

After building ORBIT baseline follow-up commit [`a75c848`](https://github.com/guosran/orbit/commit/a75c848eccc010a5c6923cc16fc0e3d6073da73a) and the patched original compiler, use the source/model contract and numeric reference preparation in [the reproduction guide](INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md). The historical ORBIT v38 optimizer is for reproducing the measured ablation; this baseline's new CLI requires the published baseline follow-up source. Set `ARTIFACT_ROOT`, `ORBIT_OPTIMIZER`, `AMOEBA_OPTIMIZER`, `LLVM_BUILD`, `RUN_ROOT` and a fresh `SOURCE_CONTRACT` accordingly.

```sh
python3 scripts/prepare_original_amoeba_frozen_replay.py \
  --artifact-root "$ARTIFACT_ROOT" \
  --bundle-root "$ARTIFACT_ROOT/diagnostics/input0-original-amoeba-2x2-v56-frozen" \
  --output-root "$RUN_ROOT/parent-inputs"

python3 scripts/run_input0_original_amoeba_baselines.py \
  --inputs "$RUN_ROOT/parent-inputs/inputs.json" \
  --run-root "$RUN_ROOT/full-validation" \
  --optimizer "$ORBIT_OPTIMIZER" \
  --original-optimizer "$AMOEBA_OPTIMIZER" \
  --source-contract "$SOURCE_CONTRACT" \
  --results-root "$ARTIFACT_ROOT/results/original-amoeba-$RUN_ID" \
  --original-f45-replica-scaling \
  --llvm-build "$LLVM_BUILD" \
  --reference-root "$ARTIFACT_ROOT/.work/selected-native-numeric-gate" \
  --cpu 0 --workloads gcn harris llama lu radar
```

The [actual public replay check](../reference/input0-neighborhood/evidence/f45-public-frozen-replay-acceptance.json) passed all five programs in a fresh namespace with exactly the same cycles. This reuses the archived actual parent mapper measurements and reruns all current C++ body/source/caller checks, original F45 scheduling, common-network retiming, independent trace and complete numeric gates. It regenerates path-sensitive bindings in a new namespace. To remeasure mapper II, run the original profiler command above on the hydrated pending modules and direct its profiles into another fresh root. The archive importer validates schemas, complete profile counts and exact UTF-8 byte sizes before publishing an input manifest.

## Ray II23 diagnostic

Ray II23 uses a [separate runtime architecture](../config/architectures/amoeba_4x4_cgra_2x2_context6_ctrlmem23_diagnostic.yaml) whose only difference is the full line `ctrl_mem_items: 20` → `ctrl_mem_items: 23`. The model bundle, weights, training ceiling and feature normalization remain at 20. The exact training/runtime YAML, explicit extrapolation and output rule are bound in both predictor metadata and original-profile binding. Unsupported lower bounds above 23 remain explicit and have no predicted II.

Use the queue flags `--diagnostic-ii-ceiling 23`, `--diagnostic-minimum-legal-profile-initialization`, the runtime23 architecture and a separate `--results-root`. The initializer is an additional default-false scheduler extension: Task_13 lacks a legal one-CGRA profile, so it starts from its actual minimum legal profile before the original throughput strategy proceeds. It must be disclosed with the result.

The latest actual Ray suite contains 216 completed attempts: 209 successes and seven Task_13 failures. Its sole successful Task_13 shape is 2×2 CGRAs, II23, steps90 and 1,472 macro firings. The mapper body already contains the complete eight-step static internal expansion, corresponding to 11,776 source work items. Retiming uses 1,472 firings and independently verifies this relationship. The [validated diagnostic](../diagnostics/input0-original-amoeba-ii23-ray-v49-frozen/README.md) has **216,454 cycles**, 61,892 numeric comparisons with zero mismatches, and independent trace validation of 27 tasks, 66 dependencies and 39 routed pairs. Thirteen actual adapter/retimer positive and tamper cases also pass.

Inspect admitted results with `python3 scripts/show_input0_results.py`. The [portable standard baseline summary](../reference/input0-neighborhood/evidence/2x2-original-amoeba-baselines.json) and the separate II23 result namespace retain validation gates and identify the original replica estimation policy.
