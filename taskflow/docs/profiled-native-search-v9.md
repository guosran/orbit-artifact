# Native proposal search and exact profiling feedback v9

`taskflow/scripts/taskflow_profiled_search_v9.py` is CPU orchestration around the
existing native C++ search driver. Python preserves artifacts and aggregates hot
host-wall medians. It does not implement mapping, legality, predictive scoring,
beam selection, AIR lowering, compilation, or device execution.

Generate proposals in a fresh output directory:

```sh
python taskflow/scripts/taskflow_profiled_search_v9.py \
  --tool builds/taskflow-v9/core/tools/taskflow-opt/taskflow-opt \
  --source /path/to/freshly/generated/source.mlir \
  --output results/taskflow/ffn-profiling-v9/joint-profiled-search-proposals-r1
```

Proposal generation requires an explicit computation/dependency-only source. The
initial preserved input was GEMM→scale M32/K128/N64 from v8 acceptance; a clean
reproduction entry generates this input afresh instead of depending on old results. The driver distributes initialization,
starts at tile8/64/32, proposes tiles8/32/32 and8/16/32 and discovers source-derived
retention choices. Two rounds, beam4, budget32, and one structural-diversity slot
are passed to the original driver. Only scalar implementations are proposed.
The original theoretical sensitivity model orders proposals; those scores are
explicitly uncalibrated and are not measured latency claims.

The initial run produced8 legal candidates and1 capacity rejection. Its cases
contain the real materialized Taskflow, feature-only target configuration,
feature plan, source/config/plan hashes, parent/action chain, plan/body IDs, native
unpriced execution fingerprint, and properties copied from checked native plans.
The eight execution fingerprints are distinct. No AIR or NPU execution is implied.
The coordinator lowers, independently checks, compiles, and executes selected
complete-program cases, then supplies independently audited results.

For feedback, pass `--profile manifest.json --output NEW_DIRECTORY`. The manifest
has schema `orbit.profiled-search.feedback.v1`, the boundary
`prepared-command-host-to-host`, and explicit `target` with id/toolchain/runtime.
Each file descriptor is `{ "path": "...", "sha256": "..." }`. Required descriptors
are `proposal_summary`, `proposal_cases`, `profile_results`, `audit`, and
`invocation`. Its `cases` entries contain `candidate_id`, `profile_name`, and file
descriptors for `compiled_source`, `compiled_air`, `compiled_plan`, `elf`, and
`compile_record`.

`compiled_air` means the exact AIR bytes whose hash the compiler record identifies,
with the native mapping/source identity attributes preserved. The tool checks:

- Proposal files retain their recorded hashes; compiled Taskflow bytes equal the
  native candidate source.
- A current native feature-plan rebuild reproduces the proposal execution key.
- Compiled and feature plans have identical full JSON after removing price-only
  fields; AIR mapping/source attributes bind the compiled plan/body identities.
- Compile records bind AIR and ELF hashes; the profiling invocation names that
  same AIR/ELF package.
- The entire experiment and independent raw-output audit pass; the candidate
  appears in the audit; all profile output checks remain finite and passed.

Only non-warmup wall samples are aggregated, one median and sample count per
measured candidate. A new raw manifest binds input/audit/package bridges. The
resulting `observed-table` rows use the native execution fingerprint and raw
manifest SHA. They express observed complete-command feedback, with transfer and
runtime effects already included. No separate DMA charge or prediction is added.

The original driver is then rerun with the same action generators and budgets,
using the observed table in place of the theoretical proposal model. Its beam
selection may change with the measurements. A candidate without an exact
observation has null cost; its count features cannot borrow another execution's
measurement. `search/search.json` preserves the resulting native archive, parent
chains, ranking, and selection history. This is a measured-feedback experiment,
separate from the frozen composite model's prediction/holdout evaluation.

The CPU contract test uses invented labels and placeholder AIR/ELF files solely
to exercise provenance rejection and the real driver feedback interface:

```sh
python taskflow/test/TaskflowModels/profiled_search_v9.py \
  --tool builds/taskflow-v9/core/tools/taskflow-opt/taskflow-opt \
  --proposals results/taskflow/ffn-profiling-v9/joint-profiled-search-proposals-r1 \
  --output .work/NEW_SYNTHETIC_TEST_DIRECTORY
```

Those8 passing contract checks are not hardware or calibration evidence. Actual
profiling feedback must cite the coordinator's compiled packages, raw outputs,
independent numerical audit and measurement boundary.

## Real observed-feedback replay and provenance checks

The eight scalar complete-program cases passed independent raw-output auditing:
3seeds ×12calls ×8candidates =288 complete Y outputs. SHA-bound compiled source,
full price-stripped plan, AIR metadata, ELF, runtime transfers and post-run physical
payload checks link them to the native proposals. Post-run resource checks are
reported as such, rather than described as checks saved before device execution.
The measured runtime identity explicitly binds the selected polling backend and
profiler/observer source; it is separate from the historical composite model's
unknown wait-backend identity.

`joint-profiled-search-measured-r2` replays that descriptor through the native
search driver with8 exact measured rows and1 capacity rejection. Every scored
response has `evaluation_kind: measured_feedback`, score provenance
`exact-observation-table`, `physical_hardware_measurement: true`, and
`executed: false`. The first flag describes the source of the score; the last says
this evaluation reused prior measurements and did not submit hardware. This is
not a model prediction or an additional device run.

The best observed median was18.5169675ms for tile8/32/32 with storage1 retained,
versus18.7181125ms for the phase-local tile8/64/32 baseline. This records the
observed ordering, not a statistically established speedup. Candidate IDs,
scores, action chains and ranking equal replay r1. The preserved r1 outer response
incorrectly labeled these scores as static estimates; r2 corrects that provenance
without changing measurements or selections.

`joint-profiled-search-checkpoint-r2` verifies a successful native checkpoint
resume and rejects four isolated mutations: evaluation kind, score provenance,
hardware measurement-source flag, and fresh-execution flag. The original
checkpoint remains byte-identical. All7 replay/metadata/preservation checks and
47 Core synthetic cost-contract checks passed. A separate real-feedback negative
control removes one exact observation key: the driver still generates that
candidate but returns null cost and excludes it from ranking. The corresponding
raw measurement remains preserved; this is a lookup negative control, not a new
prediction holdout.

The reusable checkpoint test is:

```sh
python taskflow/test/TaskflowModels/observed_checkpoint_v9.py \
  --tool builds/taskflow-v9/core/tools/taskflow-opt/taskflow-opt \
  --measured results/taskflow/ffn-profiling-v9/joint-profiled-search-measured-r2 \
  --output .work/NEW_CHECKPOINT_TEST_DIRECTORY
```

## Joint implementation proposals

`--implementation-proposals` adds native implementation actions for
`scalar-product-vector-add-f32` lanes8 and a lanes4 target-capability negative.
It deliberately uses an N32 phase-local root with the same computation, enabling
retention plus implementation to compose in two rounds. Starting from the old
N64 root would require three independent actions to reach N32 + retention +
mixed8; this experiment does not claim that three actions occurred in two rounds.
The seed choice and actual native parent chains are saved explicitly.

```sh
python taskflow/scripts/taskflow_profiled_search_v9.py \
  --tool builds/taskflow-v9/core/tools/taskflow-opt/taskflow-opt \
  --source /path/to/freshly/generated/source.mlir \
  --implementation-proposals \
  --scalar-proposals /path/to/prior/scalar/cases.json \
  --output results/taskflow/ffn-profiling-v9/NEW_IMPLEMENTATION_PROPOSALS
```

The initial run records13 legal native candidates. `all-cases.json` preserves
that full archive index. `cases.json` contains only two prescribed new compile
coordinates: N32 phase-local mixed8 and N32 storage1-panel mixed8.
`scalar-controls.json` bridges the corresponding scalar candidates to their prior
source bytes and native execution fingerprints. `selected-four-cases.json`
combines those two new mixed cases and two scalar controls for a same-condition
interleaved measurement. This fixed experiment selection does not replace native
beam selection or rank candidates in Python. Theoretical scores only order
proposals and do not predict the benefit of mixed execution.

The phase-local mixed candidate has the single implementation action; the panel
mixed candidate has a native panel action followed by implementation selection.
Initializer coverage remains scalar, while GEMM update and scale use the explicit
mixed8 implementation. Static DMA/payload are respectively188416/6144bytes for
phase-local and90112/18432bytes for the storage1 panel. The selected cases were
lowered with an already-built AIR tool, passed native canonical AIR checking,
and reproduced their Core semantic plans. No installed compilation or device run
is implied by those CPU gates.

`joint_mixed_indices_v9.py` independently checks the known fixture's emitted AIR
index SSA. It verifies A[i,k], C[i,j], scale indices, B[k,j] for phase-local, and
B[32×compactK+k,j] within the full-K retained panel. It checks ordered unit-step
K, all eight scalar-product lanes, vector addition, and absence of vector
multiply/reduction/FMA. Two address mutants are rejected. This is a test oracle
for the actual fixture, not production arithmetic matching or an installed-code
proof. The already-built backend checker remains a separate gate.

Old calls without the new flag retain their default N64 root and proposal
configuration. A CPU replay confirmed all eight original scalar candidate IDs,
source hashes, execution fingerprints, properties and action chains unchanged.
Mixed implementation timings need their own audited observations; scalar
composite coefficients do not score the new implementation automatically.

## Collect descriptors in a clean reproduction

`collect_direct_air_feedback_v9.py` produces the feedback descriptor from explicit
fresh paths; it contains no historical-directory fallback and does not call the
planner, compute medians, score candidates, or run a device:

```sh
python taskflow/scripts/collect_direct_air_feedback_v9.py \
  --proposal-cases GENERATED/selected-four-cases.json \
  --proposal-summary GENERATED/summary.json \
  --compiled-root COMPILED \
  --profile-directory PROFILE \
  --audit AUDIT/profile.json \
  --output NEW_DESCRIPTOR_DIRECTORY

python taskflow/scripts/taskflow_profiled_search_v9.py \
  --tool BUILDS/core/tools/taskflow-opt/taskflow-opt \
  --profile NEW_DESCRIPTOR_DIRECTORY/feedback-descriptor.json \
  --output NEW_MEASURED_SEARCH_DIRECTORY
```

`COMPILED/<candidate_id>` must retain source.mlir, plan.json, invocation.json and
hardware/{input.air.mlir,program.elf,compile.json,command.json,toolchain.json,abi.json}.
The native lowering binary named by invocation.json must remain available with
its recorded SHA. The collector binds this ORBIT lowerer identity as well as the
installed compiler version records. This prevents treating different native
lowerer versions as one observed toolchain merely because aircc versions match.

The collector verifies the entire experiment is numerically passed, exact
per-seed aggregate consistency, audit coverage for every seed/repeat/output,
output SHA records, candidate ELF identities and hot-sample counts. It checks
source bytes and the full price-stripped plan against proposals, AIR plan/body
attributes, compile-record AIR/ELF hashes and profiling invocation AIR/ELF/ABI
hashes. It requires the supported recorded complete-command wall boundary,
archived profiler source hash, recorded runner hash, and an actually selected
wait backend. Missing/unknown selection is rejected rather than inferred from
polling source code. These are provenance checks; independent raw-array numerical
recomputation remains the auditor's responsibility.

A target context is derived from the recorded aircc `--device`, common compiler
flags and versions, ORBIT lowering-tool SHA, observer, profiler, runner, and actual
wait-backend source identity. Its opaque context digest identifies recorded
software/compile conditions. It does not attest a physical device serial number,
clock or unrecorded host conditions. Cases with incompatible recorded compile
contexts require separate tables. The output includes feedback-descriptor.json,
feedback-target.json and collection.json. The subsequent `--profile` command
independently rebuilds native execution identities before it aggregates labels
and hands the observed table to the original driver.

The real eight-candidate scalar dataset passed collection and native consumption;
its candidate IDs, exact observed medians and ranking matched the earlier manually
assembled descriptor. Eleven CPU checks cover real recollection and missing/
duplicate raw checks, incorrect seed/hot counts, mismatched ELF identity,
unselected wait, runner/wait mismatch, changed profiler, wrong wall boundary and
missing recorded target device. These tests and descriptor collection do not
constitute additional device execution.

## Four-case implementation feedback

The fresh interleaved four-case experiment passed144 complete Y-output checks.
Its collected descriptor is replayed in `joint-implementation-measured-r1`.
The native theoretical proposal model gave scalar and mixed8 identical scores at
each fixed structure/residency coordinate; it did not predict their measured
implementation difference:

| N32 complete-program coordinate | Uncalibrated proposal score (ms) | Observed hot median (ms) |
|---|---:|---:|
| phase-local scalar | 0.6451776 | 18.7227735 |
| phase-local mixed8 | 0.6451776 | 17.2885385 |
| storage1-panel scalar | 0.6353472 | 18.6508700 |
| storage1-panel mixed8 | 0.6353472 | 17.1367475 |

Those medians are exact observed feedback, not calibrated predictions. The
implementation difference is clear in this experiment; the approximately0.15ms
mixed residency difference is smaller than some observed variation and is not
claimed as a separately established causal residency benefit.

The measured driver reaches the mixed panel candidate in two rounds through
implementation8 followed by panel retention. The proposal run first discovered
the same candidate through retention then implementation; both histories are
preserved, with identical materialized source/execution identity. Native beam
selection changes with the measured scores, so the measured replay contains
4scored candidates,7native unknown/null candidates and3unsupported candidates.
Of the original13legal proposal candidates,2are not revisited because their
parents were not scored/selected in the measured replay. `proposal-coverage.json`
explicitly records those2as not visited with null cost; it does not pretend they
were rescored. Only the4observed candidates enter the ranking. Successful resume,
metadata checks and four checkpoint provenance mutations again passed all7tests.
Collector identity/count/runtime negatives passed on this real four-case dataset
as well. These CPU replays add no device execution.

The final collector also opens `invocation.cases_path` and verifies
`cases_sha256`. It matches every executed case to its recorded ABI and normalizes
static, intermediate/scratch, output and per-call input indices. It derives the
warmup-before-hot state from actual per-seed sample histories, rather than assuming
that a configured warmup happened. The canonical per-case contract is hashed into
`target.runtime`, and the cases file and normalized policies are retained in the
collection evidence. Thus static-BO preparation changes cannot silently reuse the
same runtime identity. These are existing host-runner BO preparation conditions;
they do not imply on-chip retention or a physical cache measurement.

The four-case final recollection is `feedback-joint-implementation-r2`: all four
cases have static_indices=[], intermediate_indices=[3], output_indices=[2], with
warmups preceding all labeled hot calls. `joint-implementation-measured-r2`
replays this stricter identity with unchanged candidate scores, ranking and action
chains. Fourteen collector CPU checks include case-list SHA tampering, static-BO
strategy identity sensitivity and canonical index ordering; seven checkpoint
checks again pass. The earlier r1 descriptors and results remain unchanged. No
new device execution or frozen-model refitting occurred.
