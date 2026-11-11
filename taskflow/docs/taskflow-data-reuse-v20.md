> Publication snapshot of `results/taskflow/data-reuse-v20/RESULTS.md`. Relative experiment paths refer to that ignored local result directory. Raw observations, frozen tools and failed attempts remain unchanged locally. The v21 report records the v20 numerical erratum.

# ORBIT v20: data-region reuse, subgraphs and compatible tiling

The requested first graph-optimization step is implemented in C++/MLIR and
executed on the NPU. Actual region/version demands now seed bounded consumer
subgraphs and compatible tiles through restricted joint enumeration and legality
screening; v20 is not a general tiling-constraint solver. The original structured search materializes and
scores them, and the existing AIR/AIE backend realizes the same checked graph.
Two arithmetic dependency structures plus an explicit pure-order variant pass
396 real calls / 792 complete output arrays. No commit or push was performed.

Architecture and intake answers are in
[`taskflow-data-reuse-v20.md`](../../../../orbit/docs/taskflow-data-reuse-v20.md)
(absolute workspace path `/home/shiran/project/orbit/docs/taskflow-data-reuse-v20.md`).
Exact selected paths and tool identities are recorded in DELIVERY.json;
REPRODUCE.md provides fresh CPU/generation/NPU entries.

## Public implementation

`GenericReuseOpportunity` identifies logical storage, exact source rectangle,
version, producer and consumers. `GenericReuseProposal` carries the existing
ProgramMappingChoice and tile sizes, plus diagnostic derivation. There is no
parallel graph, scheduler, Python decision engine, e-graph or MILP.

Dependency-path closure and a quotient DAG establish legal contraction. The
execution order changes without renumbering source tasks or replacing bodies.
Source and actual implementation data/control relationships remain checked.
Internal whole-task pure-order barriers reject; external ones survive ordering.
Matching identity-grid access regions propagate a common tile. The existing
planner checks capacities, copy lifetimes, boundary exports, stream limits and
implementation support on each jointly materialized candidate.

`retainedStorages` now also expresses an immutable external input shared by at
least two group readers. First import is retained, later equal-rectangle imports
are omitted. All readers use one public copy/allocation and actual local buffer.
The original ABI allocation remains; inputs are not exported. Exact unequal
rectangles reject. Last-reader waits protect refill/overwrite. Outside consumers
and caller outputs retain required exports.

The new automatic policy is explicit: `algorithm=data-reuse-joint`; compatibility
default `v19-contiguous` remains available. max_joint_proposals/max_joint_tiles
are configurable1..64 (defaults8/4); experiments use32/4. The bounded trial pool
is at most max(16,proposals×tiles×4). Scope round-robin preserves consumer scope
coverage before extra tile variants. `pareto-audit-r1.json` enumerates the emitted
non-dominated profiles and distinct tiles, coverage, payloads, bytes, transfers
and configuration counts. This is a finite frontier, not a global optimality
claim. Full ProgramTiming remains the objective.

This borrows connection/compatible-tile propagation and capacity/traffic screening
ideas from [Welder §3, Figure7](https://www.usenix.org/system/files/osdi23-shi.pdf).
It retains ProgramGraph and the existing scheduler, assumes neither GPU memory
layer independence nor traffic-equivalent execution time, and supports exact
rectangular identity grids rather than general tensor-expression propagation.

## Cases and executable plans

All primary arrays are17×136 FP32. The payload budget stays24576B. Program1 is
`X=A+1; V=2D; Y=X+A; Z=X-1; O=Y+Z; H=V+3`, outputs O,H. Program2 is
`Y=A+1; U=D+3; Z=2A; O=Y+Z`, outputs O,U. Independent interleaving differs from
data/control dependence. Both programs also have a second legal source ordering;
semantic opportunity signatures (storage/region/version/producer/consumers)
match. These are real arithmetic task bodies, not metadata-only fixtures.

| Requirement | Evidence |
|---|---|
| A: noncontinuous legal subset | Source tasks{0,2} and{1,5}, without unrelated interlopers; source/permuted C++ checks |
| B: capacity feedback | Original12×136 fits materialized19584B but four-buffer residence needs26112B and rejects;6×136 admits13056B |
| C: multiple readers/boundary | Partial{0,2} exports X for outside task3; expanded{0,2,3} eliminates X boundary; both actual NPU outputs pass |
| D: shared external input | A shared by X/Y, and input-only{0,2} scope in program2; once-per-block import, all readers and cyclic release checked |
| E: independent opportunities | Search archives one X scope, one V→H scope and their combination, evaluated as complete programs |
| Pure order | Variant declares V→Y without reading V; selected{0,2} executes task1 first; actual AIR/AIE and36 NPU calls pass |

Program1 joint winner is source8b1e18da1b66…: first-round16c34d349703…
(0.752164ms) and641c43c0ac…(0.756504ms) are score-selected parents; round2
actually expands them and creates the winner with chain
`reuse_joint_13 → reuse_joint_10`. Its scopes are{0,2,3}, retaining A/X, and{1,5},
retaining V. Task identity stays bound to the original body. The scope emits Y/Z
for the external join; X and V do not need host boundaries.

| Program1 representative | Tile | Configurations | Deliveries | Requested B | Local peak B | Host allocation B | Estimate ms |
|---|---|---:|---:|---:|---:|---:|---:|
| Baseline |12×136|12|28|129472|19584|73984|0.950720|
| v19 best |12×136|12|28|129472|19584|73984|0.950720|
| Fixed tile, two scopes |12×136|8|20|92480|19584|64736|0.749728|
| Reuse first |6×136|8|30|92480|13056|64736|0.752164|
| Joint, two scopes |6×136|6|24|73984|13056|55488|0.650668|
| Partial X scope |12×136|10|24|110976|19584|73984|0.850224|
| V→H scope only |12×136|10|24|110976|19584|64736|0.850224|

Host allocation is a conservative policy accounting quantity, not measured RAM
or device traffic. Local tensor payload excludes separately emitted stack/runtime
reservations. Requested bytes are descriptor/region facts, not measured DDR.
Detailed physical copy and event example: CONCRETE-PLAN.md and concrete-plans-r1.json.

## Four algorithm comparisons

Same sources, target, precision, nine explicit cost assumptions, beam2, two
rounds,96-evaluation maximum. Fixed tiling uses new reuse scopes at the original
tile. Reuse-first selects a scope at its current tile or a feasible capacity
repair, then tunes tiling; repaired scopes are not deliberately excluded. It
does not add a second independent reuse scope after selecting its first scope.
Joint proposes coupled scope/tile changes and scope expansion/composition at
each selected parent. v19 uses its original contiguous-interval generator.

| Program | Policy | Priced legal | Valid unknown | Rejected proposals | Distinct plan signatures | Search s | AIE compiles during search | Best estimate ms |
|---|---|---:|---:|---:|---:|---:|---:|---:|
|1|v19|12|3|24|4|4.820|0|0.950720|
|1|fixed tiling|6|0|13|6|0.860|0|0.749728|
|1|reuse first|13|0|8|13|5.406|0|0.752164|
|1|joint|54|0|17|54|14.366|0|0.650668|
|2|v19|12|3|15|4|2.981|0|0.694752|
|2|fixed tiling|2|0|4|2|0.297|0|0.604504|
|2|reuse first|11|0|4|11|3.085|0|0.594792|
|2|joint|24|0|5|24|5.866|0|0.594792|

Search times measure the initial search command; checkpoint revalidation is
separate and currently repeats proposal planning per child, which is expensive.
Counts are budgets actually consumed, not padded candidate lists. Unknown costs
are valid unpriced plans, not illegal plans. `comparison-r2/comparison.json`
originally calls priced rows legal_candidates; the immutable counts-audit.json
explicitly supplies both categories without amending the original report.

Plan signatures normalize chosen allocations/copies/events/regions/resources
within the same source, removing proposal/price/source-identity noise. They are
planned physical organizations, not a claim that all archives were compiled.
Joint has50 and20 such signatures absent from v19 in these bounded searches.
The main agent compiles10 primary packages, covering every policy's distinct
best source plus mechanisms; actual final-AIE structure yields6 distinct
program1 and3 distinct program2 operation structures. Baseline and v19 best in
program1 have identical actual operation structure. An eleventh pure-order
package independently checks the additional ordering requirement.

Program2 honestly reaches the **same source** for joint and reuse-first; their
best actual compile is reused, and v19 best equals baseline there. This reflects
the dependency structure and finite two-round neighborhood, not hidden speedup.
Evidence proves expanded executable search space, not globally optimal search.

All8 searches pass exact resume, unchanged feedback, forged action-chain and
changed-target rejection. Both joint strict runs execute two exploratory rounds
with unknown scores and no absolute ranking. Full source, mappings, graphs,
scores, requested choices, rejected reasons and parent actions are archived.

## Actual implementation and real observations

All11 primary/supplemental packages pass C++ actual-AIR/final-AIE checking and
complete search/Core/AIR plan correspondence. Checking inspects arithmetic DAG,
addresses, tails, ABI, buffers, streams, BDs, lock releases and runtime causal
coverage. Source/graph ID equality alone is not its proof.

The two shared-input packages each pass23 generic AIE negatives plus2 targeted
external-input negatives. Source roles and actual multi-phase loads select A's
real SSA buffer/free lock; rebinding the later reader to another equal-typed
buffer, and moving free release before its final reader, both reject. Tiny
input-only AIR canonical plus8 actual negatives pass. Core shared-input25 checks
include missing/duplicate delivery, version/copy identity and overwrite waits.
Unequal rectangles reject; failed draft and corrected guard proof both remain.

All device calls are main-agent-only, sequential under `/tmp/npu.lock`, with a
120-second outer process timeout. Three seeds, one warmup and five retained
repeats per seed yield15 retained samples per plan/process. Inputs match across
candidates; order alternates forward/reverse. BOs and all contexts are prepared;
raw inputs/outputs/FP32 and FP64 references plus API/poll events are retained.

| Program1 plan | Session1 median ms | Session2 median ms |
|---|---:|---:|
|Baseline|1.026174|1.010924|
|v19 best|1.077772|0.998655|
|Fixed tiling|0.839958|0.802070|
|Reuse first|0.836448|0.828439|
|Joint|0.772270|0.718251|
|Partial boundary|0.885157|0.880457|
|Independent scope|0.880137|0.887118|

Program2 baseline medians are0.741641/0.778091ms, fixed-input-sharing
0.672423/0.705082ms, and the shared joint/reuse-first source0.694253/0.688232ms.
Joint and sequential are not measured twice under different labels.

Program1 joint-minus-baseline paired median is−256.194µs [−331.791,−188.595]
then−274.073µs [−299.343,−251.903]. These bootstrap95% intervals are descriptive
within a process session, not independent-day guarantees. The benefit is observed
in both sessions. Fine ranking remains uncertified: e.g. program2's predicted
9.712µs fixed-versus-reuse-first preference is not reliably resolved. Identical
actual baseline/v19 operation structures also show different context/session
host timing. No coefficients are fitted or samples removed.

The primary two studies total360 calls/720 arrays; pure-order adds36/72;
**396/792 all pass**, max absolute FP32 reference error2.384185791015625e−7.
All complete outputs also pass independent unrounded FP64 at original finite
atol=rtol1e−5. Audits report full mean/median/p05/p95/raw distributions and paired
comparisons. Physical DMA/core duration, real overlap and actual DDR bytes remain
unknown. See observation-*-audit-r1 and visualizations-r1/npu-distributions.svg.

## Regressions, provenance and limits

Core42 groups pass, including reuse16/shared-input25, prior target44/scoped45,
timing83/mechanism19 and search/checkpoint/public Amoeba contracts. Clean combined
coverage is59 groups. The final clean replay selects immutable current Core/AIR
tools; original Neura/CGRA contracts use the explicitly preserved historical
optimizer, not a freshly rebuilt one. Final receipt paths are in DELIVERY.json.

Preserved failures include the old v19 expectation that a now-supported convex
noncontinuous group must reject; an early malformed unequal-region fixture;
an interrupted pre-final CPU search; and lit's initial discovery of7 input
fixtures without RUN lines. The latter is repaired by the existing explicit
fixture-exclusion convention; the real fixture harnesses still execute them.
No negative check is bypassed. Source review includes all new and modified source,
not the user's unrelated untracked docs/presentations directory.

Limits: exact static identity grids, scalar pointwise lowering, unique writers,
no in-place/reduction/nonidentity general propagation, no grouped pure-order
barrier weakening, no arbitrary multilevel-memory lowering, one selected scope
per storage, single-core target-supported memory/streams, finite proposal/beam
budgets. Original tiling/residency actions and strict cost semantics remain.
Only graph optimization was broadened; general fine-performance ranking and
multi-core execution are not certified.

## Documentation erratum — 2026-11-07

The previous aggregate FP32 maximum1.1920928955078125e−7 omitted the larger
shared-input-program maximum2.384185791015625e−7. DELIVERY.json and both saved
shared-input audit sessions already contained the latter. Independent v21
recomputation of all396 calls/792 full arrays confirms the correction without
changing inputs, outputs, tolerances, protocols or any observation. The original
report is preserved at `../data-reuse-v21/intake-r1/v20-RESULTS-before-erratum.md`;
the raw verification is `../data-reuse-v21/independent-v20-numerics-r1/summary.json`.
The wording above also clarifies v20's restricted enumeration/legality-screening
scope. Its old reuse-first baseline freezes organization after its first round
and therefore does not provide the strong multi-group sequential control required
for attributing a joint-decision advantage. v21 addresses that experimental gap.
