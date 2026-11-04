# Direct AIR composite calibration v9

The experiment fitter is `taskflow/scripts/fit_direct_air_cost_v9.py`. It consumes
SHA-bound native feature plans and independently audited profiling results. It
does not derive compiler features from MLIR, change source computations, or provide
a second production planner. The production provider and legality checker live in
Core. The CGRA model is unchanged.

The initial frozen model is recorded under the local result root
`results/taskflow/ffn-profiling-v9/frozen-model-r1` (coordinator-managed copy).
The original fit and feature extraction evidence is
`.work/profiling-v9-fit/r1/`. Its `training-manifest.json` binds raw result and audit
hashes, native feature plans, and a separate old-package/new-feature identity
bridge. The old compiled packages and measurements retain their identities: new
features-only plan IDs were not the IDs executed by those old packages.

The frozen model SHA256 is
`ad514b9b0a2bcfb6738f1ae47953fbe0700c6d335cf748bb2e638eb37c0b9966`.
Training uses M1/M5/M8 FFN Gate/Up/Activation/Down/full profiling and packed-input
controls M8×64/M32×64 add/mul grouped/split. These are training/pilot observations,
including M8 full. The entire separate-four-input control experiment is excluded
because of its numerical failures. FFN M3 stages/full and packed controls17×80 were
preselected using source facts before execution and before model freeze. The
fitter never opens their timing files. Correlation across FFN source families
means this is a shape-generalization holdout, not validation on unrelated programs.

One row is the median of hot wall samples for a candidate. Repeats are not counted
as independent feature rows. The label is prepared-host-input through returned
output using the detailed observer; context load, input/reference loading,
validation, and serialization are excluded. Nested API spans are not added to
compute time. The existing runner and polling behavior remain unchanged.

The frozen objective minimizes squared residual divided by `max(median_ms,1ms)`.
Column-scaled exhaustive active-set nonnegative least squares fits four terms,
with no hidden intercept. The coefficients are:

| Native feature | Coefficient (ms per feature unit) |
|---|---:|
| command_count | 0.40857436592089463 |
| source_f32_product_operations | 0.00006761071446548108 |
| source_math_exp_f32_operations | 0.0009093437300709143 |
| hardware_stage_count | 0.008830708552892901 |

The scaled feature matrix has rank4, singular values approximately
1.400,1.028,0.966,0.227. These coefficients describe a composite host call. They are
not independently measured command, arithmetic, exp, or stage physical timings.
In particular, product counts describe source multiply/divide, not all generated
soft-float helper calls. Source exp is a proxy for its actual lowered computation.
DMA bytes remain checked native facts and are not separately charged.

Training control residuals reach about0.136ms while host-wait modes appear around
0.258/0.510ms. The historical runs do not establish the selected wait backend. This limits claims about tiny stage effects or candidate rankings.
The first model predicts M3 full about13753.12ms and each M3 GEMM about4573.14ms;
these numbers were frozen before holdout execution and do not establish accuracy.
Holdout outcomes belong in a separate post-freeze report. Do not refit this model
using them and then call the same cases holdout.

The calibrated domain binds target/toolchain/runtime, scalar implementation,
source fingerprints, operation coverage and predeclared feature ranges. Mixed
vector implementations, arbitrary new programs, and whole-program partition
controller/slicing/assembly overhead remain outside this calibration. Unknown
cost stays null. A new model requires its own provenance and a new holdout split.

Synthetic fitter boundary tests run with a Python environment containing NumPy:

```sh
python taskflow/test/TaskflowModels/direct_air_fit_v9.py
```

They test known coefficient recovery, unread holdout paths, changed raw hashes,
train/holdout group overlap, unfrozen objectives, missing audit candidates, and
rank deficiency. They do not claim hardware calibration.

The initial frozen model's four feature ranges do not establish validity for
arbitrary new tiling/residency choices of the same source. Its calibration cases
use the fixed configurations recorded in the native feature plans. Treat it as a
fixed-configuration experiment until a checked configuration-domain restriction
is attached; the fingerprint alone does not identify a mapping configuration.
Any later stricter domain document/model receives its own identity, preserves the
frozen coefficients, and does not relabel an already-running holdout invocation.

## Independent post-freeze holdout validation

The separate holdout audit is `.work/profiling-v9-audit/r7/`. It rereads every raw output and supplied reference NPZ with finite FP32 `atol=rtol=1e-5`; it does not trust recorded success flags. M3 has three seeds, one warmup and one hot sample per candidate/seed (30 checked outputs across five programs). The17×80 packed controls have three seeds, two warmups and ten hot samples (288 checked outputs). All318 output checks pass. This is numerical success; the prediction errors below are performance-model misses, not numerical failures.

`frozen-model-holdout-score.json` binds the actual `fit.json`, training manifest, native feature plans and independent audit hashes. It checks the exact frozen model SHA:

`ad514b9b0a2bcfb6738f1ae47953fbe0700c6d335cf748bb2e638eb37c0b9966`.

Predictions are copied from `preselected_holdout_no_labels_read` and independently recomputed from its declared features and unchanged coefficients. Actual values are pooled hot medians. No coefficient, objective, split or original domain identity was changed. The later stricter-domain derivative has a separate identity and does not replace this original holdout model.

| Preselected holdout | Frozen prediction ms | Measured median ms | (Prediction−actual)/actual |
|---|---:|---:|---:|
| M3 Gate |4573.143133|4553.212227|+0.438%|
| M3 Up |4573.143133|4553.210319|+0.438%|
| M3 activation |34.913125|34.524046|+1.127%|
| M3 Down |4573.143133|4551.895148|+0.467%|
| M3 full FFN |13753.116802|13688.246195|+0.474%|
|17×80 add grouped,6 stages|0.461559|0.660778|−30.149%|
|17×80 add split,12 stages|0.514543|0.916497|−43.858%|
|17×80 mul grouped,6 stages|0.645460|0.914402|−29.412%|
|17×80 mul split,12 stages|0.698444|1.171761|−40.394%|

M3's mean absolute percentage error across five programs is0.589% (maximum1.127%); the full FFN error is0.474%. The tail-control mean is35.953% (maximum43.858%), with all four predictions low. Being inside the originally declared feature ranges therefore did not establish accurate tail/stage generalization. These labels must not be refitted into the same model and then reused as holdout evidence.

For the four tail controls, grouped remains cheaper than split within each operation in both prediction and measured medians. One of six strict cross-control point-estimate orders reverses: the model places add-split before mul-grouped, while their measured medians are0.916497 versus0.914402ms. That approximately0.0021ms observed gap is much smaller than uncontrolled timing variation; this is a descriptive median ordering, not a significant ranking claim. M3 Gate/Up/Down are a prediction tie, which the audit does not arbitrarily break. Their tiny measured differences are not evidence of a learned relative ranking.

The older baseline profiles have no recorded actual selected wait backend. The presence of a polling implementation and its0.0002-second constant does not prove those calls selected it; native support can choose a different implementation. New profiler snapshots write `wait-backend.json` from the actual cached `_wait_nogil` callable after completed waits, with module/qualified name, available source/module SHA and explicit uncertainty. Older missing records remain unknown, and neither tiny-call modes nor frequency assumptions are converted into measured device time.

The new `profile-mixed-m1-gate-r1` is a separate preserved `ERT_CMD_STATE_TIMEOUT`: its scalar control completes, but the mixed candidate does not produce a completed numeric/latency label. `mixed-m1-gate-failure.json` binds the failure evidence. This is a mixed-backend correctness/execution issue under diagnosis, not evidence that the established full scalar FFN has a new bottleneck. No timeout duration is used as a cost label or as a successful vector speed comparison.

## Fresh per-source configuration domains

The fitter now accepts optional `manifest.source_feature_ranges`, with the same
source-fingerprint→native-feature→[low,high] structure as the Core provider.
Fresh workflows derive these bounds from the declared training and preselected
holdout **static native feature plans**, before any holdout timing is read.
The source set must match the declared native sources; each entry is nonempty,
each feature exists in that source's records, bounds are nonnegative int64 values
with low≤high, and every declared static case must fall inside its bounds. The
validated object is copied unchanged into `model.domain.source_feature_ranges`.
Implementation identities retain their separate whitelist; a scalar model does
not acquire mixed-implementation coverage from these numeric ranges.

Missing that optional field preserves legacy behavior. A deterministic replay
using only the original training labels and preselected static source facts
produced model.json **and fit.json byte-identical** to the original frozen files,
including SHA `ad514b9b…c0b9966`; no holdout label was read and no parameter was
adjusted. The historical frozen model is not silently tightened. New workflows
freeze their narrower domains under new manifest/model identities. Eighteen
synthetic fitter tests cover propagation, coefficient invariance, unknown/missing
sources and keys, malformed/negative/overflow/bool/reversed bounds and bounds
excluding a declared native case.
