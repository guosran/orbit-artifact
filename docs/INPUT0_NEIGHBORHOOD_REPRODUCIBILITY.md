# Reproducing input-0 on the AMOEBA paper architecture

The latest completed experiment is the [R9 five-stage original-input snapshot](../diagnostics/input0-memory-fusion-fission-r9-20261007/README.md). Its captured host receipts and local progress viewer depend on preserved runtime files; they are not clean-clone bindings. The public source-file list now includes all 140 R9 implementation files. Build the published compiler and create fresh exact source/model/script contracts before any new measurement. The commands below document the earlier four-stage v59 setup; they do not reproduce the R9 fission stage automatically. The [fresh-agent prompt](FRESH_AGENT_FUSION_FISSION_20261007.md) gives the actual R9 host paths, controls, and required follow-up work.

The current experiment uses a 4×4 CGRA fabric with **2×2 PEs per CGRA** (64 PEs total), context memory 6 and control memory 20. The physical YAML is copied byte-for-byte from `ShangkunLi/AMOEBA-Test`'s `Evaluation/arch_spec/architecture_4x4_cgra_2x2.yaml`. `ShangkunLi/neura` branch `hpca-eval` supplies the original compiler. See [architecture provenance](../reference/input0-neighborhood/architecture-2x2-provenance.json) for exact revisions.

The new model is the four-member direct ensemble from `guosran/cgra-ii-predictor`, branch `orbit-2x2-predictor`, exported to [ensemble.json](../reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json). It consumes 148 raw features and 61 selected features. It remains a candidate model pending the benchmark-overlap audit. No old 4×4-PE costs or checkpoints are reused.

The active v59 protocol uses four independent stages and the existing ORBIT production scheduler for fixed1x1, S1–S4, and the new AMOEBA comparison. All use critical-path dispatch and the unchanged common explicit network timing. The AMOEBA run keeps its original F45 shape, task-count, and replica choices while ORBIT selects placements and dispatch; its replica duration comes from the original full-parent estimate. The fresh roots are `results/input0-neighborhood-2x2-v59-shared-scheduler-r2`, `results/input0-ray-fission-2x2-v59-shared-scheduler-r2`, `results/input0-all-unit-2x2-v59-shared-scheduler-r2`, and `results/input0-amoeba-full-2x2-v59-shared-scheduler-r2`. No v59 results are claimed yet. The stopped v58 queue is superseded and contributes no LU result, cache, checkpoint, or other evidence. Historical v19, v38, v57, and v58 exports retain their own labels. Ray Task_13's historical v38 II lower bound and fission evidence remain separate.

Each stage uses at most four rounds, 4,096 unique complete-program candidates scored, beam width 16 over complete programs, four diversity slots and a five-candidate native shortlist. The temporal dimension is the existing production scheduler's critical-path dispatch policy: it computes dependency-, resource-, and network-ready start cycles. The search does not enumerate all dispatch orders or arbitrary times. C++ owns candidates, proofs, rewrites, costs, production scheduling and predicted ranking. Python prepares inputs, launches stages and validates results. Three disjoint four-CPU lanes use at most 12 CPUs; build and link use one job.

## Historical v38 source and build inputs

Build a new optimizer from ORBIT commit `99ded7396f31c71ee0946389c6946a5f58c770c6`. Its 131 bound implementation files match the v38 experiment payload byte-for-byte. The measured run was started before this commit and retains its original dirty-checkout binding; the publication commit does not rewrite that runtime evidence. The new cost namespace binds source repository `https://github.com/guosran/orbit.git`, source base `6a1b6fcf6e155651e96b3b881565ad58fdf0c03e`, and the exact implementation payload. The source contract separately records the actual checkout commit and dirty state. Fresh source/model/architecture changes require fresh contracts and result namespaces. The historical v19 results use different hardware and remain [separate diagnostics](INPUT0_NEIGHBORHOOD_ABLATION.md).

The build requires CMake, Ninja, a C++17 compiler, and LLVM/MLIR revision `6146a88f60492b520a36f8f8f3231e15f3cc6082` with MLIR Python bindings and runner tools. If that build is not already available, create it in directories of your choice:

```sh
export LLVM_SRC="${LLVM_SRC:?directory for the LLVM checkout}"
export LLVM_BUILD="${LLVM_BUILD:?directory for the LLVM build}"
git clone https://github.com/llvm/llvm-project.git "$LLVM_SRC"
git -C "$LLVM_SRC" checkout 6146a88f60492b520a36f8f8f3231e15f3cc6082
python3 -m pip install -r "$LLVM_SRC/mlir/python/requirements.txt"
cmake -S "$LLVM_SRC/llvm" -B "$LLVM_BUILD" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS="mlir;clang" \
  -DLLVM_TARGETS_TO_BUILD=Native \
  -DLLVM_ENABLE_RTTI=ON \
  -DMLIR_ENABLE_BINDINGS_PYTHON=ON
ninja -C "$LLVM_BUILD" mlir-opt mlir-runner mlir-translate \
  mlir_runner_utils mlir_c_runner_utils MLIRPythonModules FileCheck clang llc -j1
```

Configure and build the optimizer from the selected ORBIT source checkout:

```sh
export ORBIT_SRC="${ORBIT_SRC:?path to the published ORBIT checkout}"
export ORBIT_BUILD="${ORBIT_BUILD:?path to the ORBIT build directory}"
cmake -S "$ORBIT_SRC" -B "$ORBIT_BUILD" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DMLIR_DIR="$LLVM_BUILD/lib/cmake/mlir" \
  -DLLVM_DIR="$LLVM_BUILD/lib/cmake/llvm"
ninja -C "$ORBIT_BUILD" tools/mlir-amoeba-opt/mlir-amoeba-opt -j1
```

## v59 shared ORBIT scheduler protocol

Use a source checkout containing the shared-scheduler source binding, a newly built optimizer, and a new source/model contract. Do not reuse the v57 binary or v58 chain state. If the source changes, configure and build it with the LLVM/MLIR checkout described above:

```sh
export ARTIFACT_ROOT="${ARTIFACT_ROOT:?path to the input-0 artifact checkout}"
export ORBIT_SRC="${ORBIT_SRC:?path to the selected ORBIT source checkout}"
export ORBIT_BUILD="${ORBIT_BUILD:?path to a fresh ORBIT build directory}"
export LLVM_BUILD="${LLVM_BUILD:?path to the pinned LLVM/MLIR build directory}"
export ORBIT_LLVM_BUILD="$LLVM_BUILD"
export ORBIT_OPTIMIZER="${ORBIT_OPTIMIZER:-$ORBIT_BUILD/tools/mlir-amoeba-opt/mlir-amoeba-opt}"
export ORBIT_SOURCE_BASE="${ORBIT_SOURCE_BASE:?exact source base for the selected ORBIT checkout}"
export ORBIT_SOURCE_VARIANT="input0-2x2-v59-shared-orbit-scheduler"
export ORBIT_COST_SOURCE_COMMIT="6a1b6fcf6e155651e96b3b881565ad58fdf0c03e"
export RUN_ID="input0-neighborhood-2x2-v59-shared-scheduler-r2"
export RUN_ROOT="$ARTIFACT_ROOT/.work/$RUN_ID"
export RESULTS_ROOT="$ARTIFACT_ROOT/results/input0-neighborhood-2x2-v59-shared-scheduler-r2"
export EXPORT_ROOT="$ARTIFACT_ROOT/diagnostics/input0-neighborhood-2x2-v59-shared-scheduler-r2"
export SOURCE_CONTRACT_FILE="$ARTIFACT_ROOT/.work/post-publication/source-model-contract-v59-shared-scheduler-r2.json"
export PATH="$LLVM_BUILD/bin:$PATH"
cd "$ARTIFACT_ROOT"

cmake -S "$ORBIT_SRC" -B "$ORBIT_BUILD" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DMLIR_DIR="$LLVM_BUILD/lib/cmake/mlir" \
  -DLLVM_DIR="$LLVM_BUILD/lib/cmake/llvm"
ninja -C "$ORBIT_BUILD" tools/mlir-amoeba-opt/mlir-amoeba-opt -j1

python3 scripts/write_neighborhood_source_contract.py \
  --artifact-root "$ARTIFACT_ROOT" \
  --source-root "$ORBIT_SRC" \
  --build-root "$ORBIT_BUILD" \
  --model-root "$ARTIFACT_ROOT/reference/input0-neighborhood/models/per-cgra-2x2" \
  --optimizer "$ORBIT_OPTIMIZER" \
  --source-commit "$ORBIT_COST_SOURCE_COMMIT" \
  --source-file-list "$ARTIFACT_ROOT/reference/input0-neighborhood/source-file-list.json" \
  --sram-config "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json" \
  --inter-task-network "$ARTIFACT_ROOT/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml" \
  --output "$SOURCE_CONTRACT_FILE"
```

The contract captures the exact source files, model payloads, replay scripts, common network, and optimizer pin. Keep the `source_commit` cost/model namespace distinct from `published_source_commit`, which identifies the checked-out compiler code. A changed source, binary, model, architecture, protocol, or network requires a fresh contract and output root.

The artifact supplies complete affine inputs and caller evidence under `reference/input0-source-domains/`, the self-contained direct ensemble under `reference/input0-neighborhood/models/per-cgra-2x2/`, numeric wrappers, the LLaMA runner harness and independent reference sources. The separate ORBIT network file specifies a 4×4 directed mesh with one-cycle links and 32 bits/cycle bandwidth. It is bound separately because the paper's physical YAML has no communication section. Per-CGRA SRAM capacity is unknown and remains pending; no byte capacity is inferred from context memory.

## Prepare a fresh binding

The bound v59 protocol records four independent stages: S1 `shape-temporal`, S2 adds replica, S3 adds tiling, and S4 adds fusion. Each stage starts from the same original canonical input with its own beam, archive and checkpoint. No stage imports another stage's winner, frontier, or result. Historical v19, v38, v57 and v58 records retain their prior scheduler and stage labels. The fixed1x1 result is also fresh and uses critical-path dispatch.

Regenerate canonical modules, proofs, task-shape spaces, model cost catalogs, and ML caches from the source-domain manifest. Unsupported model shapes remain explicit catalog rows. The helper also builds numeric reference libraries and installs the portable LLaMA harness at the runtime path used by replay.

```sh
python3 scripts/prepare_input0_neighborhood_reproduction.py \
  --artifact-root "$ARTIFACT_ROOT" \
  --optimizer "$ORBIT_OPTIMIZER" \
  --architecture "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml" \
  --model-root "$ARTIFACT_ROOT/reference/input0-neighborhood/models/per-cgra-2x2" \
  --source-repository https://github.com/guosran/orbit.git \
  --source-commit "$ORBIT_COST_SOURCE_COMMIT" \
  --output-root "$RUN_ROOT/source-domain-prep" \
  --jobs 3

python3 scripts/write_neighborhood_publication_command.py \
  --artifact-root "$ARTIFACT_ROOT" \
  --source-root "$ORBIT_SRC" \
  --build-root "$ORBIT_BUILD" \
  --source-base "$ORBIT_SOURCE_BASE" \
  --source-variant "$ORBIT_SOURCE_VARIANT" \
  --config "$RUN_ROOT/source-domain-prep/input0-chain.json" \
  --protocol-template "$ARTIFACT_ROOT/reference/input0-neighborhood/protocol-2x2-shared-orbit-scheduler-template.json" \
  --protocol-output "$RUN_ROOT/protocol-bound.json" \
  --source-contract-file "$SOURCE_CONTRACT_FILE" \
  --optimizer "$ORBIT_OPTIMIZER" \
  --architecture "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml" \
  --model-root "$ARTIFACT_ROOT/reference/input0-neighborhood/models/per-cgra-2x2" \
  --sram-config "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json" \
  --inter-task-network "$ARTIFACT_ROOT/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml" \
  --mapping-cache "$RUN_ROOT/mapping-cache" \
  --output-root "$RESULTS_ROOT" \
  --output "$RUN_ROOT/chain-command.json"
```

Preparation writes a new chain configuration and fresh canonical/cost inputs below `$RUN_ROOT/source-domain-prep/`. The command writer copies the v59 template into a new bound protocol and records the actual source checkout; it never edits the template. The writer requires the cohort ID to match the fresh results root and the unchanged common explicit network. The source contract, bound protocol, and optimizer must identify the same source/model build. Use a fresh run root and result root for every changed binding.

For a quick configuration check before running C++, add `--dry-run` to the preparation command. It validates the portable inputs and records the exact C++ pass commands without creating canonical modules or cost catalogs. A dry run is not a search result.

The original-Ray exception needs an actual C++ preflight. This command verifies the exact catalog and source bindings, requires the specific no-supported-shape failure, and preserves all eight bounds without assigning cycles:

```sh
python3 scripts/check_input0_model_domain.py \
  --chain-command-file "$RUN_ROOT/chain-command.json" \
  --output "$RESULTS_ROOT/model-domain-evidence.json"
```

## Run and resume

Run the saved launch command through the bounded coordinator:

```sh
python3 scripts/run_neighborhood_parallel_batch.py \
  --chain-command-file "$RUN_ROOT/chain-command.json" \
  --workers 3 --cpus-per-worker 4 --jobs-per-worker 4
```

If this fresh run is interrupted, rerun that same coordinator command against the same output tree, source contract, bound protocol, and optimizer. It resumes the existing stage checkpoints and C++ frontier. Do not rerun preparation or regenerate the source contract and bound protocol for a resume. Never use this procedure to resume the frozen v19 result/checkpoint tree with a different source, contract, protocol, or optimizer. Failures retain per-stage diagnostics while independent workloads continue; a failed batch returns nonzero.

## Validate and inspect results

To see the available **input-0 only** cycles at any point, including the fixed 1×1 CGRA baseline and the original AMOEBA baseline once its whole-program native, numeric and independent trace records pass, run:

```sh
python3 scripts/show_input0_results.py
```

A dash means that the corresponding v59 result has not passed its binding and validation gates. The default viewer reads only the fresh fixed1x1 and shared-scheduler AMOEBA roots; it never fills those columns from historical rows. The AMOEBA cell also requires proof that original F45 shapes, task counts, and replicas were retained, and that its full-parent replica estimate passed. Multi-replica profiles alone do not establish whole-program cycles.

After the batch finishes, collect mapper-II evidence and render the stage table:

```sh
python3 scripts/collect_neighborhood_mapper_ii.py \
  --results-root "$RESULTS_ROOT"
python3 scripts/render_neighborhood_table.py \
  --results-root "$RESULTS_ROOT" \
  --output-dir "$RESULTS_ROOT/table"
```

For the new four-stage scheme, check all 20 measured workload-stage cells for real mapper, native, numeric and independent trace validation. The four original-Ray cells require explicit C++ model-domain evidence and have no cycle value when that exclusion applies. Numeric failures are excluded from actual-stage summaries. The exporter adds validated Ray N/A cells to the complete table; the intermediate renderer contains observed stage results. Historical five-stage protocols continue to render with their recorded S1–S5 order.

For a compact export of the complete main report, use a fresh diagnostics directory. Install matplotlib for plotting. The exporter rejects missing measured cells, invalid exclusion evidence and mixed runtime bindings without writing a partial output; `--render-plots` writes the normalized and absolute-cycle plots alongside its JSON/Markdown results.

```sh
python3 scripts/export_neighborhood_final_results.py \
  --results-root "$RESULTS_ROOT" \
  --protocol "$RUN_ROOT/protocol-bound.json" \
  --repository-root "$ARTIFACT_ROOT" \
  --output-dir "$EXPORT_ROOT" \
  --model-domain-evidence "$RESULTS_ROOT/model-domain-evidence.json" \
  --render-plots \
  --plot-script "$ARTIFACT_ROOT/scripts/plot_input0_neighborhood_ablation.py"
```

SRAM residency remains a separate pending gate, so `formal_go=false`. Native cycles are ORBIT production-scheduler cycles using measured mapper II and the common explicit network, not hardware or RTL wall-clock measurements. Original AMOEBA and ORBIT retain separate DFGs and candidate spaces. Original mapper profiles alone do not establish a complete native/numeric/trace baseline.

The all-unit baseline is a separate measured run with every task fixed to one CGRA. It consumes actual mapper profiles, not ML predictions. Use a fresh output directory after preparing the same input configuration:

```sh
python3 scripts/run_input0_all_unit_baselines.py \
  --config "$RUN_ROOT/source-domain-prep/input0-chain.json" \
  --protocol "$RUN_ROOT/protocol-bound.json" \
  --source-contract-file "$SOURCE_CONTRACT_FILE" \
  --optimizer "$ORBIT_OPTIMIZER" \
  --architecture "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml" \
  --inter-task-network "$ARTIFACT_ROOT/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml" \
  --sram-config "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json" \
  --mapping-cache "$RUN_ROOT/mapping-cache" \
  --llvm-build "$LLVM_BUILD" \
  --output-root "$ARTIFACT_ROOT/results/input0-all-unit-2x2-v59-shared-scheduler-r2"
```

The v59 protocol makes the fixed1x1 native replay use critical-path dispatch with the common explicit network. The fresh result root must match `fixed1x1_cohort_id`; historical all-unit rows never fill the default v59 column. The original Ray all-unit mapping is unsupported at maximum II 20. The runner preserves that failure and continues independent workloads; its nonzero final exit does not erase completed baseline measurements.

For the new AMOEBA comparison, prepare current-body F45 profiles and the input manifest described in [the original compiler and input-0 guide](ORIGINAL_AMOEBA_INPUT0.md). Use the source contract and a fresh run root, and pass both `--original-f45-replica-scaling` and `--reschedule-with-production-scheduler`:

```sh
python3 scripts/run_input0_original_amoeba_baselines.py \
  --inputs "$AMOEBA_INPUTS" \
  --run-root "$ARTIFACT_ROOT/.work/input0-amoeba-full-2x2-v59-shared-scheduler-r2" \
  --optimizer "$ORBIT_OPTIMIZER" \
  --original-optimizer "$ORIGINAL_AMOEBA_OPTIMIZER" \
  --source-contract "$SOURCE_CONTRACT_FILE" \
  --results-root "$ARTIFACT_ROOT/results/input0-amoeba-full-2x2-v59-shared-scheduler-r2" \
  --architecture "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml" \
  --network "$ARTIFACT_ROOT/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml" \
  --ensemble "$ARTIFACT_ROOT/reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json" \
  --original-f45-replica-scaling \
  --reschedule-with-production-scheduler \
  --llvm-build "$LLVM_BUILD" \
  --reference-root "$ARTIFACT_ROOT/reference" \
  --cpu "${AMOEBA_CPU:-10}"
```

The v59 AMOEBA row is admitted only when task counts, selected shapes and replica counts match the original F45 decisions; placement and dispatch may change. Its full-parent replica estimate, common network timing, numeric checks, selected-body mapper binding and independent trace must pass. The frozen original-AMOEBA baseline remains a historical row. The original Ray II23 run also remains historical unless separately rebound and validated against the shared scheduler; it does not replace the v59 original-Ray exclusion. The frozen ORBIT v38 experiment stays at training/runtime II20.

For the separate v59 Ray fission supplement, prepare source domains with `--ray-fission-split-at 4 --workloads raytracing`, using the same source contract, optimizer, architecture, model and cost-source commit. Bind `protocol-2x2-ray-fission-shared-orbit-scheduler-template.json` to `.work/input0-ray-fission-2x2-v59-shared-scheduler-r2/protocol-bound.json` and output only to `results/input0-ray-fission-2x2-v59-shared-scheduler-r2`. Its four stages use the same shared ORBIT scheduler and independent initialization. Keep the original-Ray exclusion in the main report even if the fission supplement maps successfully.

The optional `scripts/check_per_cgra_2x2_catalog_runtime.py` validates actual C++ features and predictions against the predictor source/checkpoint at commit `3ade31806cb4c92e31888109f7c42b8a77e4cbce`, checks exact cache-hit parity and rejects mutated model/provenance inputs. Its `--help` lists the fresh preparation records and read-only upstream checkout it consumes; it requires CPU PyTorch. [Recorded acceptance](../reference/input0-neighborhood/evidence/per-cgra-2x2-runtime-acceptance.json) covers runtime consistency, not predictor accuracy or production readiness.
