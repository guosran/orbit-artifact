> Publication snapshot of `results/taskflow/data-reuse-v20/REPRODUCE.md`. Relative experiment paths refer to that ignored local result directory. Raw observations, frozen tools and failed attempts remain unchanged locally. The v21 report records the v20 numerical erratum.

# Fresh CPU, compile and small NPU replay

Use new output/build directories. Production is C++/MLIR; Python only prepares
arithmetic inputs, invokes the compiler, verifies evidence and observes hardware.
No command commits or pushes. Preserve historical frozen tools and failed runs.

## Independent current builds

```sh
env -i HOME=/home/shiran PATH=/usr/bin:/bin \
  LLVM_BUILD=/home/shiran/project/llvm-project/build ORBIT_BUILD_JOBS=2 \
  bash /home/shiran/project/orbit/scripts/build-core.sh /absolute/new/core-build

env -i HOME=/home/shiran PATH=/usr/bin:/bin bash --noprofile --norc -c '
cmake -S /home/shiran/project/orbit -B /absolute/new/air-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DMLIR_DIR=/home/shiran/project/llvm-project/build/lib/cmake/mlir \
  -DLLVM_DIR=/home/shiran/project/llvm-project/build/lib/cmake/llvm \
  -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_CXX_COMPILER=/home/shiran/bin/g++ \
  -DZLIB_LIBRARY=/usr/lib/x86_64-linux-gnu/libz.so -DZLIB_INCLUDE_DIR=/usr/include \
  -DORBIT_ENABLE_NEURA=OFF -DORBIT_ENABLE_AIR=ON
cmake --build /absolute/new/air-build --target taskflow-opt -j 2
'
```

The Core script builds all helpers including reuse/shared-input tests and runs
42 groups before loading any runtime SDK. Independent compilation need not
reproduce ELF byte hashes; compare complete source-bound plans/graphs instead.
DELIVERY.json identifies actual current tool snapshots. The original Neura/CGRA
binary is preserved historical evidence, not rebuilt by these commands.

## Full clean CPU/compiler contracts

```sh
env -i HOME=/home/shiran PATH=/usr/bin:/bin bash --noprofile --norc \
 /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_data_reuse_v20.sh cpu \
 /absolute/new/core-build /absolute/new/air-build /absolute/new/cpu-results \
 /home/shiran/project/orbit-artifact/builds/taskflow-v13/amoeba/tools/mlir-amoeba-opt/mlir-amoeba-opt
```

This runs Core42, combined59, actual/old AIR regressions, public Amoeba adapters,
preserved original Neura17/CGRA8, unfiltered executable lit35, and the additional
source-bound noncontinuous pure-order AIR test. Native fixture inputs are
excluded from standalone lit discovery and executed by their real harnesses.
No NPU is opened. Tools must remain immutable throughout the run.

## Clean numerical source → search → actual compile → freeze

```sh
env -i HOME=/home/shiran PATH=/usr/bin:/bin:/usr/sbin:/sbin LANG=C.UTF-8 \
 bash --noprofile --norc \
 /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_data_reuse_v20.sh generate \
 --core-tool /absolute/new/core-build/tools/taskflow-opt/taskflow-opt \
 --air-tool /absolute/new/air-build/tools/taskflow-opt/taskflow-opt \
 --config /home/shiran/project/orbit-artifact/results/taskflow/data-reuse-v20/model-assumptions-r1.json \
 --output /absolute/new/generated-study
```

This prepares both17×136 programs and legal permutations, runs the original
two-round four-policy searches (beam2,budget96,32 joint proposals,4 tile proposals),
checks exact checkpoint resume/target/action-chain rejection and strict unknowns,
selects already checked sources for mechanism coverage, compiles7+3 packages,
checks actual final AIE and exact complete search/compile graph/plan equality,
then freezes two protocols. It submits zero hardware calls. Checkpoint replay
currently repeats proposal planning and can take several minutes.

The full clean replay `fresh-generate-r1/result.json` passes. Its independent
`fresh-generation-equality-r1.json` proves723 exact comparisons with the primary
search, including all complete chosen objects; no graph/plan normalization.
Only archive feedback evidence destination paths are excluded as metadata.

## Small locked hardware replay

Choose either frozen program protocol. The observer owns `/tmp/npu.lock`; run
only one process at a time. Three seeds, one warmup and five retained repeats
per seed execute126 calls for seven-plan interleaved or54 calls for three-plan
shared-input. Every complete output is saved and checked. A120-second timeout
bounds the process. Use new output for another process session.

```sh
env -i HOME=/home/shiran PATH=/usr/bin:/bin:/usr/sbin:/sbin LANG=C.UTF-8 \
 bash --noprofile --norc \
 /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_data_reuse_v20.sh npu \
 --protocol /absolute/new/generated-study/freeze-interleaved-r1/protocol.json \
 --output /absolute/new/npu-session
```

Add `--validate-only` for SHA/contract validation with zero device calls. Do not
edit a frozen protocol to change candidates, timings or polling conditions.
The primary measured protocols are freeze-interleaved-r1,freeze-shared-input-r1
and freeze-pure-order-r1; each has two immutable observed process sessions.
Those observations remain separate from the zero-device fresh generation.

## Independent numerical/timing audit and figures

```sh
/home/shiran/project/aie-toy/.venv/bin/python \
 /home/shiran/project/orbit-artifact/taskflow/scripts/audit_data_reuse_v20.py \
 --protocol /absolute/generated-study/freeze-interleaved-r1/protocol.json \
 --session /absolute/new/npu-session --output /absolute/new/read-only-audit

/home/shiran/project/aie-toy/.venv/bin/python \
 /home/shiran/project/orbit-artifact/taskflow/scripts/plot_data_reuse_v20.py \
 --results /home/shiran/project/orbit-artifact/results/taskflow/data-reuse-v20 \
 --output /absolute/new/figures
```

The audit uses independently written arithmetic equations, checks all array
elements against source-rounded FP32 and unrounded FP64 (atol=rtol1e−5), verifies
artifact identities and event accounting, and reports every retained sample,
distribution and paired comparison without fitting. Host invocation time is not
isolated DMA/core time. Process repetition is not independent-day validation.

## Independent controls

The clean Core run executes16 reuse and25 shared-input checks. Additional actual
tests can be reproduced with existing final-AIE packages:

```sh
python3 /home/shiran/project/orbit/test/TaskflowGeneric/pure_order_reuse_v20.py \
 --tool /absolute/current/core/taskflow-opt --air-tool /absolute/current/air/taskflow-opt \
 --output /absolute/new/pure-order

python3 /home/shiran/project/orbit/test/TaskflowAIR/shared_input_implementation_contract_v20.py \
 --tool /absolute/current/air/taskflow-opt \
 --source /absolute/compiled/source.mlir --plan /absolute/compiled/plan.json \
 --config /absolute/compiled/target.json --aie /absolute/compiled/final-aie.generic.mlir \
 --output /absolute/new/shared-input-negative-controls
```

The latter derives its mutation target from source input roles and actual
multi-phase SSA loads/lock use, with no fixed storage or task selector. Broader
actual-AIE mutation harness is `test/TaskflowAIR/aie_implementation_contract_v19.py`.
Final evidence retains both actual rejected variants and canonical controls.
