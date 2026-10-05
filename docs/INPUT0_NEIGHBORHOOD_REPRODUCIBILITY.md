# Reproducing input-0 on the AMOEBA paper architecture

The current experiment uses a 4×4 CGRA fabric with **2×2 PEs per CGRA** (64 PEs total), context memory 6 and control memory 20. The physical YAML is copied byte-for-byte from `ShangkunLi/AMOEBA-Test`'s `Evaluation/arch_spec/architecture_4x4_cgra_2x2.yaml`. `ShangkunLi/neura` branch `hpca-eval` supplies the original compiler. See [architecture provenance](../reference/input0-neighborhood/architecture-2x2-provenance.json) for exact revisions.

The new model is the four-member direct ensemble from `guosran/cgra-ii-predictor`, branch `orbit-2x2-predictor`, exported to [ensemble.json](../reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json). It consumes 148 raw features and 61 selected features. It remains a candidate model pending the benchmark-overlap audit. No old 4×4-PE costs or checkpoints are reused.

The main report contains five measured workload curves and five explicit out-of-model-domain cells for the original Ray program. Ray Task_13 has a source-proved II lower bound above 20 on all eight permitted shapes. A source-owned split-at-4 fission curve is a separate supplement with the same hardware, model and five-stage budget. It does not replace Ray in the main table.

Every measured stage uses at most four rounds, 4,096 complete candidates scored, beam width 16, four diversity slots and a five-candidate native shortlist. C++ owns candidates, proofs, rewrites, costs, production scheduling and predicted ranking. Python prepares inputs, launches stages and validates results. Three disjoint four-CPU lanes use at most 12 CPUs; build and link use one job.

## Source and build inputs

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

Set the source, build and fresh run paths. The model cost-source base must match the published protocol template.

```sh
export ORBIT_SRC="${ORBIT_SRC:?path to the published ORBIT checkout}"
export ARTIFACT_ROOT="${ARTIFACT_ROOT:?path to the input-0 artifact checkout}"
export ORBIT_BUILD="${ORBIT_BUILD:?path to the ORBIT build directory}"
export LLVM_BUILD="${LLVM_BUILD:?path to the pinned LLVM/MLIR build directory}"
export ORBIT_LLVM_BUILD="$LLVM_BUILD"
export ORBIT_OPTIMIZER="${ORBIT_OPTIMIZER:-$ORBIT_BUILD/tools/mlir-amoeba-opt/mlir-amoeba-opt}"
export ORBIT_SOURCE_BASE="99ded7396f31c71ee0946389c6946a5f58c770c6"
export ORBIT_SOURCE_VARIANT="paper-2x2-direct-v38"
export ORBIT_PROTOCOL_TEMPLATE="${ORBIT_PROTOCOL_TEMPLATE:-$ARTIFACT_ROOT/reference/input0-neighborhood/protocol-2x2-direct-model-template.json}"
export ORBIT_COST_SOURCE_COMMIT="6a1b6fcf6e155651e96b3b881565ad58fdf0c03e"
export RUN_ID="${RUN_ID:?choose a new unique run identifier}"
export RUN_ROOT="$ARTIFACT_ROOT/.work/input0-neighborhood-$RUN_ID"
export RESULTS_ROOT="$ARTIFACT_ROOT/results/input0-neighborhood-$RUN_ID"
export EXPORT_ROOT="$ARTIFACT_ROOT/diagnostics/neighborhood-$RUN_ID"
export PATH="$LLVM_BUILD/bin:$PATH"
cd "$ARTIFACT_ROOT"
```

The artifact supplies complete affine inputs and caller evidence under `reference/input0-source-domains/`, the self-contained direct ensemble under `reference/input0-neighborhood/models/per-cgra-2x2/`, numeric wrappers, the LLaMA runner harness and independent reference sources. The separate ORBIT network file specifies a 4×4 directed mesh with one-cycle links and 32 bits/cycle bandwidth. It is bound separately because the paper's physical YAML has no communication section. Per-CGRA SRAM capacity is unknown and remains pending; no byte capacity is inferred from context memory.

## Prepare a fresh binding

Build the optimizer and set `ORBIT_OPTIMIZER` first. Then regenerate canonical modules, proofs, task-shape spaces, model cost catalogs, and ML caches from the source-domain manifest. Unsupported model shapes remain explicit catalog rows. The helper also builds the six independent numeric reference libraries and installs the portable LLaMA harness at the runtime path used by replay.

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

python3 scripts/write_neighborhood_source_contract.py \
  --artifact-root "$ARTIFACT_ROOT" \
  --source-root "$ORBIT_SRC" \
  --build-root "$ORBIT_BUILD" \
  --optimizer "$ORBIT_OPTIMIZER" \
  --model-root "$ARTIFACT_ROOT/reference/input0-neighborhood/models/per-cgra-2x2" \
  --source-commit "$ORBIT_COST_SOURCE_COMMIT" \
  --sram-config "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json" \
  --inter-task-network "$ARTIFACT_ROOT/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml" \
  --source-file-list "$ARTIFACT_ROOT/reference/input0-neighborhood/source-file-list.json" \
  --output "$RUN_ROOT/source-model-contract.json"

python3 scripts/write_neighborhood_publication_command.py \
  --artifact-root "$ARTIFACT_ROOT" \
  --source-root "$ORBIT_SRC" \
  --build-root "$ORBIT_BUILD" \
  --source-base "$ORBIT_SOURCE_BASE" \
  --source-variant "$ORBIT_SOURCE_VARIANT" \
  --config "$RUN_ROOT/source-domain-prep/input0-chain.json" \
  --protocol-template "$ORBIT_PROTOCOL_TEMPLATE" \
  --protocol-output "$RUN_ROOT/protocol-bound.json" \
  --source-contract-file "$RUN_ROOT/source-model-contract.json" \
  --optimizer "$ORBIT_OPTIMIZER" \
  --architecture "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml" \
  --model-root "$ARTIFACT_ROOT/reference/input0-neighborhood/models/per-cgra-2x2" \
  --sram-config "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json" \
  --inter-task-network "$ARTIFACT_ROOT/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml" \
  --mapping-cache "$RUN_ROOT/mapping-cache" \
  --output-root "$RESULTS_ROOT" \
  --output "$RUN_ROOT/chain-command.json"
```

Preparation writes a new chain configuration and fresh canonical/cost inputs below `$RUN_ROOT/source-domain-prep/`. The command writer copies the supplied profile into a new bound protocol and records the actual source checkout; it never edits the input profile. Its validation rejects historical seed fields, stale model/cost lineage, incomplete model bundles, and a source contract built from a different checkout. The new bound protocol and source contract must agree with the selected source, optimizer, and variant. Use a new output namespace whenever source, optimizer, protocol, model bytes, architecture, or cost inputs change.

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

A dash means that the corresponding validated result is not available. The AMOEBA column reports a whole-program fixed-decision retiming result after mapper/body, numeric and independent trace checks. Multi-replica tasks explicitly retain the original F45 duration estimate; mapper II or an isolated profile duration alone does not establish a result.

After the batch finishes, collect mapper-II evidence and render the stage table:

```sh
python3 scripts/collect_neighborhood_mapper_ii.py \
  --results-root "$RESULTS_ROOT"
python3 scripts/render_neighborhood_table.py \
  --results-root "$RESULTS_ROOT" \
  --output-dir "$RESULTS_ROOT/table"
```

Check all 25 measured workload-stage cells for real mapper, native, numeric and independent trace validation. The five original-Ray cells require explicit C++ model-domain evidence and have no cycle value. Numeric failures are excluded from actual-stage summaries. Use the exporter below for the complete table and figures: it adds the validated Ray N/A cells. The intermediate renderer alone contains only observed stage results.

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

SRAM residency remains a separate pending gate, so `formal_go=false`. Native cycles are production-scheduler cycles using measured mapper II, not hardware or RTL wall-clock measurements. All-unit and original AMOEBA full-flow records must use the same 2×2-PE architecture and communication protocol before comparison. Original mapper profiles alone do not establish a complete native/numeric/trace baseline.

The all-unit baseline is a separate measured run with every task fixed to one CGRA. It consumes actual mapper profiles, not ML predictions. Use a fresh output directory after preparing the same input configuration:

```sh
python3 scripts/run_input0_all_unit_baselines.py \
  --config "$RUN_ROOT/source-domain-prep/input0-chain.json" \
  --protocol "$RUN_ROOT/protocol-bound.json" \
  --source-contract-file "$RUN_ROOT/source-model-contract.json" \
  --optimizer "$ORBIT_OPTIMIZER" \
  --architecture "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml" \
  --inter-task-network "$ARTIFACT_ROOT/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml" \
  --sram-config "$ARTIFACT_ROOT/config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json" \
  --mapping-cache "$RUN_ROOT/mapping-cache" \
  --llvm-build "$LLVM_BUILD" \
  --output-root "$RESULTS_ROOT/all-unit-baseline"
```

The original Ray all-unit mapping is unsupported at maximum II 20. The runner preserves that failure and continues independent workloads; its nonzero final exit does not erase completed baseline measurements.

For the preserved original AMOEBA baseline, follow [the original compiler and input-0 guide](ORIGINAL_AMOEBA_INPUT0.md). It includes both prerequisite patches for clean upstream f45, the explicit original replica estimation policy, and the separately bound Ray II23 diagnostic. The frozen ORBIT v38 experiment above stays at training/runtime II20; the Ray II23 diagnostic does not replace its original-Ray exclusions.

For the separate Ray supplement, prepare source domains and the Ray-only chain config with `prepare_input0_neighborhood_reproduction.py --ray-fission-split-at 4 --workloads raytracing` and the same optimizer, architecture, model, source repository and cost-source commit. Use `protocol-2x2-ray-fission-template.json`, a Ray-only chain config and a separate output tree. Keep the original-Ray exclusion in the main report even if the supplement maps successfully.

The optional `scripts/check_per_cgra_2x2_catalog_runtime.py` validates actual C++ features and predictions against the predictor source/checkpoint at commit `3ade31806cb4c92e31888109f7c42b8a77e4cbce`, checks exact cache-hit parity and rejects mutated model/provenance inputs. Its `--help` lists the fresh preparation records and read-only upstream checkout it consumes; it requires CPU PyTorch. [Recorded acceptance](../reference/input0-neighborhood/evidence/per-cgra-2x2-runtime-acceptance.json) covers runtime consistency, not predictor accuracy or production readiness.
