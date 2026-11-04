# FFN host profiling and control audit v9

Final integrated outcomes, optimized full M1/M5/M8 and M128 execution, exact
search feedback and reproduction are in [the v9 report](taskflow-ffn-profiling-v9.md).
The sections below preserve earlier acquisition boundaries and failed attempts;
an earlier snapshot's status is not the final status of a separately identified
later implementation.

This report separates complete-program numerical acceptance, independently compiled stage diagnostics, host API observations and static generated-code facts. It does not treat host waits as device cycles or packet fragments as complete kernel traces. Current independent reports are in `.work/profiling-v9-audit/r6`; earlier attempts and the failing four-input batch remain visible. Evidence is under `results/taskflow/ffn-profiling-v9`; independent derived audits are under `.work/profiling-v9-audit/`.

`test/TaskflowAIR/audit_profile_v9.py` reads every saved profiling output and supplied reference NPZ rather than trusting recorded `passed` flags. It requires finite FP32 outputs and the original `atol=rtol=1e-5`, reports maximum absolute error, relative error where reference magnitude is at least1e-6, near-zero absolute error and normalized L2, and checks output/input/reference/source/ELF identities. Numerical success alone does not establish target/model applicability or permission to train on holdout cases.

## FFN measurements

The M1/M5/M8 measurements each use one input seed, one warmup and two hot repeats. They are profiling diagnostics/training observations, not new three-seed numerical acceptance. Gate, Up, activation and Down are independent complete-main programs. Their timings cannot be presented as per-stage timers from the full ELF.

| M | Gate ms | Up ms | Activation ms | Down ms | Full ms | Median paired sum(stages)−full ms |
|---|---:|---:|---:|---:|---:|---:|
| 1 |1540.663821|1539.462190|12.097402|1539.233995|4628.897661|2.559746|
| 5 |7655.155442|7654.990806|56.862144|7654.204330|23017.667288|3.545434|
| 8 |12086.535452|12085.711881|92.815377|12086.386891|36345.459875|5.989725|

The table reports hot host-wall medians. JSON audits retain each repeat's wait, BO/map/staging/sync/start, host output-copy and unseparated residual spans. A sum of independently loaded stage programs has different contexts, array preparation and firmware boundaries from the full program; the small differences above are not an isolated fusion or reconfiguration cost.

For a full FFN, the arithmetic count is `MAC=3*M*2048*11008`, `FLOPs=2*MAC`, excluding activation arithmetic. Full M8 therefore has541065216 MACs /1082130432 counted FLOPs, giving0.0297735 GFLOP/s on the observed complete-run wall boundary. This is not peak hardware throughput. Existing scalar code-generation evidence and approximately linear M scaling are consistent with large scalar work; these host measurements do not independently exclude DMA or firmware stalls.

The current full-M8 ELF and the original accepted M128 template are byte-identical:

`43cf768bb42cbe8fcec0166efbfc8b7f80640988a9f74a03694da369183dc71b`.

AIR metadata/source hashes can differ; original records are not rewritten. The original M128 three-seed independent numerical audit is reused with its SHA and source IDs. Its48 completed M8 calls have median36.345722s and range36.334197–36.412345s. Whole-program walls are581.584170 /581.617079 /581.599105s. The full wall additionally includes per-call checkpoint/parts serialization and assembly. Original wait timing starts before its wait-in-progress JSON write, so it includes that I/O as well as runtime/device waiting. Context load, final full-output serialization and numerical checking remain outside the original program wall. This is historical acceptance of three complete Y[128,2048] outputs, not another new M128 run.

## Residency comparison and observer controls

Both complete GEMM→scale candidates pass all independently checked raw outputs. Each observer mode has three seeds, two warmups and ten hot repeats per candidate (30 hot samples each), alternating forward/reverse candidate order.

| Observer | Phase-local median/mean ms | Retained median/mean ms | Median paired retained−local ms |
|---|---:|---:|---:|
| detailed |18.719868 /18.706904|18.641660 /18.694526|−0.013870|
| minimal |18.686514 /18.705353|18.658470 /18.686701|−0.000460|

Detailed paired differences span−0.651195..+0.729162ms; minimal differences span−0.699692..+0.438638ms. Separate detailed/minimal sessions are not a randomized matched observer experiment: their median differences cannot be subtracted as exact observer cost. Both modes execute the same runner algorithm and arguments. The detailed mode wraps host APIs and the installed runner's `numpy.copyto` staging, and reports only partially measurable observer bookkeeping plus CPU noop calibration.

Native and downstream static audits show two versus five compute stages, each complete program still using one XRT start/wait. Static DMA bytes decrease221184→122880, B bytes131072→32768; peak payload increases3584→9728 bytes, plus the separate4096-byte stack. These are generated-program facts, not physical DDR counters. No per-stage timestamps isolate the added stages' configuration cost. There is no demonstrated residency speedup or timing-equivalence result.

`device-before.json` reports power mode `Default`; no per-sample locked frequency is established. Its electrical query fails `DRM_IOCTL_AMDXDNA_GET_INFO` with `err=-22`. No energy or power estimate is inferred from that failed interface.

## Failed controls and trace limits

The original four-input controls batch preserves a real numerical failure: grouped M32×64 add and mul have144 failed output checks (both Y/Z, all three seeds and12 repeats). Split controls pass. The source already had one shared i/j nest with four loads, two operations and two stores; a previous multi-nest explanation was incorrect. Timing from failed candidates must not enter fitting. The new packed-two-input batch uses identity-rank3 A/B[M,N,2], preserves the original values in lanes, and independently passes all576 output checks from288 runs (three seeds, twelve repeats, eight training candidates). Its source/plan/ELF identities are separate. This validates that batch numerically; it does not validate the failed four-input backend path or establish a fitted cost model. Original controls and measurements remain unchanged.

`packet-trace-marked-r1` is `numeric_failed`; its marker-order audit also fails. Its finite packet window is not a valid total-kernel attribution. Those diagnostics remain preserved and are excluded from the summaries above. There is no device trace underlying the profiler's Perfetto file: that file is explicitly a host-only timeline.



The later `packet-trace-marked-r2` has14 independently rechecked correct outputs and one ordered marker pair: EVENT0 begins at1263 and EVENT1 at125472 device cycles, bracketing124209 cycles for one instrumented1×64×16 GEMM on one core. Saved physical MLIR contains one `aie.event(0)` after initializer/input acquire operations and one `aie.event(1)` before output releases. The decoded window contains1024 paired `INSTR_VECTOR` intervals. These event counts are not a FLOP counter or a semantic proof.

Across the trace, lock-acquire events have three begin/end pairs: one coincides with EVENT0 at1263, two follow EVENT1; lock-release events have three pairs after EVENT1. The raw262144-word buffer has1776 nonzero words, from indices32768 through34543, followed by227600 zero words. Observed vector pairs lie within the bracket, and post-bracket releases/port events are present. The `TRUE` event remains open. No overflow counter or calibrated physical clock is available: unused/zero suffix is not proof that no events were lost. This supports only the explicitly bounded single-core GEMM interval, not an entire trace window, whole-device activity or any FFN cycle extrapolation.

The generic trace manifest's claim that the kernel emits no markers is stale for this instrumented derivative. The saved physical MLIR and decoded pair establish their presence; a separate derived audit records that correction without rewriting original metadata. The host profiler's Perfetto timeline remains host-only and is distinct from this packet-derived device-cycle view.

The newest profiler separately records input/reference copy/load, numerical checking, output NPZ save, sample/checkpoint serialization, progress printing, context load/unload and complete profiling-loop wall. Earlier baseline snapshots lack some of these timers; absent values remain unseparated rather than reconstructed. Final evidence-summary/trace/boundary writes are explicitly excluded to avoid recursively claiming complete measurement of their own serialization.

## Recheck

From the artifact `taskflow` directory with the existing NumPy environment:

```sh
python test/TaskflowAIR/audit_profile_v9.py \
  --root ../results/taskflow/ffn-profiling-v9 \
  --original-m128 ../results/taskflow/orbit-direct-air-v7/ffn-m128-partition-long-r1 \
  --output ../.work/profiling-v9-audit/NEW
```

The combined audit intentionally exits unsuccessfully when it includes the failed controls batch. Per-profile and per-candidate validity are retained; no global `passed` label hides those failures. No audit command compiles or submits device work.


## Independent joint-candidate group

`profile-joint-search-scalar-r1` is audited separately in `.work/profiling-v9-audit/r8`: eight complete GEMM→scale candidates, three seeds, two warmups and ten hot repeats, all288 raw Y outputs pass the unchanged FP32 contract. No expected-failure controls or mixed candidate are included in this group.

| Candidate prefix | M/N/K tile | Static DMA B | Compute stages | Peak payload B | Hot median ms | Hot mean ms |
|---|---|---:|---:|---:|---:|---:|
|0b83a6b3281c|8/64/32|172032|2|11264|18.718113|18.750734|
|61b3be686117|8/32/32|188416|2|6144|18.789531|18.735073|
|31ae56c82f10|8/16/32|221184|2|3584|18.760066|19.075033|
|cfab1bf2d5f0|8/64/32|172032|5|14336|18.783356|18.840378|
|3ad710d336c2|8/32/32|172032|5|9216|18.963102|18.918866|
|ca55414a6395|8/16/32|172032|5|6656|18.920412|18.902319|
|12163856b232|8/32/32|90112|3|18432|18.516967|18.563836|
|b62184f48e26|8/16/32|122880|5|9728|18.555081|18.617522|

The proposal source bytes equal each candidate ID and the compiled source bytes. Compiled AIR hashes match actual aircc input identities and retain their compiled mapping-plan and source-fingerprint attributes. Compiled/proposal native plans are fully equal after removing only the top-level plan identity and direct cost metadata; they do not share the new execution-key field, and the audit does not claim that the newer provider performed these past executions. The independent observed-feedback descriptor binds this semantic bridge explicitly.

All eight generated runtime DMA audits were rerun offline and exactly reproduce their original reports. Independent physical-payload checks match each planned stage, with zero extra payload and maximum18432 bytes under the unchanged24576-byte budget;4096-byte stacks are separate. These physical reports were newly saved after execution because no original storage report was present at the package root; their chronology is not relabeled as a saved pre-device gate. Static DMA bytes are not measured DDR traffic.

This group records the actual selected `_wait_polling` callable, its module/qualified name and source SHA in `wait-backend.json`. Its feedback target separately binds that choice, the detailed observer and profiler SHA, runner SHA and saved toolchain versions. It does not reuse the older composite model's unknown-wait context. Candidate31ae retains its30.007218ms hot outlier; the mean/median difference is reported, without deleting it. These close measured medians do not establish statistical significance or a causal speedup from fewer bytes/stages.

## Fresh staged reproduction

The new `scripts/run_taskflow_ffn_profiling_v9.sh` creates its build and experiment outputs under a new directory. It does not use the historical measurements or frozen binaries above as defaults. From the companion `taskflow` directory, with the existing LLVM/AIE environment available:

```sh
bash scripts/run_taskflow_ffn_profiling_v9.sh cpu /absolute/NEW_CPU_DIRECTORY
bash scripts/run_taskflow_ffn_profiling_v9.sh all /absolute/NEW_COMPLETE_DIRECTORY
```

`ORBIT_SRC`, `LLVM_BUILD`, `AIE_TOY_ROOT` and `ORBIT_TEST_PYTHON` select existing dependencies. `ORBIT_BUILD_ROOT` defaults to `NEW_DIRECTORY/build`; an explicit override selects another build location. `scope.json` separates completed-work booleans from `planned_pipeline`: CPU-only output has `model_fit=false` and `holdout_execution=false`; late phases do not claim prior phases ran in their new directory. The CPU entry includes the existing v8 regressions, profiler/fitter/workflow CPU tests, an explicit build of all six Core checker binaries, and the standard Core/Amoeba/AIR regression driver. That driver includes the direct-AIR cost checker using the Core `test/TaskflowGeneric/add.mlir` fixture, mixed FP32 and stream-capacity regressions. CPU mode does not submit device work.

The complete workflow prepares M1/M3/M5/M8 Gate, Up, activation, Down and complete FFN mains at D2048/I11008, plus the twelve packed-two-input controls. Native lowering and aircc compile each case; runtime-transfer and physical-payload audits must pass. `baseline/mX/STAGE` holds each compiled package, `inputs/mX/STAGE` holds its three seed pairs, and `frozen-tools/taskflow-opt` is copied from this fresh build. Only explicitly named fixture inputs `W_*` are declared static within a seed/context; other inputs are staged on every call. This reuses system BOs and does not claim AIE SRAM retention.

Training runs M1/M5/M8 with seed11, one warmup and two hot repeats per stage, and packed training controls with three seeds, two warmups and ten hot repeats. The independent audit rereads every raw output/reference with the unchanged FP32 tolerance. `taskflow_ffn_workflow_v9.py` then invokes the frozen native compiler for feature-only plans. It checks complete plan equality after removing only the top-level identity and cost metadata; it never implements mapping or a production cost formula. Static held-out features establish the predeclared feature domain without timing labels. The fresh manifest records every native integer feature as a per-source minimum/maximum range, including tile-loop extents, stage/resource counts, serial mode, DMA and payload; a source measured in one configuration has exact ranges. Implementation identity remains a separate domain whitelist. This validates the declared configurations and does not extend the fitted model to arbitrary tiles. Held-out timing labels are neither bound nor read for fitting.

The existing fitter consumes `native-features/training-manifest.json`. `frozen-model/freeze.json` binds the model, fit report, fitter/orchestrator, native tool, training evidence, compiled programs, held-out case lists and split declaration. Each package invocation must name the same native compiler SHA as the frozen feature tool, with its actual binary verified; native flags/config hashes and normalized aircc flags are part of the calibration target identity. The M3 and 17×80 controls run only after this barrier. Before and after held-out execution, identities must still match. Held-out independent audits and scoring additionally require the selected wait backend, profiler/runner identity, observer context and each audited ELF to match the frozen selection. Numerical failures and prediction errors remain separate; scoring never refits.

Each step can instead be run in a separate new directory:

```sh
bash scripts/run_taskflow_ffn_profiling_v9.sh all /absolute/NEW_TRAIN --phase training
bash scripts/run_taskflow_ffn_profiling_v9.sh all /absolute/NEW_COLLECT --phase collect --previous /absolute/NEW_TRAIN
bash scripts/run_taskflow_ffn_profiling_v9.sh all /absolute/NEW_FREEZE --phase freeze --previous /absolute/NEW_COLLECT
bash scripts/run_taskflow_ffn_profiling_v9.sh all /absolute/NEW_HOLDOUT --phase holdout --previous /absolute/NEW_FREEZE
bash scripts/run_taskflow_ffn_profiling_v9.sh all /absolute/NEW_AUDIT --phase audit --previous /absolute/NEW_HOLDOUT
```

Late phases do not rebuild. `workflow-state.json` identifies the package, collection, frozen model and held-out run; `phase-history/` preserves each completed transition. Final outputs include `holdout-independent-audit/` and `holdout-score/holdout-score.json`, with model and evidence hashes, frozen predictions, observed medians and signed errors. The optimization/search workflow is a separate entry owned by the main agent.

The wrapper itself has only been syntax/dependency checked by this validation agent. CPU-only protocol evidence is `.work/ffn-profiling-preflight/workflow-mock-r7/summary.json`: twelve checks pass, including native compiler/flag binding, per-source guard propagation, mutation, pre-freeze label, mismatched runtime and mismatched ELF rejection. CPU scope-block checks pass in `workflow-scope-r2/summary.json`. The mock emits explicitly supplied synthetic native-plan JSON and runs the existing fitter on synthetic labels; it imports no runtime and executes no compiler or device. This does not claim that the fresh end-to-end hardware entry has already run. Historical measurements and failed attempts above retain their original identities.
