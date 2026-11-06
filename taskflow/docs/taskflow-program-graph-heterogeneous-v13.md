# Static CPU/NPU ProgramGraph validation v13

This stage proposes static whole-program placement and execution-region
comparisons on the same actual Taskflow computation. C++ remains responsible
for source analysis, regions, placement, copies, scheduling and search. The CPU
backend compiles actual extracted bodies; Python numerical operations are
references only. The NPU path uses existing direct-AIR and XRT execution.
Existing CGRA models and v9/v10/v11/v12 evidence are unchanged.

The source has three tasks on distinct identity-layout f32
storages: `T=A+B`, `U=2*T`, then `C=U+B`. B is an immutable input used by the
first and last tasks, so its reuse is an analysis fact rather than a declared
residency policy. Source arguments are A/B inputs and C output; T/U are actual
allocations. There are no placement, tile, channel or model annotations in the
fixture. The intended baseline comparisons are full CPU, one full NPU region,
a mixed CPU→NPU→CPU program, and three separate NPU regions. These are proposed
controls, not a Python production candidate generator.

The pointwise program may favor CPU at every tested size. NPU launch/staging
cost can dominate arithmetic. This experiment must report that outcome honestly;
it does not assume mixed placement or NPU acceleration wins.

Proposed numerical fixtures
---------------------------

`test/TaskflowAIR/prepare_heterogeneous_v13.py --output NEW` prepares plain MLIR,
three seeds (11/23/47), source/array hashes and independent original-program
float64 references cast to f32. Full outputs use `atol=rtol=1e-5` and finite
checks. T/U reference arrays are supplied separately for diagnostic region
binding checks, not as production computed values.

The agreed frozen training sizes are 4×64 and 16×64; holdouts are 7×80 and
9×96. The first NPU contract is resident-only extracted regions, so these are
unseen dimensions, not a claim of a tiled-tail execution. The earlier proposal
used 32×64 as a holdout. Before any timing labels, it was moved to a separate
capacity-rejection category and replaced by 9×96 to keep both legal holdouts
within the first resident-pool contract. The original proposal remains intact.

32×64 declares 40960 B across all five arrays, versus 20480 B for training
16×64. Its negative scope is a full three-task resident NPU region under the
current materialized-pool contract. This is not an all-CPU rejection or a claim
that every possible memory-reuse/tiled plan is impossible. Capacity rejection
must come from the native checker; it is excluded from legal model labels.

`results/taskflow/program-graph-heterogeneous-v13/dataset-freeze-r1/manifest.json`
SHA is `485236bce4cfc3aa5a8df5642395f77a569a6ba084776068136da9ab5d86a798`.
It records `frozen-before-timing-labels`, the three seeds, source/input/reference
and generator snapshot hashes, and the region-cost boundary. No timing labels
were present at registration. The independent `dataset-audit-r1` checks all 45
reference arrays. Numerical references are not timing labels. Native candidate
placement/region records will be frozen separately before their timing labels;
the data manifest does not invent production plans.

`test/TaskflowMapping/heterogeneous_validation_v13.py --fixtures PREPARED
--output NEW` currently performs an offline fixture audit: source and array SHA,
full independent numerical reference readback, static shape/dtype and declared
split consistency. It explicitly does not certify MLIR semantics or compiled
execution. Native source/region/checker interfaces must be added to the final
acceptance once agreed. The measurement-only fitter is described below; execution remains
owned by the native manifest and existing CPU/NPU runner path. The validator also checks the frozen static shape registry and excludes
capacity-negative cases from legal model labels.

Cost and timing boundaries
--------------------------

A CPU cost refers to an actual compiled task or region, with shared-library,
source, ABI and compiler identity. Library loading/context construction are
one-time preparation. Workspace allocation/preparation must be stated explicitly.
Python/ctypes dispatch and coordination costs cannot silently disappear when
predicting a host-visible program boundary.

The agreed model uses device-specific composite region walls. A region label
includes dispatch, required BO synchronization, the compiled CPU call or XRT
start/wait, and returning the final mapped BO views. Input reset, whole-program
coordination outside the region and final output materialization are excluded
from that regional label. Whole-program evaluation adds the separately measured
boundary-copy term once. Any remaining coordination residual must retain its
scope instead of being silently called compute or transfer.

Actual `bound_buffers` mappings avoid staging when CPU views demonstrably alias
the same shared BO. NPU synchronization/XRT remain inside the regional label;
those events cannot be charged again. Earlier v9 prepared-call walls included
final output copying and are a different contract, so they cannot silently be
used as v13 regional labels. Nested profiler spans overlap; `runner_run` may not
be summed with its inner API events. Wait is not isolated kernel compute.

A shared system BO is a zero-copy alias only when the actual bound mapping and
visibility/synchronization establish that fact. CPU array→BO staging is a host
copy, not an invented physical DMA. BO reuse across prepared calls is distinct
from on-chip residency. Initial external inputs, region-boundary outputs and
final returned output must have an explicit ownership/readiness state.

Prepared/hot measurements exclude one-time context load, initial model/library
setup and later evidence I/O unless separately stated. They cannot rank cold
program launches without another contract. The pointwise sizes have correlated arithmetic and tensor-byte counts; the fit
does not claim separately identified compute and byte slopes from those same
regional samples. Region group lengths 1, 2 and 3 must be covered in training,
with held-out dimensions and separately predeclared unseen placement combinations.
A host memcpy microbenchmark measures
its own source/cache/size conditions; it is not a measured PCIe or DDR rate.
An NPU near-empty command likewise does not isolate hardware computation by
subtraction. Prefer an explicitly composite regional cost when separation is
not supported by observations.

The v12 0.338853 ms add-scale observation belongs to its frozen source, runtime,
BO policy and detailed observer boundary. It is historical context, not a v13
calibration label. Any reused data must retain its distinct identity and runtime
conditions. Existing CGRA cycles are not converted into CPU/NPU milliseconds.

Proposed evidence interface
---------------------------

The root will define the production native interfaces. The independent audit
needs the following exported facts; this list is an evidence proposal rather
than a second plan language:

- Parent actual source/body/candidate/ProgramGraph/target IDs and checker result.
- Each CPU/NPU execution region's parent task IDs, child source and ABI, compiled
  library/ELF SHA, and native parent-storage↔child-ABI bindings with copy/version,
  offsets, sizes, roles and prepared-state contract.
- Native region coverage, dependencies, copy creation/release, output ownership,
  resource/capacity scope and unsupported cases. Abstract availability is not
  an invented physical capacity.
- Per-sample seed/repeat/warmup, complete-program host wall, ordered actual region
  calls and NPU submissions, explicit boundary copies/synchronization, saved full
  outputs, raw host events and distinct evidence-I/O costs.
- Model/calibration source and frozen manifest SHA, exact train/holdout members,
  timing/runtime/observer/tool identities, applicable static-feature domain and
  machine-checkable included/excluded transfer/submission ownership.

The independent validator should reject missing/duplicated tasks or output
regions, stale source/child/ABI/artifact identity, wrong storage/version binding,
read-before-ready, fake zero-copy or unsupported aliasing, incompatible cost
units/boundaries, duplicated transfer charges, missing holdout freeze and numeric
errors. It must read all raw outputs and independently report max absolute,
relative-floor, near-zero and normalized L2 errors without relaxing the gate.
Equal per-strategy budgets and alternating order are needed for comparisons;
performance error/ranking/regret are evaluated only after frozen predictions.

New CPU mock/offline checks can test the evidence validator and its negative
cases, but cannot substitute for actual compiled CPU semantics or root-operated
NPU numerical validation. No v13 speedup, calibrated model, hardware acceptance
or general heterogeneous support is claimed by this proposal.

### Measurement-only regional calibration

`test/TaskflowModels/fit_heterogeneous_cost_v13.py` now aggregates training measurements. It does not choose placements, emit plans, or rank candidates. Its inputs are the frozen dataset manifest, one or more executor output roots, and the original executor cases files paired in the same order:

```sh
python taskflow/test/TaskflowModels/fit_heterogeneous_cost_v13.py \
  --dataset-frozen-manifest DATASET/manifest.json \
  --training-root TRAINING_RUN --training-cases TRAINING_CASES.json \
  --output NEW_MODEL_DIRECTORY
```

The fitter validates every declared input/reference pair against only the two frozen training shapes before opening timing labels. It binds native manifests to compilation and preparation hashes, checks native `work_elements` and supported arithmetic against the fixture facts, and independently checks every saved output, including warmups, with `atol=rtol=1e-5`. Warmups contribute no timing labels. The fitter accepts executor `summary.json` (or an explicitly supplied results JSON); it requires the original cases file to associate samples with their compiled artifacts and frozen arrays.

The model schema is `orbit.heterogeneous.region-cost.v13`. `region_models` contains six device/task-count rows for CPU/NPU and one, two, or three tasks. Each row has `status` and `knots`, whose entries contain `work_elements`, median `ms`, sample count `n`, and a digest of the raw sample/output identities. `boundary_model.knots` uses logical input-plus-output `bytes` instead. At least two distinct measured knots are required for calibration; missing or one-knot rows remain uncalibrated. The consumer must interpolate only within the inclusive measured range and must reject extrapolation.

Regional timings are composite walls: the CPU descriptor preparation, ctypes call and observer, or NPU runner synchronization, submission, wait and observer, are already included. The boundary label is the measured whole wall minus the sum of region walls. It includes input reset, final output copy, and remaining outer gaps exactly once. The fitter reports distributions and median absolute deviations for these components across measured placements; it does not add a separate DMA or launch charge. This does not identify device execution cycles or physical DDR traffic.

CPU-only synthetic contract tests are provided by `test/TaskflowModels/heterogeneous_fit_v13.py --output NEW`. They cover aggregation, exclusion of warmup labels, missing-row calibration, rejection of holdout arrays and artifact tampering, and independent rejection of numerically wrong raw outputs. The tests create no device calibration. No real timing model has been fitted at this stage.

Before formal calibration, the native manifests must additionally supply mandatory
`program_family_key` and `execution_contract_identity` strings. Every training
case must agree on both, and the fitter copies both identities into the model.
The source-family key is produced by C++ from the actual whole Taskflow program:
static memref extents and affine iteration extents are normalized while actual
SSA, arithmetic/constants, layout and source dependencies remain significant;
placement and region-cut attributes do not define a different arithmetic family.
The execution-contract identity binds the separately frozen machine, toolchain,
runtime and execution-observer contract. A missing or mismatched identity is a
hard calibration error. Consumers must enforce these identities as well as
per-device/task-count interpolation bounds. This model makes no claim to
arbitrary add/multiply programs sharing only a work count. The CPU tests now
include coherent-manifest mutations for both missing and mismatched identity
fields, independently of the existing file-hash tamper test.

### Frozen training and independent execution audit

Formal training is saved under `results/taskflow/program-graph-heterogeneous-v13/`
in `training-plans-r1`, `training-compile-r1`, `training-execute-r1`, and
`training-cases-r1.json`. `model-freeze-r1/model.json` has SHA-256
`235872a546eda3f8fd981c6970e846bf1e77d3a820aeabf61c555a49e9bf7a6f`;
its freeze receipt precedes holdout measurements. This model remains unchanged.

The separate `independent-training-audit-r1/summary.json` verifies all **210**
saved outputs from ten training cases, three seeds and seven calls per seed
(two warmups and five hot calls). All outputs pass the original combined
`1e-5 + 1e-5*abs(reference)` criterion against an independent float64 evaluation
of the saved A/B inputs; maximum absolute error is
`2.384185791015625e-7`. The audit independently reproduces every median, sample
count and raw provenance digest for all six regional model rows and both boundary
knots from the 150 hot whole-program calls. It reads no holdout measurements.

The audit also checks compiled child source, CPU library, NPU AIR/ABI/ELF,
execution contract and exact running executor snapshot identities; all native
region lifecycle IDs against actual CPU/XRT/BO-sync event kinds, temporal order
and containing region intervals; recorded ctypes descriptors against actual
parent addresses; mapped BO aliases; and exclusion of internal-only allocations
from executor boundary storage. It checks 168 actual CPU calls, 210 XRT
start/wait pairs, 840 BO synchronization API calls, and 210 runner staging
observations. Each runner observation records no `numpy.copyto` calls within the
bound existing runner. This is a scoped host staging observation: BO
synchronization and device DMA remain present. Recorded pointer/API evidence is
not a physical DDR traffic measurement or device-cycle trace.

The running executor snapshot SHA-256 is
`fc4c8f44a00cb35598da102e18d96814c733e92597a57cb49c4c46418af9324c`,
and the execution contract identity is
`2402a46a0f711e3236686d0b6e40c5812c04675e6954996fdcb0c5942a5deb28`.
The audit distinguishes this execution observer identity from the observer used
when compiling artifacts. CPU-only cases do not claim to have imported an XRT
runner.

The reusable offline audit command is:

```sh
python taskflow/test/TaskflowMapping/heterogeneous_execution_audit_v13.py \
  --execution-root TRAINING_RUN --cases TRAINING_CASES.json \
  --fixtures DATASET_DIRECTORY --model-freeze MODEL_DIRECTORY \
  --split training --output NEW_AUDIT_DIRECTORY
```

Its `--split holdout` mode independently verifies saved holdout executions and
identities without fitting or modifying the frozen model. Heldout prediction
errors, ranking and regret remain a later independent validation step. All
reported durations are host monotonic wall milliseconds; NPU waits include
runtime waiting, and no additional DMA or launch cost is added outside their
regional composites.

`independent-training-audit-r2` repeats the same complete audit with explicit
checks for millisecond/non-device-clock/non-DDR model scope and distinct,
nonoverlapping, correctly sized/aligned parent buffers under the source noalias
contract. It passes the same 210 outputs and leaves both the original audit and
all training/model artifacts unchanged.

### Direction change: empirical interpolation is not an analytical mechanism model

Further heterogeneous candidate/search expansion is stopped. Existing frozen
training, model, and search artifacts remain unchanged. The partially written
`run_heterogeneous_v13.py` entry passed help parsing only and has not been run;
it is not an accepted reproduction workflow. No new selected-candidate
execution is requested by this validation work.

The frozen `model-freeze-r1` model is an **empirical program-region piecewise
interpolation**, not an analytical CPU/NPU or communication model. Its exact
regional parameters, in host wall milliseconds, are:

| Device | Tasks in region | First work knot → median ms (n) | Second work knot → median ms (n) |
|---|---:|---|---|
| CPU | 1 | 256 → 0.0241545 (30) | 1024 → 0.053623500000000004 (30) |
| CPU | 2 | 512 → 0.027 (15) | 2048 → 0.026959 (15) |
| CPU | 3 | 768 → 0.0211 (15) | 3072 → 0.021899 (15) |
| NPU | 1 | 256 → 0.305181 (45) | 1024 → 0.305601 (45) |
| NPU | 2 | 512 → 0.306001 (15) | 2048 → 0.308041 (15) |
| NPU | 3 | 768 → 0.310741 (15) | 3072 → 0.563864 (15) |

The boundary row is 3072 logical input/output bytes →
0.00651999999999997 ms (75 samples), and 12288 bytes →
0.007789999999999964 ms (75 samples). For each matching device/task-count row,
its function is exactly
`y(x) = y0 + (y1-y0)*(x-x0)/(x1-x0)` for `x0 <= x <= x1`.
The whole-program prediction is the sum of these regional functions plus the
boundary function once. Nothing in those two points identifies a compute
throughput, physical bandwidth, per-launch constant, or overlap model. The
slightly decreasing CPU two-task row is retained as measured; it is not
silently forced monotonic. Differences between CPU/NPU rows cannot isolate
causes from these labels alone. A task-count row also pools the fixed family's
permitted task compositions rather than estimating separate add/multiply
instruction latencies.

The NPU region label already includes actual runner sync/start/wait,
bound-buffer/view handling and the observer. The CPU region label includes
descriptor preparation, ctypes dispatch and the actual compiled call. The
boundary is measured whole wall minus regional walls and includes input reset,
final copy and residual outer gaps. Adding component measurements to these
composite labels would double-charge them. These labels may validate a narrow
fixed-family empirical predictor, but they do not establish an explanatory
mechanism model or a benefit from heterogeneous placement.

### Proposed independent mechanism validation protocol

A separate mechanism study must freeze its source/ELF, toolchain, runtime,
observer, buffer state and training/holdout registry before reading labels. The
proposed training matrix is requested bytes `{1024,4096,16384}` crossed with
operation counts `{1,4}`. Proposed heldout bytes `{2240,3456,8192}` crossed with
counts `{2,7}` are disjoint from that matrix. Every heldout byte size lies
between the measured training endpoints; count seven is outside the training
count range and explicitly tests an additive-count extrapolation hypothesis.
This proposed registry is not a claim that measurements have run or that the
root-owned final mechanism protocol is already frozen.

Separate API mechanisms and synchronization directions must retain separate
labels. A BO synchronization API's requested byte count is not physical DDR
traffic. Record requested bytes, actual BO allocation size, mapped address,
alignment and device identity. Keep BO initialization, reuse, read/write
ordering and any state transition explicit; do not claim to flush physical
caches without evidence. A host-copy benchmark must prove distinct source and
destination ranges and check the destination data. A start/wait benchmark must
bind the exact submitted Taskflow/AIR/ELF and kernel workload. If that workload
contains computation or DMA, its wait is not a pure launch constant.

The independent audit will verify the frozen split and source/runtime hashes,
all raw sample/event intervals, actual API counts/directions/sizes, and pointer
bindings. It will distinguish setup/context/BO preparation from repeated sample
walls. Constituent API intervals may explain coverage of a composite sample,
but a decomposition must report the uncovered residual and observer scope
rather than relabel it as compute or transfer. If scopes overlap, they cannot be
summed as independent costs. Clock state remains reported, with no assumption
that default frequency is locked. No device-cycle or power claim follows from
host monotonic timers.

For a separately frozen root-owned mechanism model, an independent validation
will report heldout per-cell median error, absolute/relative error, count- and
size-specific error ranges, and aggregation errors without refitting. Any later
program-level ranking/regret report must bind the exact legal compared set and
report the measured winner and prediction-selected winner within that set;
these are validation summaries, not a Python production scheduler. Missing,
unpriced or out-of-domain mechanisms stay explicit rather than receiving zero
cost. Existing CGRA models and the empirical frozen regional model are not
modified by this study.

### Mechanism-only calibration, frozen separately

The root-approved frozen protocol is now `mechanism-protocol-r2/protocol.json`
(SHA-256 `a6432a6ae53123e3d37232e89281b13bb33c058481904c7ae3aa4b70736113cf`).
It supersedes the earlier proposed registry: training byte sizes are
1024, 4096, 16384 and 65536 with repetition counts one and four; heldout sizes
are 2240, 3456, 8192 and 32768 with counts two and seven. Operational standalone
host states are `host-written` and `host-read`, with three warmups and 21 hot
repeats. Program measurements use two warmups and five hot repeats, with three
seeds. The four full-CPU/full-NPU programs at 4×64 and 16×64 supply training API
spans; the six mixed-placement programs are separately declared holdout programs.
The protocol and bindings are frozen independently of the old empirical regional
model; neither the regional model nor any CGRA model is changed.

`test/TaskflowModels/calibrate_mechanisms_v13.py` fits only observed mechanism API
sums using `T = count*(alpha_ms + beta_ms_per_byte*bytes)`. It enumerates the
unconstrained two-coefficient least-squares solution and nonnegative boundary
solutions. Actual `run.start` spans have an alpha-only fit with beta fixed to
zero. It does not fit waits, CPU library calls, whole-program wall, regional
wall, outer sequence overhead, or an inferred internal-DMA bandwidth. Timer-empty
measurements are retained as diagnostics without subtracting an assumed overhead.

A sync sequence's operational state is not constant: setup occurs once before
the counted calls. The first sync preserves `host-written`/`host-read`; later
calls become `after-TO_DEVICE-sync` or `after-FROM_DEVICE-sync`. Calibration
therefore uses individual API observations with count one for these standalone
syncs. It does not repeatedly apply dirty-host coefficients after the first
sync. Public program states remain distinct unless the frozen bindings explicitly
justify the same operational setup. In particular, standalone FROM_DEVICE calls
do not imply a device producer. The `device-completed` FROM_DEVICE row instead
uses actual program output syncs after an observed wait and a native output ABI.

Program input reset fits the observed `np.copyto` event separately for host and
mapped-BO destinations. Final output acquisition fits the actual frozen executor's
aggregate dictionary/`array.copy` span, separately for host and mapped sources;
standalone `np.copyto` measurements do not price that acquisition. Source,
executor, runtime, protocol, path, resource, state and measurement boundaries
remain part of the parameter binding.

The 18-row parameter file `mechanism-model-freeze-r1/parameters.json` has SHA-256
`1a8490bdba6e60589466bf6e4646fa794346ecfc8a5ea72ba6b45216dd9f963a`.
It was frozen before holdout measurement. The separate
`mechanism-independent-training-audit-r1` checks all 420 raw training program
outputs against the saved inputs and independent float64 formula, reproduces all
18 NNLS optima using independent scalar normal equations and boundary enumeration,
and verifies raw hashes and byte/count domains. Maximum absolute error is
`2.384185791015625e-7`. Four program byte slopes and the standalone post-TO sync
slope are unresolved at the observed noise level; those observations are retained
without retuning or a physical-bandwidth interpretation.

The model is deliberately incomplete as a whole-program predictor. CPU call,
NPU wait, uncaptured host-call/region overhead and internal-DMA execution costs
remain unknown. A mechanism subtotal may be compared with exactly the matched
API subtotal, while full cost stays null. Residual host time is reported rather
than numerically assigned to DMA or compute. Exact-state misses and out-of-byte-
range requests remain unpriced. No placement-ranking or speedup claim follows
from these partial sums.

### Frozen mechanism parameters and heldout results

The following table reports the 18 frozen mechanism parameters. Alpha is in microseconds and beta in nanoseconds per requested API byte; these are unit conversions of the exact JSON coefficients, rounded here for readability. Beta is an API-size slope, **not** measured physical bandwidth. Program API rows are valid only for 1024–4096 bytes, standalone rows for 1024–65536 bytes; submit has zero byte feature.

| Mechanism / path | State | α (µs) | β (ns/API byte) |
|---|---|---:|---:|
| host.input_reset / `standalone.numpy.copyto.host-to-host` | host-written | 0.435474 | 0.0221483 |
| host.input_reset / `standalone.numpy.copyto.host-to-mapped-bo` | host-written | 0.456944 | 0.0222095 |
| host.input_reset / `standalone.numpy.copyto.mapped-bo-to-host` | host-written | 0.467445 | 0.0209784 |
| bo.sync_to_device / `pyxrt.bo.sync.TO_DEVICE` | host-written | 0.42642 | 0.00832882 |
| bo.sync_from_device / `pyxrt.bo.sync.FROM_DEVICE` | host-written | 0.405681 | 0.00846752 |
| host.input_reset / `standalone.numpy.copyto.host-to-host` | host-read | 0.325453 | 0.0296395 |
| host.input_reset / `standalone.numpy.copyto.host-to-mapped-bo` | host-read | 0.41717 | 0.0207922 |
| host.input_reset / `standalone.numpy.copyto.mapped-bo-to-host` | host-read | 0.405543 | 0.0213962 |
| bo.sync_to_device / `pyxrt.bo.sync.TO_DEVICE` | host-read | 0.408635 | 0.026213 |
| bo.sync_from_device / `pyxrt.bo.sync.FROM_DEVICE` | host-read | 0.397099 | 0.029114 |
| bo.sync_to_device / `pyxrt.bo.sync.TO_DEVICE` | after-TO_DEVICE-sync | 1.98324 | 0 |
| bo.sync_from_device / `pyxrt.bo.sync.FROM_DEVICE` | after-FROM_DEVICE-sync | 0.354934 | 0.0082969 |
| host.input_reset / `numpy-to-host` | prepared-hot | 0.974628 | 0.0892821 |
| host.input_reset / `numpy-to-mapped-bo` | prepared-hot | 1.27123 | 0.0552013 |
| host.output_copy / `host-to-numpy` | prepared-hot | 2.06115 | 0.0996017 |
| host.output_copy / `mapped-bo-to-numpy` | prepared-hot | 3.03185 | 0.266824 |
| bo.sync_from_device / `pyxrt.bo.sync.FROM_DEVICE` | device-completed | 3.07952 | 0.140622 |
| npu.submit / `pyxrt.run.start` | prepared-hot-bound-bo | 6.81513 | 0 |

Root's `mechanism-holdout-gate-r1.json` records the exact parameter, fit-report
and freeze hashes before heldout measurement. The final independent audit is
`mechanism-independent-holdout-audit-r3/summary.json`; earlier audits are kept.
It independently verifies all **420 training and 1134 heldout program outputs**,
with maximum absolute error `2.384185791015625e-7`, and reproduces all 18 frozen
NNLS optima without modifying parameters. Standalone host-copy correctness was
checked inside the frozen benchmark outside its timer; independent raw-output
readback here applies to the persisted compiled-program outputs.

The 96 heldout mechanism API cells have mean absolute percentage error
**29.1045%**, with maximum **436.736%**. This is a performance-model miss, not a
numerical failure. The largest failure is the post-TO_DEVICE same-buffer row:
its MAPE is **375.287%**, with maximum 436.736%; its fitted byte slope is zero
and remains unchanged. First-sync host-written/read TO/FROM rows have MAPE
2.76–5.94%; post-FROM_DEVICE has 6.09%. Other failures remain visible:

| Measured mechanism group | Heldout API-cell MAPE | Maximum relative error |
|---|---:|---:|
| Program device-completed FROM_DEVICE | 16.70% | 36.76% |
| Actual run.start | 23.97% | 43.93% |
| Program input reset into mapped BO | 31.12% | 53.08% |
| Program final output acquisition from host | 46.15% | 61.23% |
| Program final output acquisition from mapped BO | 21.08% | 40.28% |

These statistics compare frozen predictions against per-cell medians. They are
not an assertion that every call is deterministic. The heldout count-seven
case tests the preregistered additive-count hypothesis outside training count
four. Sync comparisons preserve distinct first and subsequent API states and
sum the appropriate predictions for each original sequence.

Host loop overhead remains separately visible. Across standalone nonempty
mechanisms, median unassigned outer time is 0.00029/0.00079 ms for training
counts one/four and 0.00047/0.00130 ms for heldout counts two/seven. Program
sequence outer residuals also include evidence serialization between calls:
median 0.675358 ms in training and 1.8449585 ms in holdout. These residuals
are not pure dispatch, DMA, kernel, or transfer costs and are not fitted.

### Public C++ mechanism facts linked to actual existing executions

`mechanism-public-plans-r1/binding-results.json` describes metadata reexports
of ten existing programs. The independent audit checks identical graph/plan IDs,
whole Taskflow and child Taskflow/CPU/AIR bytes against the original compiled
packages. This establishes a metadata-to-existing-execution bridge; it does not
claim that the newer compiler binary executed newly compiled hardware.

For 1110 hot program calls, the audit replays the parameter matching by exact
mechanism/path/resource/boundary/runtime/state and byte domain, reproduces the
C++ known subtotal, and binds each priced fact to one unique actual API event.
It checks the public lifecycle IDs and sync state chronology. Runtime-only
conservative output syncs are priced as observed APIs under the frozen executor's
host-poisoned output contract, without inventing an extra logical copy. Repeated
read-only input syncs without a host rewrite remain a different state and cannot
inherit host-written coefficients. Descriptive native-DMA and CPU-access items
remain covered by opaque composites and receive no additional elapsed charge.

The heldout program comparison is only the matched API subtotal:

| Program | Predicted known API subtotal (ms) | Actual matched API median (ms) | Relative error |
|---|---:|---:|---:|
| 16×64 NPU→CPU→CPU | 0.0173160 | 0.021130 | −18.05% |
| 16×64 NPU→CPU→NPU | 0.0303634 | 0.030899 | −1.73% |
| 16×64 NPU→NPU→CPU | 0.0173160 | 0.023288 | −25.64% |
| 4×64 NPU→CPU→CPU | 0.0161622 | 0.021530 | −24.93% |
| 4×64 NPU→CPU→NPU | 0.0282126 | 0.029309 | −3.74% |
| 4×64 NPU→NPU→CPU | 0.0161622 | 0.021180 | −23.69% |

These numbers must not be compared with complete program wall as if they were
complete predictions. Full cost and ranking remain **null** because CPU call,
NPU wait and additional host/region overhead are unpriced. The study supports a
checked mechanism decomposition and exposes its calibration failures; it does
not establish heterogeneous acceleration or a complete analytical performance
model. No holdout-driven refit, new search expansion, or selected-candidate run
was performed by the independent validator.

`mechanism-independent-holdout-audit-r4` adds explicit status scope and verifies
the premeasurement gate. Its `passed` status means structural/provenance and
numerical checks completed successfully. It does **not** mean the cost model
passed an accuracy criterion: `accuracy_passed` remains null (no numerical
acceptance threshold was preregistered), and heldout prediction misses are
recorded separately. Earlier audit directories remain unchanged.

The root's retained diagnostic explains a numerical sensitivity in the frozen
post-TO fit without asserting a physical cause. Its 504 hot training API calls
have median 450 ns, but one 714691 ns API span at memory sample 1109
(4096 bytes, initial `host-read`, repeat five, API index one) contributes 71.501%
of their total recorded time. The 1176 heldout post-TO calls have median 390 ns
and maximum 5740 ns. The unchanged least-squares fit therefore has alpha
1983.24 ns and beta zero, and fails this standalone prediction check. The long
span does not distinguish OS preemption from runtime behavior or another cause.
No sample is deleted and no parameters are refit after holdout. This raw
`after-TO_DEVICE-sync` row does not match the distinct public
`host-visible-after-sync` state, so it does not enter the current public-graph
known subtotals.

### Mechanism reproduction and offline checks

The mechanism workflow has its own entry point; it does not run the stopped
heterogeneous search workflow. It reuses the exact existing compiled programs,
input/reference archives and frozen executor/runtime contract specified by the
supplied protocol; it does not rebuild them. A fresh output directory is always
required. From the artifact repository, a clean-shell CPU-only check is:

```sh
env -i HOME="$HOME" PATH=/usr/bin:/bin \
  AIE_TOY_ROOT=/home/shiran/project/aie-toy \
  bash taskflow/scripts/run_mechanism_model_v13.sh validate-only NEW_CPU_OUTPUT \
  --protocol results/taskflow/program-graph-heterogeneous-v13/mechanism-protocol-r2/protocol.json \
  --bindings results/taskflow/program-graph-heterogeneous-v13/mechanism-bindings-r1/bindings.json
```

Only the authorized hardware coordinator should replace `validate-only` with
`all`. That mode executes the training split, calibrates and saves parameter
hashes, executes the heldout split, checks that parameters remain unchanged, and
runs the offline independent audit. Exact supplied dependencies must remain
available and match their recorded hashes. This is an existing-package/runtime
reproduction, not a claim of a portable fresh toolchain build.

The measurement-only calibration CPU test is
`test/TaskflowModels/mechanism_calibration_v13.py --output NEW`: nine synthetic
checks cover positive and boundary NNLS solutions, a rank-deficient design,
noise-unresolved small-byte slope, start-only alpha, invalid samples, refusal of
a heldout run before opening labels, and first-versus-subsequent sync state
progression. These tests calibrate no device. The calibrator source remains
SHA-256 `6f4008b6fb577053e45ffc5f94726731e59f44e9e8224a832a1eb7699ac33f22`.

The final independent command adds the C++ metadata bridge and optional
premeasurement receipt to the ordinary offline audit:

```sh
python taskflow/test/TaskflowMapping/audit_mechanisms_v13.py \
  --protocol PROTOCOL --training-root TRAINING_RUN --holdout-root HOLDOUT_RUN \
  --model-freeze MODEL_DIRECTORY --bindings BINDINGS \
  --public-plans CPP_METADATA_EXPORTS --holdout-gate PREMEASUREMENT_RECEIPT \
  --output NEW_AUDIT_DIRECTORY
```

Omitting `--public-plans` retains the independent raw mechanism/program audit
without claiming a C++ fact-to-execution bridge. `--training-only` replaces
`--holdout-root` for a pre-holdout verification and never opens heldout labels.

### Final root integration and preparation scope

The final C++ primary cost respects mechanism incompleteness. With
`mechanism_parameters`, `cost.estimated_ms` stays null even when a separately
preserved `historical_empirical_cost` predicts a number. Host copy/dispatch
resource labels explicitly alias declared host compute capacity, with no invented
independent memory port. Exact lifecycle/copy bindings and negative cases pass.
Final CPU checks are58 mechanism assertions,56 export checks,225 mapping checks,
43 Core/search/AIR groups and35 Amoeba lit tests; unchanged CGRA ML golden and
v12 mapper/scheduler differential checks pass. Final metadata exports are
`mechanism-public-plans-r2`; independent full audit r5 binds these exports and
the original premeasurement parameter gate. Original parameter bytes are unchanged.

Preparation observer `profile_heterogeneous_preparation_v13.py` was actually run
for30 trials with zero kernel dispatches. Across those host constructor spans,
median `hw_context` is0.81247ms, ELF0.06984ms, ext.kernel0.01820ms and ext.bo0.00947ms.
Full Prepared construction is much larger because it additionally verifies large
tool/library hashes, loads CPU libraries and creates views. These observations
are not a separated physical PDI/configuration cost. Raw samples and source
identity are in `mechanism-preparation-r1`.

`mechanism-state-diagnostics-r1.json` records an important condition difference:
training holds2 NPU contexts/6 distinct BOs (15360B requested system payload),
validation holds8 contexts/22 BOs (56320B). BOs are counted by unique actual
mapped address, not ABI edge count. These are benchmark-wide system allocations,
not SRAM occupancy, page-reserved allocator bytes or traffic. Same/different
previous-context timing is reported separately and does not justify a universal
switch-cost coefficient; pure physical configuration remains unknown.

The clean `env -i` all-mode reproduction was also run, not only help-tested, in
`mechanism-clean-reproduction-r1`. It creates its own training-only freeze before
its own heldout measurements and verifies all1554 outputs. This is a separate
repeat epoch of the unchanged procedure, not a refit/replacement of the primary
`1a8490...` model based on its heldout failures. Its parameters and results retain
their separate identities. The partially implemented broader heterogeneous-search
entry remains unexecuted and is not the mechanism reproduction entry.
