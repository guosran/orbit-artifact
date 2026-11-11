> Publication snapshot of `results/taskflow/data-reuse-v21/RESULTS.md`. Relative experiment paths refer to that ignored local result directory. Raw observations, frozen tools and failed attempts remain unchanged locally. The v21 report records the v20 numerical erratum.

# ORBIT v21: controlled reuse and tiling search

The study completes120 primary searches, six bounded exhaustive references,
32 actual implementations and1,224 locked NPU calls. The implementation is
C++/MLIR through the existing ProgramGraph, planner,
scheduler, structured search, AIR and AIE checks. No commit or push is performed.

## v20 erratum and evidence boundaries

The aggregate saved-output maximum FP32 error in v20 is
**2.384185791015625e-7**, rather than1.1920928955078125e-7. The independent audit
rechecked396 calls and792 complete arrays. `ERRATUM-v20.md`,
`erratum-receipt.json`, the intake copy of the original report and
`independent-v20-numerics-r2` preserve the correction and original raw evidence.
V20 implements restricted joint enumeration and legality screening, not a
general tiling constraint solver. Its old reuse-first policy does not add more
groups after its first round; that policy is retained as historical context.

## Frozen design and current implementation

`experiment-plan-r3/protocol.json` and its bindings precede every new NPU
observation. R1/r2 and the10.401s CPU-only5s deadline failure remain preserved.
R3 uniformly limits all new policies and both generators to256 exact source
compute instances before expensive planning; this is a search complexity domain,
not hardware illegality. Source programs, model, precision, capacity and16/32/64
raw-provider plus5/15s budgets are unchanged. No new hardware fitting is permitted.

The two v20 programs remain17×136; the third fixed program is23×152:
`X=A+1; V=2D; Y=2X; Z=Y+A; R=X-1; O=Z+R; H=V+3`, returningO,H.
It has multiple real reuse groups with differing buffer/boundary requirements
and nondivisible dimensions. It is retained regardless of which strategy wins.

Strong reuse-first chooses multiple groups and deterministic feasible repairs,
then freezes organization. Strong tile-first chooses a tile, freezes it, then
searches single/multiple organizations. Alternating uses fixed-tile reuse then
fixed-organization tiling for four stages. Joint changes one scope and tile
together, with scored beam expansion. `STRATEGIES.md` states the exact rules,
including the distinction between common native legal configurations and
different one-step neighborhoods: strong reuse can jump to a multi-group set;
joint uses a local group edit. This practical policy comparison cannot isolate
a universal benefit attributable to joint decisions alone.

`reachability-audit-r2` checks73,780 actual C++ admission edges and120 identical
pool comparisons. All four policies can reach every admitted legal configuration
within four rounds if beam/scores/budgets are ignored. Actual selected paths and
freezes omit candidates, recorded separately. For example, initial joint local
edits exclude128 coupling/new configurations, while strong reuse-first admits
multi-group configurations directly. These are explicit policy differences.

New tile origins are capacity boundaries, divisor/tail sizes, target alignment,
current neighbors and fallback halving. The capacity proof is a necessary
distinct-buffer payload lower bound; a small bound never certifies feasibility.
All admitted candidates pass the complete planner/checker. Hard alignment and
no-tail restrictions are explicit optimizer options. Nonmonotone occupancy is
not searched by an assumed monotone binary search. `algorithm-audit-r1` records
the proof, finite quotas, cache scope and a concrete omitted five-buffer8×152
boundary. The quota is not guaranteed to cover every organization's direct bound.

## A: admitted configuration space

All six small reference catalogues are complete over the enumerated bounded
scope/tile domain, and every admitted legal configuration is fully priced under
the unchanged assumed model. They are not all DAG subsets, all integer tiles,
or hardware global optima.

| Program | New legal configurations | Halving legal configurations | Common source configurations | New only | Halving only | New reference best, ms | Halving reference best, ms |
|---|---:|---:|---:|---:|---:|---:|---:|
| interleaved |144|78|30|114|48|0.524108|0.650668|
| shared-input |48|26|10|38|16|0.469132|0.586380|
| coupling |224|116|50|174|66|0.658236|0.781928|

The16-tile diversity quota replaces some old shapes. The new pool contains more
and different legal configurations and better reference estimates, but is not a
strict superset. These are checked source configurations; actual distinct
executions and hardware benefit are reported separately below.
Among the32 actually compiled and executed distinct AIE structures,16 belong
only to the new pool,14 to both pools and2 only to halving
(`actual-space-coverage-r1.json`). This proves additional executable choices for
the selected subset; it does not claim every catalogue row was hardware-tested.

## B: strategies within each common pool

The following are best assumed costs at a shared64-provider-call cap. Actual
usage can be lower when a frozen neighborhood is exhausted; this is reported
rather than padded with useless evaluations. Phase exclusions are archived.

| Program / generator | Strong reuse first | Strong tile first | Alternating | Joint | Bounded reference |
|---|---:|---:|---:|---:|---:|
| interleaved / new |0.589728|0.524108|0.524108|0.524108|0.524108|
| shared-input / new |0.484504|0.469132|0.469132|0.484504|0.469132|
| coupling / new |0.814344|0.658236|0.814344|0.746188|0.658236|
| interleaved / halving |0.650668|0.650668|0.650668|0.650668|0.650668|
| shared-input / halving |0.586380|0.594792|0.586380|0.586380|0.586380|
| coupling / halving |0.781928|0.782232|1.014344|0.781928|0.781928|

Joint improves on some frozen reuse-first decisions, ties some alternatives and
loses to strong tile-first or alternating elsewhere. There is no universal joint
winner. Decision quality depends on the candidate order, neighborhood and phase
freezes as well as the admitted domain.

## C: work and time controls

The72 fixed-cost runs and six offline references retain actual generation
attempts, internal planner/checker calls, score queries, raw cost-provider calls,
cache hits, compile counts and time. Each normal priced query invokes the
provider twice, including independent checker recomputation. Generation probes
are unpriced. The references'288/156,96/52 and448/232 cost calls are separate
offline work, never credited to the policies' budgets.

Cold reference generation performs168/102 planner calls for interleaved,
48/26 for shared-input and256/156 for coupling (new/halving). New generation does
more planner work; a larger archive alone would hide this difference. Its proven
capacity screens reject88/16/224 trials, while halving's common instance-domain
screen excludes112/28/240 tiny-tile trials. Cache tests demonstrate reuse and
invalidation, but cold process catalogue cache hits are zero; selected-candidate
planning and checkpoint revalidation remain charged, not claimed eliminated.

The optional four-round legacy extension exposes the old uncapped tiny-tile
path: about13GB of host residency and swap use are observed on this23GiB machine.
The first interleaved reuse-first run finishes after154.177s just before the
resource stop; the next has an incomplete checkpoint and no completed receipt.
Two remaining runs are unstarted. `matrix-historical-r1/RESOURCE-STOP.json`
preserves the exact process/checkpoint/memory state. This incomplete extension is
not presented as a completed four-run experiment or a fair budget baseline.
The successful original two-round legacy contracts and134 exact v20 comparisons
remain the historical control. The stronger v21 policies are not weakened.

All48 quiet-window wall-budget runs pass. `comparison-audit-r1` contains18
separate raw64/quiet5s/quiet15s curves and60 equal-actual-prefix comparisons,
using only the last observation at or before a common work/time prefix. Its127
completed-run audit includes126 primary/reference runs and the one completed
legacy extension:3,151 complete plan/graph comparisons have zero mismatches.
Every generator/program pool is identical across its21 new-policy/reference runs.
Nonexclusive fixed-cost-run elapsed curves remain descriptive.

Under the15s cap, joint and strong tile-first reach the same coupling/new
estimate0.658236ms, but joint uses276 provider calls and13.877s versus84 calls
and4.850s. At64 calls joint is worse (0.746188ms). Interleaved/new joint,
alternating and tile-first tie0.524108ms; shared-input/new they tie0.469132ms.
Strong reuse-first remains at0.589728 and0.484504 respectively. Additional budget
helps joint catch up in coupling; it is not evidence of better budget efficiency.
Caps, actual usage and phase-exhaustion stops are separate fields. Wall times
include generation, export and evaluation; nonpreemptive overshoot is retained.

## D: proposal quality and coupling

The new coupling reference contains22 legal organizations whose exact optimal
tiles differ between23×76 and23×38. The new generator also proposes the feasible
nonhalving10×152 capacity boundary. Fewer tails/configurations can outweigh fewer
tile instances or bytes; byte-only ordering is not the objective. The model's
best new tiles and expanded finite pool improve all three reference estimates.
This is evidence for proposal quality and organization-dependent tiling, not yet
a claim of faster hardware or faster search under every budget. In the16-call
pilot, new generation actually loses to halving (interleaved strong reuse first:
0.749728 versus0.650668ms); that result is preserved without tuning.
Under quiet5s caps, strong tile-first reaches0.524108/0.469132/0.658236ms
with new candidates versus0.650668/0.594792/0.782232ms with halving
(interleaved/shared-input/coupling). Actual new times are3.634/1.423/4.862s,
not uniformly shorter than halving3.327/1.363/4.526s. This is better estimated
quality within a common time cap, not an isolated faster-generator result: the
candidate spaces differ and some new optima are absent from the halving pool.

## Actual AIR/AIE and NPU observations

`experiment-plan-r3/hardware-selection.json` freezes all distinct final
winners across every primary budget, plus baseline and reference winners.
Canonical source and then actual AIE structure deduplicate implementations;
algorithm labels are aliases. Two fresh process sessions use identical inputs,
precision, tolerance and balanced ordering, with full saved outputs and independent
FP32/FP64 audits. Main alone executes under the existing lock. Repeated baseline
controls across context batches retain their same identity and are never used
as fake algorithm differences. No cross-batch paired comparison is made.

All32 source representatives compile and remain32 distinct actual AIE structures;
all complete searched/compiled graphs and priced plans are exactly equal.
There are252 aliases rather than252 repeated physical measurements. Selected
coupling/interleaved/shared-input packages pass48 actual negative rejections and
three canonical accepts. Caller-output missing-await and shared-input early-free
mutations are covered directly; tail/outside-export coverage also includes exact
canonical source/plan checks and complete numerical outputs, without claiming a
dedicated mutation for every possible violation.

Five batches, each observed in two fresh processes, execute**1,224 calls and
2,448 complete output arrays**. All pass independent finite FP32/FP64 oracles at
unchanged atol=rtol1e-5. Maximum absolute errors are
**2.980232238769531e-7** against stepwise FP32 and
**2.384185791015625e-7** against unrounded FP64. There are1,020 retained timings
and204 warmup calls. No new model fitting occurs. The observer owns the original
device lock, with120s outer timeouts; all10 processes complete successfully.

The following pre-hardware model-reference choices are also found by primary
policies. Static bytes are requested payload, not measured physical DDR traffic.

| Program | Tile: halving reference → new reference | Configurations | Requested bytes | Local peak bytes | Deliveries | Compute instances |
|---|---|---|---|---:|---:|---:|
| interleaved |6×136 →17×68|6 →3|73,984 →73,984|13,056 →18,496|24 →16|18 →12|
| shared-input |1×68 →17×68|3 →3|64,736 →64,736|1,088 →18,496|238 →14|136 →8|
| coupling |6×152 →23×38|6 →3|111,872 →111,872|14,592 →13,984|32 →32|28 →28|

Actual final AIE core counts change6→3 and static `aie.dma_bd` counts32→16
for interleaved and coupling. Shared-input remains3 cores/14 static BDs, despite
the public requested-delivery change238→14. Static descriptor counts, logical
deliveries, measured physical DMA traffic and elapsed device time are distinct.
`hardware-summary-r1.json` retains these facts for all32 implementations.

Each comparison below is paired within the same batch. Values are new minus
halving-reference host invocation time; intervals are conditional paired-median
bootstrap95%, not cross-day guarantees. All full distributions and samples are in
`npu-independent-audit-r1`, `npu-ranking-summary-r1` and the raw sessions.

| Program | Session1 paired median, us [interval] | Session2 paired median, us [interval] |
|---|---:|---:|
| interleaved |−148.147 [−261.454,−118.596]|−124.177 [−215.344,−94.318]|
| shared-input |+19.020 [−1.680,+71.278]|+70.527 [+35.068,+288.563]|
| coupling |−77.968 [−100.738,−38.480]|−73.549 [−83.938,−63.529]|

Thus the new shapes improve two programs relative to already optimized halving
references, through fewer configurations at unchanged requested bytes. The
shared-input new model winner does not improve: session1 is unresolved and
session2 is slower. Its fast1×68 halving-only alternative is an explicit example
of a useful measured tradeoff lost by the new finite quota. Do not tune it away
after observing hardware.

Against the original baseline, the new reference choices improve paired medians
by368.100/375.719us (interleaved),159.965/184.256us (shared-input), and
445.397/438.338us (coupling). These improvements do not establish their global
hardware optimality. Model-untied comparisons have three pairs with a resolved
wrong order and the same observed sign in both sessions (two interleaved, one
shared-input). Other pairs change order or remain unresolved; the full ranking
is not certified. Modeled differences within1e-12ms are ties, excluded from strict
sign statistics. Process repetition does not establish independent-day stability.

## Functional and historical regression evidence

`final-clean-regressions-r1` passes **Core44, combined61**, current and older AIR
contracts, preserved original Amoeba/Neura17 and CGRA8, and unfilteredlit35.
The immutable current Core is096c8ab54a8bdc44eeb746ff39c6587389289f2c266ca938bd8a0d016d699417;
AIR is36b3a26f83706ddb1e17af4f0a9cc360301f30fe4f8a4d0c28892cf7730af5e6.
The original Neura/CGRA optimizer is a preserved historical binary, not rebuilt.
All tool hashes remain unchanged during the clean replay.

The constraint unit passes175 checks. The new search contract passes28 including
multigroup baselines, exact cross-policy plans, phase carry/freeze, raw/internal
budgets, cache hits, strict unknown costs and checkpoint/prefix/action/target
guards. `legacy-compatibility-r1.json` passes eight historical policy/case runs
and134 exact complete plan/graph/score/action-chain comparisons with v20, without
normalization. The actual AIR pure-order check also passes. The old JSON crash,
strict-resume telemetry error and stale-object build race remain preserved.

`REPRODUCE.md` provides clean-shell builds, contracts, matrix, compile/freeze and
locked observation commands. `agents.md` and the v21 design document describe the
finite domain and evidence boundaries in English. The final source diff and
delivery manifest bind the completed report and artifacts. `source-diff-r1`
separates preexisting v20 changes from v21 changes; `source-completion-r1` records
the final companion scripts. The unrelated presentations directory is preserved.

## Attribution: what produced the observed gains?

**A — space:** the new finite pool adds legal and actually executed choices,
while replacing some old shapes; it is not a strict superset. **D — tile
generation:** source-domain/divisor/capacity candidates reduce configuration and
tail overhead and produce real paired improvements in two programs, with no
universal faster-search or hardware claim. New generation performs more planner
probes and loses a useful shared-input shape under its finite quota.

**C — budget:** identical caps, internal work counters, actual-prefix comparisons
and quiet wall runs expose rather than hide budget effects. More work helps joint
reach a coupling solution already reached by strong tile-first with much less
work. **B — joint decisions:** strong tile-first and alternating match or beat
joint across these programs; no exclusive or universal joint benefit is shown.
This experiment supports better candidate geometry and reveals policy freezing
effects, not a claim that joint decisions alone cause the improvements. Lower
estimated cost, a different executable plan, observed improvement and stable
ranking remain four distinct conclusions.
