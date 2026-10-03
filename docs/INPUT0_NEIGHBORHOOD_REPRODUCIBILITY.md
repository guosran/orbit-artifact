# Reproducing the six-program input-0 ablation

The publication profile uses the ORBIT source snapshot, six fixed input-0 programs, bundled model and costs, and the production scheduler with explicit communication. Every workload-stage has the same budget: four rounds, 1,024 unique complete candidate scores, beam width 16, at least four diversity slots when available, and five native shortlist entries. Results are best-found. The 20-round/20,000-candidate profile belongs to a separate output namespace.

## Dependencies and source build

Use Python 3.10 or newer, CMake, Ninja, a C++17 compiler, and LLVM/MLIR revision `6146a88f60492b520a36f8f8f3231e15f3cc6082`. The LLVM build needs MLIR Python bindings, `mlir-opt`, `mlir-translate`, `mlir-runner`, and runner libraries. For a new LLVM build, enable `LLVM_ENABLE_PROJECTS=mlir;clang` and `MLIR_ENABLE_BINDINGS_PYTHON=ON`. ORBIT vendors the required Neura implementation with their upstream provenance and notices.

```sh
git clone https://github.com/guosran/orbit.git
git -C orbit checkout 6a1b6fcf6e155651e96b3b881565ad58fdf0c03e
git clone https://github.com/guosran/orbit-artifact.git
export ORBIT_SRC="$PWD/orbit"
export ARTIFACT_ROOT="$PWD/orbit-artifact"
export AMOEBA_TEST_ROOT="$ARTIFACT_ROOT/reference/input0-neighborhood/reference-source"
export LLVM_BUILD="${LLVM_BUILD:?set LLVM_BUILD to the pinned LLVM/MLIR build}"
export ORBIT_LLVM_BUILD="$LLVM_BUILD"
export ORBIT_BUILD="$PWD/orbit-build"
export ORBIT_OPTIMIZER="$ORBIT_BUILD/tools/mlir-amoeba-opt/mlir-amoeba-opt"
export PATH="$LLVM_BUILD/bin:$PATH"
python3 -m pip install numpy pybind11==3.0.1 nanobind==2.4.0
cmake -S "$ORBIT_SRC" -B "$ORBIT_BUILD" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DMLIR_DIR="$LLVM_BUILD/lib/cmake/mlir" \
  -DLLVM_DIR="$LLVM_BUILD/lib/cmake/llvm"
ninja -C "$ORBIT_BUILD" tools/mlir-amoeba-opt/mlir-amoeba-opt -j1
cd "$ARTIFACT_ROOT"
```

## Install the bundled inputs

`reference/input0-neighborhood/templates` contains static MLIR, caller proofs, parent costs, the model quartet, historical candidate seed programs, protocol and chain configuration. The preparation helper substitutes declared roots, checks model inputs, installs the numeric entrypoint, and builds six independent C++ reference libraries. Conflicting existing files fail closed; use a fresh checkout for a changed binding.

```sh
python3 scripts/prepare_input0_neighborhood_reproduction.py \
  --source-root "$ORBIT_SRC" --build-root "$ORBIT_BUILD" \
  --llvm-build "$LLVM_BUILD" --amoeba-test-root "$AMOEBA_TEST_ROOT"
python3 scripts/write_neighborhood_source_contract.py \
  --source-root "$ORBIT_SRC" --build-root "$ORBIT_BUILD" --optimizer "$ORBIT_OPTIMIZER" \
  --output .work/input0-neighborhood-publication/source-model-contract.json
```

The source contract embeds exact source, model and replay texts with no hash substitution. The six independent reference functions are bundled from the pinned AMOEBA-Test revision recorded in `reference/input0-neighborhood/reference-source/UPSTREAM.json`. It records the published checkout separately from the upstream source identity retained by the original task-cost catalogue. Setup does not train a model. No prefilled ML or mapper cache ships: C++ regenerates them during the run, and real mapper replay recomputes the selected mappings. Cache admission still requires the compiler's exact mapper-visible body, oriented shape, model and architecture checks. Historical seeds supply modules and shapes; C++ validates and rescores them before admission.

## Run all five stages

Save structured launcher argv, then run the bounded parallel coordinator:

```sh
python3 scripts/write_neighborhood_publication_command.py \
  --optimizer "$ORBIT_OPTIMIZER" \
  --output-root results/input0-neighborhood-publication \
  --output .work/input0-neighborhood-publication/chain-command.json
python3 scripts/run_neighborhood_parallel_batch.py \
  --chain-command-file .work/input0-neighborhood-publication/chain-command.json \
  --workers 3 --cpus-per-worker 4 --jobs-per-worker 4
```

Each of three lanes owns four available CPUs and one complete workload chain at a time. Candidate scoring in the frozen v11 C++ pass is serial within each workload; the four jobs parallelize mapper/native replay. Consequently this coordinator does not guarantee twelve busy cores throughout search. For a smaller machine, use `--workers 1 --cpus-per-worker 4 --jobs-per-worker 4`. Source compilation and linking remain single job. The 12-core host budget is independent of the modeled 16-CGRA fabric. The individual frozen launcher permits at most ten mapper jobs; the coordinator splits workloads rather than passing `--jobs 12` to it.

Rerun the same command to recover interruptions. Generated, ignored checkpoints retain beam, archive, pending neighbors, round, budget consumption and exact version binding; recovery continues the saved frontier. Checkpoints and logs are not part of the committed results. Changing source, optimizer, protocol, architecture, model, immutable inputs or budget requires a new namespace. Failed workers retain errors and yield a nonzero batch exit while independent workloads finish. Mapper errors remain in their rank directories, and other candidates continue. No wall-clock timeout is imposed.

## Inspect results

```sh
python3 scripts/collect_neighborhood_mapper_ii.py \
  --results-root results/input0-neighborhood-publication
python3 scripts/render_neighborhood_table.py \
  --results-root results/input0-neighborhood-publication \
  --output-dir results/input0-neighborhood-publication/table
```

Each stage's `result.json` records predicted top five, native ranks, controls, the measured winner, numeric/trace/SRAM states and stop reason. The machine table records selected transformations, cache statistics, reject reasons, search rounds and time, and differences from S1 and the previous stage. `mapper-ii-evidence.json` separates ML predicted II from actual mapper II. The stage value is the best legal, measured whole-program cycle score among shortlist and controls.

Published observations are under `reference/input0-neighborhood/evidence`. Paths are normalized to symbolic roots, and large text evidence is compressed. A fresh run creates its own concrete byte/path binding and resumable checkpoints. SRAM residency is reported separately and is not a formal SRAM GO. Native cycles are production scheduler scores using actual mapper II, not hardware or RTL wall-clock measurements. Neither RTL nor the resnet fixture is part of this procedure.

## Regenerate the ablation figures

Install Matplotlib for plotting, then render the observed table or a completed fresh run:

```sh
python3 -m pip install matplotlib
python3 scripts/plot_input0_neighborhood_ablation.py \
  --table reference/input0-neighborhood/evidence/table/neighborhood-stage-table.json \
  --output-dir reference/input0-neighborhood/figures
# For a fresh run, use results/input0-neighborhood-publication/table/neighborhood-stage-table.json.
```

The script requires all 30 native/numeric/trace-validated cells and writes normalized and absolute-cycle PNG, SVG and PDF figures plus the plotted CSV. It reads stage values and does not select candidates.
