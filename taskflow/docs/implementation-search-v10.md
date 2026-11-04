# Implementation-aware whole-program search experiment v10

The experiment evaluates complete GEMM→scale programs. Original C++ search owns
automatic proposals, materialized source transformations, legality, resource and
transfer plans, exploration, prediction and beam selection. Companion Python
prepares numerical fixtures, freezes experiment parameters and reports independent
validation. No model is trained for CGRA, and no existing v9 model or raw result
is overwritten.

The completed hardware experiment has 474 independently checked outputs:
252 training, 126 holdout, 84 native-selected/control/exploration and 12 complete
M5 FFN outputs. The frozen four-term model has 1.6304% holdout MAPE (maximum
5.4624%). Original search selects and executes a new `[4,32,64]` mixed8 plan,
outside both the training set and the old four measured configurations. Its
prediction is tied with the implementation/residency control; measurements do
not establish a joint-search gain over that control. The lifted FFN plan is
correct but about 0.96% slower than its baseline. Correct execution, model
validation and performance benefit are reported separately.

The prerequisite public memory architecture reuses ORBIT's resource/memory/link
types, adding ownership domains and precise accessibility. Copy allocation,
directed communication and capacity checks consume target instances even when
cost parameters are unknown. Synthetic shared/local SRAM planning covers
multi-hop paths; direct AIR currently binds one local payload pool and two DMA
links. Taskflow retains computation; the public mapping owns data/version/copy,
event and region choices; AIR owns memory spaces, channels and tokens. The
24,576 B policy is a logical tensor payload budget, distinct from BO allocations,
physical bank topology and the separate 4,096 B stack. One program call shares
one host submission across its input dependencies. See the Core
`docs/taskflow-memory-architecture-v10.md` and
`docs/taskflow-implementation-search-v10-validation.md` contracts.

## Predeclared comparison

All programs have A[M,K], B[K,N] inputs and Y[M,N] output. References compute the
GEMM and scale 0.5 in float64 and cast the final Y to FP32. Acceptance remains
finite FP32 `atol=rtol=1e-5`. Inputs A and B are staged every call; temporary ABI
buffers are scratch; outputs are never static. There is no special weight class
or implied on-chip retention in this invocation policy.

| Split | Program M/K/N | Tile M/N/K | Implementations | Data organization | Cells |
|---|---|---|---|---|---:|
| Train |16/128/64,32/128/64|8/16/32|scalar, mixed8|phase-local, B-panel|8|
| Train |32/128/64|8/32/32|scalar, mixed8|phase-local, B-panel|4|
| Holdout |32/128/64|4/16/64|scalar, mixed8|phase-local, B-panel|4|
| Holdout |17/129/80|8/32/32|scalar, mixed8|phase-local|2|
| Negative |32/128/64|8/64/32|mixed8|B-panel|1|

Each legal cell uses seeds11/23/47, two warmups and five hot repeats in the
existing profiler's alternating forward/reverse order. Negative requests have no
latency label. The native generator must produce the cells: experimental
coordinates never become a manually supplied production candidate list or
hand-edited MLIR. Missing or ambiguous native coverage stops the workflow.

The source declaration is `test/TaskflowAIR/implementation_matrix_v10.json`.
Local prepared inputs are under
`results/taskflow/implementation-search-v10/preregistered-inputs-r6/`.
All amendments precede hardware timing labels. r1 preserved an initial explicit
proposal-list policy; r2 switched to the original automatic joint generator;
r3 raised finite depth/beam/evaluation budgets because the M/N/K changes plus
implementation and panel require at least five actions. r4 added general
proposal preferences M4/N8/K16 after a CPU probe was bounded at329s and about12.9GB
RSS. These are search preferences, not new hardware hard limits. r5 preregistered
the three model comparisons below. r6 changes only the four M32 configuration holdouts from tile4/32/64 to
tile4/16/64 because the finite native beam did not reach the original cells,
while the original automatic archive independently produced each replacement
exactly once. This is an unmeasured M/K tiling combination within the same source
family, not an unseen-family test. No timing labels informed this change; all
twelve training cells, two shape/tail holdouts, the negative, numerical inputs,
model protocol and search budgets are unchanged. The failed final-r1/r2 coverage
results remain preserved, and the coordinator reruns the full original helper
under the final binary to bind r6. Each amendment keeps old files and records
unchanged source/input/reference hashes. Initial legal-unknown classification
was incorrect and its failed attempt remains preserved; the corrected collector
accepts only checked native uncalibrated plans with null price, then materializes
features through the native tool.

## Three frozen models

The primary implementation-aware empirical composite has exactly four terms:
command count, implemented scalar FP32 product operations, implemented mixed8
FP32 product operations, and hardware stage count. Product counts come from
native actual task implementations; Python does not infer them from tensor
shapes. A second independent NNLS fit uses only the first three terms and emits
a four-term model with stage coefficient exactly zero, explicitly marked as an
ablation. Both use the preregistered relative-residual objective with a1ms floor,
nonnegative coefficients and no extra hidden intercept.

The third comparator is the original C++ theoretical sensitivity provider with
its original v9 coefficients: launch0.1ms, source scalar operation1e-6ms and
explicit transfer byte1e-7ms. It is uncalibrated; it is not a new fitted model.
Its static boundary omissions remain explicit when comparing its numerical
estimates with observed host-wall medians.

The realized training matrix has rank4 and scaled condition10.0643. Frozen
nonnegative coefficients in milliseconds are command0.7464502093,
scalar-product6.707968339e-5, mixed8-product6.189361104e-5 and
stage0.03791428865. These are correlated prepared-call composite coefficients,
not isolated physical component delays. Every training command count is one,
so its coefficient functions as an intercept. Parameters remain unchanged after
all validation measurements.

| Frozen provider | Six-holdout MAPE | Maximum error |
| --- | ---: | ---: |
| Implementation/stage four-term |1.6304%|5.4624%|
| Implementation three-term |2.6846%|8.6393%|
| Uncalibrated theoretical baseline |96.4006%|96.6354%|

Four-term predicted and measured-median minimizers agree in both program groups
(zero descriptive regret within those finite sets). One of seven within-program
pair orderings reverses. Three-term phase/panel ties have M32 regret range
0–0.0543%; theoretical scalar/mixed ties give M32 range0.0543–7.2748% and tail
range0–11.1575%. Near-tied phase/panel timing has both paired signs. No stable
retention speedup or global search optimum is inferred. The tail's15stages
extrapolate beyond training2/3/5stages; predeclared static-domain acceptance does
not mean training coverage. Complete FFN includes exp/div and another family,
and remains outside this model.

Before collecting any labels, the column-scaled training feature matrix must
have rank4 and condition number at most1e6. The three-term submatrix must also
have rank3 at fitting. The new implementation-composite domain copies native
shape-erased SSA/access family and architecture fingerprints, implementation and
operation whitelists, all integer feature envelopes and the predeclared tail
policy. Native scope is affine unit-step FP32 mul/add/sub with exact mixed8 lane
coverage. Source SHA is preserved as artifact provenance, but is not the new
provider's generalization gate. Family, architecture and feature applicability
checks belong to the original C++ provider; unsupported costs remain null.

Only training results are opened by the fitter. Its training-manifest digest
binds actual raw profile results, independent audit, invocation/case list,
preparation policy and static design. Both fitted models and the unchanged
legacy configuration are frozen before any heldout execution. The reserved
heldout path must not exist at fitting/prediction time. All three heldout
predictions are generated by the native compiler and frozen before measurement.
No heldout coefficient adjustment or refit is performed.

The v10 reusable runtime identity preserves runner/profiler/actually selected
wait backend and the BO role policy, seed/warm/hot counts and observer. It omits
case names, concrete ABI shapes and number of candidates from the canonical
policy so that the declared train/holdout configurations can be compared.
Exact per-case ABI/preparation/call histories remain separate bound evidence.
Actual heldout runtime is checked against the frozen target after execution;
a mismatch makes predictions ineligible. This does not attest physical device
serial, locked clocks, temperature, cache state or electrical power. Host waits
include runtime waiting, device computation, DMA and stalls; they are not kernel
hardware timestamps.

## Native search and independent validation

Predeclared-cell holdout validation is separate from production candidate
selection. After freezing, `predictive-search` invokes the original C++
`--search` automatic joint generator with the four-term model and fixed four
unknown exploration slots. Its native archive and selected parent/child history
are retained. Python never reorders that archive as a production beam. The main
coordinator compiles and measures the first eligible native-ranked new candidate
outside the old v9 four-cell table, preserving its selection rationale and
measurement identity. The delivered `all` entry includes separate selection,
hardware and independent audit phases described below.

The independent v10 auditor reruns the existing raw-output/reference audit and
checks the frozen ELF/ABI/native prediction identities and runtime policy. It
reports maximum absolute/relative-floor/near-zero/L2 numerical metrics through
the raw audit, prediction errors for all three models, within-program descriptive
pairwise order reversals, aligned hot-repeat differences and selection regret
against the observed median minimum. Prediction ties remain ties with a regret
range. These point estimates do not establish statistical significance or a
causal performance gain. A numerical success and a performance-model miss are
separate outcomes.

No v9 measured timing labels are default training inputs. The legacy theoretical
coefficients are reused as an explicitly identified comparator, not as measured
labels. Any future reuse of v9 observations needs its own raw artifact hashes and
timing/runtime/observer/preparation context, with heterogeneous conditions
reported rather than pooled silently.

## Reproduction

From the companion `taskflow` directory:

```sh
bash scripts/run_taskflow_implementation_search_v10.sh cpu /absolute/NEW_CPU
# Only the NPU coordinator runs all:
bash scripts/run_taskflow_implementation_search_v10.sh all /absolute/NEW_EXPERIMENT
```

The new build defaults to `NEW_DIRECTORY/build`; ORBIT_SRC, LLVM_BUILD,
AIE_TOY_ROOT, ORBIT_TEST_PYTHON and ORBIT_BUILD_ROOT can select explicit existing
dependencies/build locations. No historical result, old frozen tool or fitted
model is an implicit input. CPU mode includes existing Core/Amoeba/AIR and CGRA
contracts plus v10 synthetic protocol tests. All mode follows preparation →
native proposals → static design gate → compilation/audits → train →
independent raw audit → fit/freeze → native heldout predictions and automatic
predictive search → restricted search controls → native novel/unpriced selection
→ selected compilation/execution/audit → representative full-M5 FFN comparison
→ heldout → independent three-model validation. The FFN comparison adds several
minutes of device execution and substantial fixture preparation. Each failed
stage retains its new output directory and stops dependent work. The delivered
coordinator run used these phases individually; it is not a second monolithic
`all` hardware execution claim.

Individual CLI stages are available for coordinator-controlled execution:

```sh
python scripts/taskflow_implementation_search_v10.py propose --prepared PREPARED --tool FINAL_TOOL --output NEW_PROPOSALS
python scripts/fit_implementation_cost_v10.py design --proposals NEW_PROPOSALS --output NEW_DESIGN
python scripts/taskflow_implementation_search_v10.py compile --proposals NEW_PROPOSALS --jobs 2 --output NEW_COMPILED
python scripts/taskflow_implementation_experiment_v10.py profile --design NEW_DESIGN --compiled NEW_COMPILED --split train --output NEW_TRAIN
python scripts/fit_implementation_cost_v10.py fit --design NEW_DESIGN --compiled NEW_COMPILED --profile NEW_TRAIN/profile-train --audit NEW_TRAIN/independent-audit/profile-train.json --holdout-profile NEW_HOLDOUT/profile-holdout --output NEW_FROZEN
python scripts/taskflow_implementation_experiment_v10.py predict --frozen NEW_FROZEN --output NEW_PREDICTIONS
python scripts/taskflow_implementation_experiment_v10.py predictive-search --predictions NEW_PREDICTIONS/prediction-freeze.json --output NEW_SEARCH
python scripts/taskflow_implementation_experiment_v10.py profile --design NEW_DESIGN --compiled NEW_COMPILED --split holdout --frozen NEW_FROZEN --predictions NEW_PREDICTIONS/prediction-freeze.json --output NEW_HOLDOUT
python test/TaskflowAIR/audit_implementation_search_v10.py --frozen NEW_FROZEN --predictions NEW_PREDICTIONS/prediction-freeze.json --profile NEW_HOLDOUT/profile-holdout --output NEW_VALIDATION
```

Compilation defaults to one independent wrapper process; `--jobs2/4` bounds
parallel compilation into distinct directories. Installed aircc uses each
working directory's `air_project` and unique temporary stdout/stderr files;
compile-only returns before XRT submission. This run compiled eighteen packages
with two workers into separate directories. NPU execution stays
serial under the existing lock.

CPU evidence remains separate from hardware calibration: protocol tests validate
references and pre-registration failures; fitter tests use synthetic native
facts/labels; policy tests and mocks validate orchestration without submitting
work. Real coverage, timings and numerical results bind the actual frozen
compiler, architecture, runtime and ELF identities listed below.

### Native selection through hardware handoff

The coordinator has three additional, separate phases. `select` follows the original C++ search's `ranking` array without sorting or changing tied predictions. The first calibrated `model_prediction` outside the twelve frozen training configurations and the four delivered v9 measured semantic configurations is selected. Exclusion compares checked native semantic coordinates and execution fingerprints; a compiler-version change alone does not establish novelty. The delivered exclusions are in `test/TaskflowAIR/fixtures/implementation_prior_exclusions_v10.json`, with their original evidence hashes.

```bash
python taskflow/scripts/taskflow_implementation_experiment_v10.py select \
  --search "$NEW/predictive-search" --frozen "$NEW/frozen-model" \
  --control "$NEW/search-controls/tiling-only" \
  --control "$NEW/search-controls/implementation-residency" \
  --exploration-budget 1 --output "$NEW/selected"
python taskflow/scripts/taskflow_implementation_experiment_v10.py compile-selected \
  --selection "$NEW/selected" --output "$NEW/selected-compiled" --jobs 2
python taskflow/scripts/taskflow_implementation_experiment_v10.py prepare-selected-profile \
  --selection "$NEW/selected" --compiled "$NEW/selected-compiled" \
  --output "$NEW/selected-profile"
```

The two controls retain their own first calibrated native rank, even when previously trained. Their search ceilings are the same; actual evaluations can differ, so this is not an equal-work claim. The optional hardware exploration budget is restricted to zero or one. Budget one selects the first legal uncalibrated entry in the original joint archive order, excluding training, historical, and already selected configurations. Its score remains null, its native calibration rejection is retained, and it is explicitly separate from the model-ranked winner. No Python cost estimation or production search ranking is introduced.

`selection-freeze.json` binds the native search, chosen source, full native plan, configuration, prediction, action/parent chain, exclusions, and decisions. `compile-selected` reuses the existing compiler wrapper and all compile/runtime-transfer/storage identity gates. `prepare-selected-profile` only prepares the existing frozen profiler, complete inputs/references, ABI roles, and the original timing policy; it does not submit NPU work. The coordinator executes the generated JSON argument array in `profile-command.json`, then independently audits `profile-selected` with `audit_profile_v9.py`. Inputs are staged each call, temporary BOs follow ABI roles, and outputs are read back. Three seeds and the declared two warmups/five hot calls use the existing alternating forward/reverse candidate order. This is a whole prepared-command comparison, not a device-cycle measurement. Tied model predictions alone do not establish a measured benefit.

The CPU-only selection regression is reproducible with:

```bash
python taskflow/test/TaskflowAIR/implementation_closure_v10.py --output "$NEW/closure-cpu"
```

It checks native order, training/history exclusions, controls, unknown separation, the zero/one budget, and source/price/selection-artifact tampering without compiler or device execution.

The selected-search independent validation entry is:

```bash
python taskflow/test/TaskflowAIR/audit_selected_implementation_v10.py \
  --selection "$NEW/selected" --compiled "$NEW/selected-compiled" \
  --profile "$NEW/selected-profile/profile-selected" \
  --output "$NEW/selected-independent-validation"
```

This reads every saved output against its independent reference with unchanged finite FP32 `atol=rtol=1e-5`, rechecks selection against original native order, and verifies compiled source/plan/AIR/ELF/ABI identities and actual runtime policy. It reruns final storage and runtime-transfer audits; channel-port checks are applied only when the checked plan requires them. The report includes calibrated prediction errors, preserved prediction ties and descriptive regret, plus paired hot-call differences for all cases. The uncalibrated exploration remains explicitly unpriced even after it acquires a measured result. No model parameters are updated.

### Independent measured closure

The actual native selection and its two search controls, plus one explicitly unpriced exploration, were independently re-audited in `results/taskflow/implementation-search-v10/native-selected-validation-final-r1/validation.json`. All 84 saved outputs passed the original finite FP32 tolerance (three seeds, two warmups and five hot calls, four cases); maximum absolute error was `7.152557373046875e-7`. The audit also rechecked native order/exclusions, source/plan/AIR/ELF/ABI/runtime identity, final physical allocation and runtime-transfer evidence. The installed runner actually selected `_wait_polling`, as recorded after waits; this is not inferred from its configured interval.

| Native selection | Tiles M/N/K | Hot median ms (15 calls) | Hot range ms | Predicted ms | Native DMA bytes / stages / local payload bytes |
| --- | --- | ---: | --- | ---: | --- |
| Joint, new mixed8 phase-local configuration | 4/32/64 | 17.068420 | 16.867534–17.938807 | 17.174076 | 319488 / 2 / 9728 |
| Tiling-only control, scalar phase-local | 8/16/32 | 18.627799 | 18.338366–18.906152 | 18.544195 | 221184 / 2 / 3584 |
| Implementation/residency control, mixed8 phase-local | 8/16/32 | 17.269644 | 16.875344–17.494288 | 17.174076 | 221184 / 2 / 3584 |
| Budget-one unpriced exploration, scalar phase-local | 8/8/32 | 18.462234 | 18.077374–18.909232 | null | 286720 / 2 / 2304 |

The joint and implementation/residency control predictions are exactly tied. Their matched hot-call difference (control minus joint) has median `0.034479 ms`, mean `0.020277 ms`, and range `[-0.803499, 0.605125] ms`; these results do not establish a joint-search gain over that control. Tiling-only minus joint was positive in all fifteen matched calls, with paired median `1.415183 ms`; exploration minus joint likewise had paired median `1.275557 ms`. These are descriptive observations, without a significance or causal claim. The three calibrated predictions had MAPE `0.540406%`, maximum absolute relative error `0.619013%`, and no strict pairwise order reversal; the tied minimizers have descriptive regret range `[0, 1.178926]%`. The unknown entry remains unpriced rather than retrospectively becoming a model prediction. Actual native evaluations were 224 joint, 56 tiling-only and 6 implementation/residency, under the same ceilings rather than equal actual work.

A separate full M5 SwiGLU transfer diagnostic was independently re-audited in `.work/implementation-search-v10/representative-ffn-independent-review-r1`. All twelve outputs passed, with maximum absolute error `2.421438694e-8`. Three hot complete-program medians were `21.214368 s` baseline and `21.418708 s` lifted. Native DMA bytes increased `292809728 → 584477696`, stages `4 → 8`, and peak local payload decreased `18944 → 9728` bytes. This diagnostic shows a resource/transfer tradeoff and no observed speedup; it is not a calibrated prediction for the complete FFN, whose activation operations lie outside this short arithmetic model's domain.

## Versions, physical audit and retained failures

The actual execution source base is Core `612bf40ed37d15fbb405ecf7db553c79ce7f8430`
plus the saved v10 source snapshot; the artifact base is
`40427ffa3482b5e9962cf641ae4c92ab5d5d8333` plus separately saved scripts. The executed
AIR compiler SHA256 is
`98d5da45a76df0852d6e63bff3843229a6a19d77d72c83afffefa706ecedae07`;
Core is `940ce6ad49b479df84630259c996f8f3ef26e66e7cd2a32485d4824f9032b37e`.
The frozen model SHA256 is
`cf551d480ba4fb617977ec0a53a89d56aa83e5bde2ebf4e3bd4dbb952fc0c1f7`.
Runtime identities bind the actually selected polling wait, detailed observer,
unchanged installed runner and input/temporary/output BO policy. Package versions
recorded by compilation are llvm-aie22.0.0.2026102001+4f5df13d,
mlir-aie1.4.5.dev83+g1631e1b, mlir-air0.0.1.2026102900+66a24f9.no.rtti,
and triton-xdna3.8.0.2026110104+79d7ae3. Use per-package command/toolchain records
for exact paths and flags; importing the existing executor does not use a Triton
recipe or CPU fallback.

`physical-storage-final-r1` correlates all18 registered packages:82 runtime
compute stages and282 tensor paths from ABI argument through shim DMA/flow/core
BD to local storage and ELF/linker symbols. Maximum declared local payload is
18,432 B, with zero extra tensor payload and a separate4,096 B reserved stack.
Two tail packages require port/channel checks (27 planned allocations each);
the other16 have no planned channel legalization and are explicitly not
applicable. No explicit memtile SRAM staging is observed in final IR; flow
endpoints do not reveal physical switchbox routing or undocumented buffering.
Static evidence does not measure on-wire bytes, dynamic stack use or device
utilization.

`compiled-final-r1` retains the installed DMA-to-channel assertion on two tail
cases. Its C++ fix derives/checks module-wide async token scope in the plan and
AIR, without changing tile/FP32 choices. `compiled-final-r2` then produced all18
ELFs but retained a false failure in the old channel verifier: its final device
substring included trailing host IR and reused SSA names. Balanced device-region
extraction fixes that parser. Conflicting real buffer provenance, wrong ports,
extra payload and missing provenance still reject. The original checker bytes,
failed commands/logs and new offline audit remain preserved; `compiled-final-r3`
is the fresh fully passing compilation actually executed. Earlier source-derived
proposal and static-coverage failures and protocol amendments also remain local.

The clean-shell `env -i` CPU entry passed in `clean-shell-cpu-final-r1`, including
35 Core/Amoeba/search/AIR groups, unchanged CGRA contracts and protocol/fit/
runtime/flow/selection/parser tests. Whole-task data organization has58 checks,
including transit lifetime negatives; native cost has67 checks. Independent Core
ldd has no AIR/AIE/XRT/Neura dependency. `final-tool-bridge-r1` verifies the final
rebuilt AIR binary equals the executed frozen one and all24 compiled packages
regenerate byte-identical transformed Taskflow, facts, plans and AIR. This bridge
is CPU evidence, not another hardware run.

Raw results remain at `results/taskflow/implementation-search-v10/`, with all
attempts preserved. The checked-in `taskflow/evidence/implementation-search-v10/`
contains byte-preserving selected evidence, source/path/SHA bindings and offline
verification. Large FFN input weights and compiler binaries remain local;
generator/seed/reference/input identities and the explicit omissions are retained
so they can be regenerated. Program-wide M128 v7/v9 results are historical and
not remeasured here. Full-FFN calibration, physical traffic counters, multicore
models and additional placement/retention locations remain future work.

Final portability review found that historical exclusion witnesses still used
absolute acquisition paths. The delivered fixture now includes fifteen small
byte-identical witnesses with restricted artifact-relative paths and original
SHAs. Selection no longer needs any historical result directory. Tests reject
missing, modified or escaping witnesses, and a real read-only rerun with old
result paths forbidden selects the same four candidate IDs. This location-only
patch does not rewrite the executed orchestrator snapshot, frozen parameters or
measurements. Its separate evidence is
`taskflow/evidence/implementation-search-v10-portability-receipt.json`.
