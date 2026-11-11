> Publication snapshot of `results/taskflow/data-reuse-v21/REPRODUCE.md`. Relative experiment paths refer to that ignored local result directory. Raw observations, frozen tools and failed attempts remain unchanged locally. The v21 report records the v20 numerical erratum.

# ORBIT v21 clean reproduction

Use fresh output directories. No command commits or pushes. Core decisions,
candidate construction, planning, checks, scheduling and pricing remain C++/MLIR;
Python prepares fixtures, launches tools and audits evidence. Historical evidence
and binaries are read-only inputs. The original Amoeba/CGRA compiler is preserved,
not rebuilt by the independent Core/AIR commands below.

## Current source builds

```sh
env -i HOME=/home/shiran PATH=/usr/bin:/bin \
 LLVM_BUILD=/home/shiran/project/llvm-project/build ORBIT_BUILD_JOBS=2 \
 bash /home/shiran/project/orbit/scripts/build-core.sh /absolute/new/core

env -i HOME=/home/shiran PATH=/usr/bin:/bin bash --noprofile --norc -c '
cmake -S /home/shiran/project/orbit -B /absolute/new/air -G Ninja \
 -DCMAKE_BUILD_TYPE=Release \
 -DMLIR_DIR=/home/shiran/project/llvm-project/build/lib/cmake/mlir \
 -DLLVM_DIR=/home/shiran/project/llvm-project/build/lib/cmake/llvm \
 -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_CXX_COMPILER=/home/shiran/bin/g++ \
 -DZLIB_LIBRARY=/usr/lib/x86_64-linux-gnu/libz.so -DZLIB_INCLUDE_DIR=/usr/include \
 -DORBIT_ENABLE_NEURA=OFF -DORBIT_ENABLE_AIR=ON
cmake --build /absolute/new/air --target taskflow-opt -j2
'
```

Do not edit compiler source during a build or relink a binary used by an active
experiment. The final delivery uses immutable copies with sibling Core helpers.
Independent builds need not have identical ELF hashes; compare complete chosen
graphs/plans and the specified behavior instead.

## Full compiler contracts

```sh
bash /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_data_reuse_v21.sh cpu \
 --core-build /absolute/new/core --air-build /absolute/new/air \
 --output /absolute/new/compiler-contracts
```

The entry re-executes in an empty shell environment, runs Core before sourcing
the AIR SDK, then runs combined, AIR and preserved original Amoeba/CGRA/lit
contracts. Its historical `core40` log filename is retained; the result JSON
contains the current test list. The v21 search and constraint units are included.
Additional historical behavior and pure-order checks are independent:

```sh
python3 /home/shiran/project/orbit/test/TaskflowGeneric/data_reuse_search_v20.py \
 --tool /absolute/new/core/tools/taskflow-opt/taskflow-opt \
 --config /home/shiran/project/orbit-artifact/results/taskflow/data-reuse-v20/model-assumptions-r1.json \
 --source /home/shiran/project/orbit/test/TaskflowAIR/fixtures/reuse-interleaved-v20.mlir \
 --source /home/shiran/project/orbit/test/TaskflowAIR/fixtures/reuse-shared-input-v20.mlir \
 --tile-m 12 --tile-n 136 --output /absolute/new/legacy-contracts

python3 /home/shiran/project/orbit/test/TaskflowGeneric/pure_order_reuse_v20.py \
 --tool /absolute/new/core/tools/taskflow-opt/taskflow-opt \
 --air-tool /absolute/new/air/tools/taskflow-opt/taskflow-opt \
 --output /absolute/new/pure-order
```

## Frozen search matrix

`experiment-plan-r3/protocol.json` and `source-and-budget-bindings.json` freeze
the three source programs, unchanged nine-parameter assumed model, target,
initial tiles, four rounds/beam2, common candidate bounds and instance domain.
Keep r1/r2 and the CPU-only deadline pilot. The r3 amendment is an explicit common
complexity bound before planning, not a hardware illegality claim.

```sh
bash /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_data_reuse_v21.sh matrix \
 --core-tool /absolute/new/core/tools/taskflow-opt/taskflow-opt \
 --config /home/shiran/project/orbit-artifact/results/taskflow/data-reuse-v20/model-assumptions-r1.json \
 --protocol /home/shiran/project/orbit-artifact/results/taskflow/data-reuse-v21/experiment-plan-r3/protocol.json \
 --kind evaluation --output /absolute/new/matrix-evaluations
```

Use `--kind catalogue` in a separate fresh directory for six bounded exhaustive
references, and `--kind historical` for the four unmatched legacy controls.
The evaluation matrix has72 runs with literal16/32/64 raw cost-provider calls,
including checker repricing. A score query is not one raw call. Catalogue work is
unpriced and counted separately; all internal planner/checker work is visible.
Historical64-score-query controls are context, not matched-budget evidence.
The supplementary four-round historical series is resource-stopped in this
delivery: one completed run, one incomplete checkpoint, two unstarted runs. Its
~13GB residency/swap observation and commands remain in RESOURCE-STOP.json.
The successful eight original two-round policy/case contracts provide the
historical compatibility control. Do not claim all four extended runs completed.

Run the48 wall-budget conditions serially, after stopping all builds, regression
jobs, other searches, plotting and hardware observation. Use the same command
with `--kind wall --wall-window-confirmed` and a fresh output. Deadlines5/15s
include construction and nonpreemptive work may overshoot; report actual time.
Do not use nonexclusive evaluation-run elapsed times as the wall-controlled test.

Filters `--program`, `--strategy`, `--tile-generator` and `--budget` permit a
small replay. `fresh-matrix-replay-r1` exercises a clean-shell16-call case;
`fresh-matrix-equality-r1.json` compares all24 complete source/mapping/graph
artifacts exactly to its primary pilot. Selection comparison excludes only
elapsed clocks. Raw failed overly strict clock comparison remains preserved.

```sh
/home/shiran/project/aie-toy/.venv/bin/python \
 /home/shiran/project/orbit-artifact/taskflow/scripts/audit_data_reuse_search_v21.py \
 --matrix /absolute/new/matrix-evaluations \
 --matrix /absolute/new/matrix-catalogues \
 --matrix /absolute/new/matrix-historical \
 --matrix /absolute/new/matrix-wall --output /absolute/new/search-audit
```

The audit compares complete plans/graphs without field normalization, separates
actual admitted pools and their completeness, exposes stage exclusions and raw
work, and plots best-so-far against calls/time. The reference optimum is only for
the admitted finite configuration set and the fixed assumed model.

## Actual compile, deduplication and observation freeze

The separate pre-hardware `experiment-plan-r3/hardware-selection.json` selects
the baseline and final winner of every primary condition, plus the bounded
reference winner. Canonical source deduplication precedes actual compilation;
final AIE operation structure deduplicates physical implementations across labels.

```sh
bash /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_data_reuse_v21.sh compile \
 --air-tool /absolute/new/air/tools/taskflow-opt/taskflow-opt \
 --matrix /absolute/new/matrix-evaluations --matrix /absolute/new/matrix-wall \
 --matrix /absolute/new/matrix-catalogues --include-reference \
 --output /absolute/new/compiled-representatives

bash /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_data_reuse_v21.sh freeze \
 --compiled-index /absolute/new/compiled-representatives/unique-implementations.json \
 --protocol /home/shiran/project/orbit-artifact/results/taskflow/data-reuse-v21/experiment-plan-r3/protocol.json \
 --output /absolute/new/observation-freeze
```

Compilation checks actual AIR/AIE and exact full search/compile graph and plan
equality. Freeze submits no device work and binds source, plan, graph, contract,
actual facts, ABI, ELF, observer, generator and installed runtime hashes. At most8
active contexts are used in one batch: one identical baseline control and up to7
alternatives. Baseline repetition across batches is an explicit context control,
not a new algorithm implementation. Pair comparisons only within a batch.

## Locked NPU replay and independent full-array audit

Only the main agent executes device commands. Run one process at a time; the
observer owns `/tmp/npu.lock` and the wrapper adds120s timeout. Do not add an outer
flock, which would deadlock the observer. Execute each batch in two new processes,
reversing program/batch order for the second session. The frozen observer
alternates forward/reverse candidate order for every seed/repeat.

```sh
bash /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_data_reuse_v21.sh npu \
 --protocol /absolute/new/observation-freeze/coupling-batch-0.json \
 --output /absolute/new/coupling-session-1

# Repeat with a different new output for session2.
/home/shiran/project/aie-toy/.venv/bin/python \
 /home/shiran/project/orbit-artifact/taskflow/scripts/audit_data_reuse_v21.py \
 --protocol /absolute/new/observation-freeze/coupling-batch-0.json \
 --session /absolute/new/coupling-session-1 --session /absolute/new/coupling-session-2 \
 --output /absolute/new/coupling-numeric-audit
```

Each protocol uses seeds11/23/47, one warmup plus five retained repeats per seed,
20us polling and unchanged atol=rtol1e-5. Every full input, output, source-rounded
FP32 reference and independent FP64 polynomial reference is saved. The audit
checks identities/events/all array elements and reports full distributions,
paired differences, conditional bootstrap intervals and model sign agreement.
These are prepared host invocation observations, not physical DMA/core timings;
two process sessions do not establish independent-day stable ordering. No v20
held-out data or new device observations are used to fit model coefficients.

For all five batches, retain session names
`npu-<program>-batch-<n>-session-{1,2}` and run the aggregate independent audit:

```sh
/home/shiran/project/aie-toy/.venv/bin/python \
 /home/shiran/project/orbit-artifact/taskflow/scripts/audit_data_reuse_v21.py \
 --manifest /absolute/new/observation-freeze/index.json \
 --sessions-root /absolute/new/session-parent --output /absolute/new/all-batch-audit
```

This aggregates counts/errors only; timing pairs and intervals remain within
each batch/session. Predictions differing by at most1e-12ms are numeric model
ties, excluded from strict sign-ranking statistics. Delivery evidence includes
32 actual implementations,10 new processes,1,224 calls and2,448 complete arrays.
Source bundles separate the preexisting v20 edits, the v21-only diff, and the
latest companion scripts. `DELIVERY.json` binds the accepted artifacts.
