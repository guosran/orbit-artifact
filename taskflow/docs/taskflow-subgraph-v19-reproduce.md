> Publication snapshot of `results/taskflow/subgraph-execution-v19/REPRODUCE.md`. Experiment paths below are relative to that ignored local result directory. Frozen reports, raw observations, compiled artifacts and failures remain unchanged locally. See [results](taskflow-subgraph-execution-v19.md), [example](taskflow-subgraph-v19-example.md), and [reproduction](taskflow-subgraph-v19-reproduce.md).

# Clean-shell ORBIT v19 reproduction

Use new output/build directories. Do not rebuild old frozen v15–v18 binaries. No command below pushes or commits. Source is `/home/shiran/project/orbit`; experiment wrappers and results are in `/home/shiran/project/orbit-artifact`. NPU submission is reserved for the main agent and acquires the existing `/tmp/npu.lock` inside the observer.

## Independent Core build

The existing compiler comes from the LLVM cache (this workspace uses `/home/shiran/bin/g++` and `/usr/bin/gcc`). The entry builds all unit helpers and runs the complete Core suite before loading any AIR/Python runtime environment.

```sh
env -i HOME=/home/shiran PATH=/usr/bin:/bin \
  LLVM_BUILD=/home/shiran/project/llvm-project/build ORBIT_BUILD_JOBS=2 \
  bash /home/shiran/project/orbit/scripts/build-core.sh /absolute/new/core-build
```

Final measured-plan bridge uses current Core8173d56e…b828e6 and the forty-group suite. A new build may have a different binary hash; require source/plan checks, not an assertion that independent recompilation reproduces ELF bytes.

## New AIR-enabled optimizer

AIR production planning/lowering is C++/MLIR with the existing LLVM install; this separate build does not enable Neura or modify its preserved compiler.

```sh
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

## Complete CPU/compiler regressions

The clean entry runs Core before sourcing the explicit existing SDK, then current new/old AIR tests, combined current adapters/original search contracts, preserved original Neura/CGRA contracts and unfiltered lit discovery. It performs no builds or NPU submissions. Do not relink a tool while it runs. Use immutable tools; the retained r1 entry failed when a live AIR executable was relinked.

```sh
bash /home/shiran/project/orbit/scripts/run-subgraph-execution-v19-cpu.sh \
  /absolute/new/core-build /absolute/new/air-build /absolute/new/cpu-results \
  /home/shiran/project/orbit-artifact/builds/taskflow-v13/amoeba/tools/mlir-amoeba-opt/mlir-amoeba-opt
```

Final tools/evidence and their exact current-versus-preserved provenance are selected in DELIVERY.json. The final Core/AIR exact eight-case bridges are `final-eight-core-bridge-r1` and `air-final-delivery-r1/eight-plan-bridge`; they compare complete objects without normalization.

## Fresh complete source → search → AIR/AIE → freeze

This clean-shell entry creates both numerical programs, invokes original C++ score-driven two-round search in estimate mode and its strict unknown control, selects already checked mechanistic representatives, compiles all eight, checks actual final AIE in C++, verifies complete search/compile graph and plan equality, and freezes exact predictions/measurement conditions. Python never produces a mapping or score. It does not open the NPU.

```sh
env -i HOME=/home/shiran PATH=/usr/bin:/bin \
  bash --noprofile --norc \
  /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_subgraph_v19.sh generate \
  --core-tool /absolute/new/core-build/tools/taskflow-opt/taskflow-opt \
  --air-tool /absolute/new/air-build/tools/taskflow-opt/taskflow-opt \
  --config /home/shiran/project/orbit-artifact/results/taskflow/subgraph-execution-v19/model-assumptions-r1/estimate-config.json \
  --output /absolute/new/generated-study
```

`fresh-generate-r2/result.json` records a successful eight-case replay. Its actual compiler snapshots remain immutable; final validation-only guards were independently shown to produce exactly the same complete valid eight plans/graphs/AIR. Its protocol was sealed before the two final measurement sessions. It follows an earlier observed seven-plan study and must not be called an entirely untouched holdout.

## Small locked NPU replay

The default frozen entry runs eight quick small programs/plans, three seeds, two warmups and nine retained repeats:264 calls. All complete outputs/references and individual polling/submit/sync events are saved. The wrapper imposes a120-second process timeout. Use a different new output for another process session.

```sh
env -i HOME=/home/shiran PATH=/usr/bin:/bin \
  bash --noprofile --norc \
  /home/shiran/project/orbit-artifact/taskflow/scripts/run_taskflow_subgraph_v19.sh npu \
  --protocol /home/shiran/project/orbit-artifact/results/taskflow/subgraph-execution-v19/fresh-generate-r2/freeze/protocol.json \
  --output /absolute/new/npu-session
```

To run only identity validation, add `--validate-only`; it submits zero calls. To observe your freshly generated artifacts, use `/absolute/new/generated-study/freeze/protocol.json`. Do not edit a frozen protocol to change plans, parameters or polling settings. A new process is cross-session repetition, not independent-day stability. Host completion visibility does not measure isolated DMA/core duration.

## Read-only observation audit and visuals

The audit independently recomputes source-rounded FP32 and unrounded FP64 equations, verifies every saved file and output, pairs equal seed/repeat inputs, and reports distributions and all-pair uncertainty without fitting.

```sh
/home/shiran/project/aie-toy/.venv/bin/python \
  /home/shiran/project/orbit-artifact/taskflow/scripts/audit_subgraph_observations_v19.py \
  --protocol /absolute/generated-study/freeze/protocol.json \
  --session /absolute/new/session1 --session /absolute/new/session2 \
  --output /absolute/new/read-only-audit

/home/shiran/project/aie-toy/.venv/bin/python \
  /home/shiran/project/orbit-artifact/taskflow/scripts/visualize_subgraph_execution_v19.py \
  --index /absolute/generated-study/compiled/index.json \
  --output /absolute/new/visualizations
```

C++ generic actual checks can also be called directly: `taskflow-opt SOURCE --target-config=CONFIG --check-air=GENERIC_AIR` or `--check-aie=GENERIC_FINAL_AIE --implementation-output=RECEIPT --implementation-facts-output=FACTS`. Use the installed `air-opt FINAL_AIE --mlir-print-op-generic` to obtain the generic final-AIE syntax. Mutation harnesses are `test/TaskflowAIR/implementation_contract_v19.py` and `aie_implementation_contract_v19.py`; they do not certify unsupported historical lowering paths.
