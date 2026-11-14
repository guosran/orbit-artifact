# Graph optimization after Taskflow unification

Status: proposed design, not an implemented replacement for beam. Performance
campaigns remain paused. This note audits the current representation rather
than certifying every source pattern or backend implementation.

## What the current abstraction covers

The representation consists of Taskflow source IR and the existing public
`ProgramGraph` in `ProgramMapping.h`. They have distinct roles: source IR
defines computation and dependence semantics; the graph records an execution
implementation, including data movement and invocation boundaries.

| Dimension | Existing representation | Current boundary |
| --- | --- | --- |
| Fusion/fission | Actual task DFGs, cut-value storage, whole recurrence SCCs, atomic structured conditionals and memory-version dependencies | Canonical same-coordinate in-place RMW and proved alias cases compose; arbitrary control/effects still require proof |
| Tiling/replica | Actual counter intervals, serial recurrence carry, nested source ownership and recursively checked completion joins | AIR realizes supported independent instances on real chip/column/tile domains and checked invocation waves; unsupported target topology rejects |
| Size/shape/placement | Canonical per-task N-D `orbit.placement`, source instance domains and concrete target coordinates | Legacy shape serde is a checked mirror; the normal AIR source path has compiled and executed 2x2 choices, without exhaustive physical-domain coverage |
| Spatial/temporal dataflow | Instances, data/order edges, resources, groups and schedule witnesses | These encode concrete static choices; arbitrary mappings are not all generated or physically proved |
| Residence | Versioned location copies, allocations, access requirements and lifetimes | No separate residence boolean; tile-local cut buffers and some cross-transform lifetimes remain incomplete |
| Multiple outputs | Public transforms preserve every write state and prove a separate actual-store/yield/root completion join | AIR transfer isolation currently allows at most one host-output event per configuration; multiple live local outputs may have no safe cut and must independently prove lowering or reject |
| CPU/NPU boundaries and launch | Execution regions, submit/complete/visibility events and explicit transfers | The boundary and its price are separate; unsupported or uncalibrated cost stays unknown |
| Dynamic control, recurrence and persistent state | Actual-depth counter bounds, SCF carry/last-result state, guarded actual-argument specialization, owned invocation sequences and one host state root | Three chained calls across three real inputs pass on NPU; general attention/KV-cache and arbitrary decode control remain unestablished |

The current physical checkpoint is concrete: the normal 2x2 pointwise path
compiled to four waves and passed 12 NPU submissions over three inputs. The
same-BO state path passed three chained calls per input across three inputs:
nine calls and 36 submissions, all with `max_abs=0`. The initial state transfers
once for the call chain. These are correctness receipts, not a speedup result;
search-performance work remains paused. Neura's source-domain replay regression
also passes, independently of the AIR/AIE adapter. A cross-core same-BO path
passes six submissions over three inputs without staging intermediate waves
through the host. The native-policy bridge separately passes 22 source/physical
projection checks and actual AIR emission contracts; its compiler evidence is
separate from those earlier device receipts. The policy 2x2 path subsequently
passes 24 real NPU submissions (eight waves over three inputs), with the same
BO and no intermediate uploads. All eight current board cases total 147 correct
submissions, excluding obsolete three-row receipts. The final current 41-wave
AIE recheck passes all waves with immutable source/target/final-AIE identities;
the aggregate remains blocked by the fixed source-pipeline
`std::bad_alloc` awaiting bounded-debugging authorization;
these device receipts do not certify arbitrary source patterns.

Thus the common vocabulary covers the requested static execution decisions,
but there is no proof that every desired combination has a canonical encoding,
legal materializer and backend realization. The next step must not promote an
unsupported implementation to a valid alternative merely because a field can
record it.

## Proposed replacement

Use cost-driven graph rewriting with shared alternatives and constrained
selection. Replace the beam frontier over whole-program action histories;
reuse public legality, materialization, checking and cost interfaces.

1. **Bind alternatives to stable source regions.** A region boundary identifies
   original operations, iteration domains, typed value/storage ports and
   dependence versions. Derivation and backend identity remain explicit.
   Ordinals and mutation-generated task names alone are not stable identities.
2. **Represent implementation choices once.** Share unchanged subgraphs and
   memoize alternative implementations of the same semantic region. Fusion,
   fission, domain partition, replica, placement and transfer choices each
   retain a proof/realization obligation. A fused operator graph need not imply
   one launch; a launch group need not imply an operator fusion.
3. **Generate legal graph rewrites.** Adapt existing checked public primitives
   first. Legality depends on the actual domain and memory effects. Shape and
   resource choices become properties of the selected region implementation,
   which projects to the existing public graph rather than a second ledger.
4. **Select with boundary state.** For a bounded region, retain alternatives
   conditional on interface layouts, copy locations, resource use, invocation
   grouping and relevant live-out lifetimes. Remove a dominated alternative
   only when its external obligations and future compatibility agree. Regions
   can merge or split; an initial partition is not a permanent fusion limit.
5. **Evaluate global consequences.** Rebuild/check the affected execution
   regions and schedule, including capacity, shared resources, RAW/WAR/WAW,
   transfers and launch counts. Invalidate all summaries affected by changed
   lifetimes or scheduling; a local edit may affect the whole program.
6. **Materialize a selected graph.** Replay its checked derivation to actual
   source, normalize, build/check the common execution graph and invoke the
   target compiler. Unknown implementation or cost remains explicit.

Boundary summaries are an engineering proposal, not a proved complete state
for arbitrary programs. If they cannot preserve a dependency or cost coupling,
expand the optimization region or retain the explicit coupling. Do not claim
global optimality for bounded regions or a pruned alternative set.

## Why a greedy rewrite pass is insufficient

Fusion may remove a launch but exceed SRAM; fission may add loads/stores while
making mapping feasible; a larger tile may change replica count and placement.
These decisions can require a temporarily worse intermediate graph. Greedily
accepting only local improvements cannot express that selection policy.

For pure, proven-equivalent compute regions, bounded e-graphs are an option for
sharing alternatives without choosing a rewrite order immediately. They are
not required for the first graph optimizer. Memory/state effects, floating-point
contracts and recurrence must remain part of equivalence proofs. Ordinary
expression extraction also does not solve shared-buffer lifetime, placement,
launch grouping or makespan constraints.

This separation follows the exploration/extraction distinction in
[TENSAT](https://proceedings.mlsys.org/paper_files/paper/2021/file/cc427d934a7f6c0663e5923f49eba531-Paper.pdf).
MLIR's [greedy pattern driver](https://mlir.llvm.org/docs/PatternRewriter/)
provides rewrite infrastructure, but its local pattern benefit is not ORBIT's
whole-program latency objective. Neither method guarantees that alternative
growth or constrained extraction will be inexpensive.

## Implementation order and acceptance

1. Add a representation coverage contract using one source with fanout,
   mutable-state ordering, a tiled/fissioned region, replicas, two resource
   placements, explicit copies and CPU/device launch boundaries. Test the
   supported parts and name any missing representation or backend proof. A
   rejected physical realization is not a representation-coverage pass.
2. Implement stable region interfaces and a shared alternative memo. Use
   existing checked transforms; test that different derivations deduplicate
   without merging different iteration domains or storage versions.
3. Implement boundary-conditioned selection and common-graph validation. On
   small finite cases compare with exhaustive enumeration as a correctness
   oracle; do not introduce a whole-Qwen global solver.
4. Add an opt-in graph-optimization driver; retain beam only for regression
   comparison until the replacement passes. Test a shared producer, a launch
   merge that exceeds capacity, a mapping enabled by fission, and distinct
   external lifetimes that must not be incorrectly dominated.
5. Only after correctness, compare graph construction/selection/compile time,
   peak memory, evaluated alternatives and final device performance on the
   same programs and numerical contracts. This performance stage remains
   paused until the user resumes it.

Source/hardware domains define legality. Node, region and work budgets control
exploration only; they must not become a new list of permitted tile/replica
factors. Report truncation, unknown observations and unsupported combinations.
