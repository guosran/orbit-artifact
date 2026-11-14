# Final Taskflow source and runtime PR plan

The base is `6302bbde073c6e7c3ecd700d36a38904ac9418b9`. This plan covers the
current compiler delta, including the new state, specialization, deferred-plan,
placement and AIR/AIE work. Experimental workloads, evaluators, board receipts
and presentation environments belong in `orbit-artifact` and are pushed there
directly; they do not become compiler PRs. Search-performance work remains paused.

Each PR contains the final implementation, comments and meaningful tests for
its feature. There is no separate P1/fix PR. Public source semantics land before
their backend adapters switch. Neura is the Amoeba CGRA adapter; AIR/AIE is an
independent backend. This is a measured split plan, not a claim that sixteen
individually buildable PR branches have already been created.

## Measurement and hard limit

The snapshot uses `git diff --numstat` for tracked files and actual line counts
for untracked compiler/test files. A new file contributes every line; deleting
an old backend implementation still contributes its deleted lines. Counts are
**added plus deleted**, never net growth. Binary artifacts and unrelated
`docs/presentations` files are excluded rather than silently counted as code.

Shared CMake and `tools/taskflow-opt/taskflow-opt.cpp` currently contribute 496
lines. Every feature takes its own registration/CLI/test hunks; these are
covered by the per-row reserve below. `Search.cpp` is split 247 lines for
source-owned policies and 19 for source-driver integration. Before publication,
measure the actual parent-relative branch including shared hunks and docs.
**Every PR must remain below 2,000 added+deleted lines.** The planned ceilings
leave room below that hard limit; a 1,000-line target is used where the feature
size allows it.

| PR | Final feature and primary dependency | Measured feature footprint | Planned ceiling |
| --- | --- | ---: | ---: |
| 1 | Public iteration facts, graph legality and output proof services | 1,264 | 1,400 |
| 2 | Public interval/replica materialization, nested ownership and recursively checked WAR/write joins; after 1 | 1,704 | 1,925 |
| 3 | Public multistage DFG fission, whole-SCC recurrence, atomic control and exact-coordinate RMW; after 2 | 1,793 | 1,925 |
| 4 | Neura tiling/fission adapters and removal of redundant implementations; after 2–3 | 1,569 | 1,750 |
| 5 | Public producer/consumer and sibling fusion with completed legality; after 2–3 | 1,676 | 1,825 |
| 6 | Neura fusion adapter and removal of redundant backend implementation; after 5 | 1,219 | 1,350 |
| 7 | Source-owned N-D placement, per-task tiles and source-derived policy domains | 1,065 | 1,275 |
| 8 | Actual counter/control/recurrence normalization, final-iteration values and real scalar spills; after 3, 7 | 1,657 | 1,850 |
| 9 | Transactional compound actions, source-bound native policies and composition tests; after 5, 7–8 | 1,446 | 1,700 |
| 10 | Neura consumes public facts/actions and source-derived legal domains; after 9 | 1,367 | 1,525 |
| 11 | Public source beam, N-D replay serde, driver and CLI binding; after 9 | 1,563 | 1,825 |
| 12 | Persistent state roles, cross-call physical handoffs and owned sequence checking | 970 | 1,150 |
| 13 | Actual-argument specialization, deferred actions and owned invocation dispatch; after 8–9, 11–12 | 935 | 1,350 |
| 14 | Authoritative physical graph, event/wave transforms and actual nested owner-set proof; after 2, 7, 12 | 1,456 | 1,750 |
| 15 | Native tile/residency/implementation policy→physical ledger bridge and authenticated replica policy projection; after 8–9, 14 | 1,645 at this snapshot | 1,850 |
| 16 | AIR/AIE complete-source replica lowering, physical coordinates, waves and final AIE checks; after 8, 13–15 | 1,691 at this snapshot | 1,850 |

The large public fission/fusion implementations already exceed 1,000 lines by
themselves. Splitting their algorithms into temporary incomplete revisions
would make review harder. Their old backend deletions are separate completed
adapter migrations so neither side exceeds the 2,000-line limit.

## Exact ownership of shared or large features

- **PR 1:** `SourceIterationDomain.h`, `GraphRewriteLegality.h`,
  `OutputCoordinateProof` changes, `proof-services.cpp`, and the 112-line graph
  optimizer design. Neura forwarding headers wait for PR 10, which has the
  public action types those wrappers consume.
- **PR 2:** full `TaskflowTiling`/`TaskflowReplica` headers and sources, their
  direct tests and public-factor fixture; the full current `TaskflowOps.cpp`
  delta, including actual yield-root binding, public read barriers and checked
  static affine/SCF rectangles. Multi-output state/update domains retain every
  child output and prove a separate actual-store/yield/root join for each slot.
  Nested joins prove actual child coverage and
  roots recursively; replica paths do not authorize a forged interval. Resource
  count denotes instances, not the number of tasks in an instance. The Neura
  tile removal moves to PR 4 so this feature stays within the hard limit.
- **PR 3:** full `TaskflowFission` API/implementation, direct fission test,
  fanout fixture and the existing source/multi-output fixture deltas. Nonzero
  bounds, whole recurrence SCC ownership and final-carry forwarding are part
  of this final implementation. Identity/invariant carries, distinct final
  hyperblock results and real in-place RAW/WAR/WAW ordering are included. The
  normalization composition test lands with
  PR 8 because it needs that API, rather than as a later correctness fix.
- **PR 4:** old fission pass removal (1,155 changed lines), its 70-line
  legacy-header adapter change and the 344-line Neura tile migration.
  **PR 6** similarly owns the 1,219-line fusion
  adapter/removal delta. Both keep the historical CLI and compile their actual
  backend target against the public implementation.
- **PR 5:** full public fusion implementation/header and direct fusion tests.
  In the current 376-line `source-fusion.cpp`, the 184-line compound-action
  section at lines 105–288 belongs to PR 9; the remaining 192 lines form the
  direct API test. Remove its unused `SourceActions` include until that section
  lands. This is a feature/test split, not a postponed fix.
- **PR 7:** `TaskPlacement`, `TaskTiling`, current
  generic-mapping/heterogeneous/native policy changes, the `GenericAnalysis.h`
  role/loop facts, task-tile tests and policy hunks from `Search.cpp`. The source
  driver include/dispatch remains with PR 11 so this branch has no future driver
  dependency. N-D geometry remains explicit and target realization is checked.
- **PR 8:** complete normalization API/source/test, scan composition interpreter
  and recurrence fixture; generic carry analysis/test, communication resident
  update fixes, AIE descriptor-repeat proof and its mutation test. The scalar
  transfer is an actual one-element memory store/load outside its source loop,
  not repeated source computation or a free scalar edge. Counter-dependent
  triangular bounds clone at their real depth. Last-iteration outputs use real
  SCF state separate from recurrence next-state; empty-domain undefined values
  use poison, never a fabricated recurrence seed. Numeric composition tests
  exercise identity/invariant carries, nonzero lowers and tiled in-place WAR.
- **PR 9:** `SourceActions` and `SourceMappingActions`, mapping-action tests and
  compound fusion/partition tests. Its source-action test first covers canonical
  N-D materialization/replay; the roughly 15-line serde-specific test addition
  and `SourceSearch` include wait for PR 11. No materializer implementation is
  weakened in the earlier PR.
- **PR 10:** Neura source-iteration and graph-legality forwarding headers,
  neighborhood action/search/replay adapters, analytical-cost inheritance,
  replica/K-reduction consumers, `NeuraBackend.cpp`, and the source-domain
  regression script. The large 617- and 210-line header migrations count here.
- **PR 11:** complete `SourceSearch`/`SourceSearchDriver`, engine tests, replay
  serde additions, source pipeline contract and 126-line search documentation.
  Preserve all dimensions through action replay and JSON; do not interpret the
  legacy 1x1 projection of an N-D choice as a physical 1x1 implementation.
- **PR 12:** `ProgramMapping.h` sequence API, `ProgramStateSequence.cpp`,
  sequence/state tests, state-role use in the existing graph, cost and AIR graph
  consumers. Its `ProgramDataOrganization.cpp` allocation is only the 24-line
  state-role delta; the explicit boundary organization feature belongs to PR 14. State remains one actual
  logical host root; copy/launch costs stay on the executed graph.
- **PR 13:** full `TaskflowSpecialization`, `TaskflowDeferredPlan` and
  `TaskflowInvocation` APIs/sources and tests. Add the owning invocation test
  and actual-profile CLI hunks from this row's reserve. The actual owning
  invocation assertions are already in `taskflow-specialization.cpp` and are
  included in the measured footprint. A runtime mismatch
  rejects before backend submission; the sequence owns every borrowed IR graph.
- **PR 14:** `ProgramPhysicalMapping.cpp`, `ProgramReplicaPlacement`,
  `ProgramEventTransform.cpp` and physical/representation/hierarchy tests.
  Replica sibling scopes are unions of their actual resource owners, checked
  pairwise for ancestry and coordinate aliases; a shared LCA does not imply
  overlapping disjoint leaf sets. All stages of one leaf instance share its
  concrete owner. Event reorder and invocation waves preserve actual
  source/transfer dependencies, including sorting permuted instances by their
  actual event indices. The reverse-independent-partition test lands here.
  The completed optional boundary organization feature also belongs here:
  the 141-line added-plus-deleted `ProgramDataOrganization.cpp` increment,
  boundary declarations/scaffolding in `ProgramNativeProjection.h` (19 lines),
  and actual fanout/state export→evict→reload and lifecycle/prefetch negatives
  in `program-representation-coverage.cpp`. Native retained scopes are not
  converted into this fallback. The physical API hunks
  in `ProgramMapping.h` and checker call in `ProgramGraph.cpp` land here; the
  state-specific hunks stay with PR 12, with their full-file counts already
  covered by that row. Do not land a checker call before its implementation.
- **PR 15:** `ProgramNativeProjection` and `NPUShapePolicyProjection` headers
  and sources, `program-native-projection.cpp` and `source-policy-projection.cpp`.
  Native tiling/residency/implementation/init decisions generate one complete
  instance/version/copy/slot ledger. Projection retains actual dependencies,
  reindexes every authenticated descendant and refreshes existing source-bound
  policies only after rewrite and ordinal proofs. It neither applies old task
  zero choices to only the first child nor creates a shadow physical graph.
  All bridge-specific positive and mutation tests, the integrated review,
  readiness record and this measured split plan land in this feature PR.
  The 17-line native dispatch/source-binding hunk of `ProgramPhysicalMapping.cpp`
  and remaining nine native declarations in `ProgramNativeProjection.h` land
  here, so PR 14 never calls a future native bridge implementation.
- **PR 16:** `NPUIndependentShards`, `NPUShardsAIE`, `NPUPhysicalProgram.h`,
  `NPUPhysicalProgram.cpp`,
  `ProgramGraphAIE` checker changes, `aie_selected_pools.py` (48 lines),
  both pointwise fixtures, source-replica
  placement test. The adapter lowers
  the authoritative complete physical graph; it does not preserve the old
  isolated-child/shadow-ledger path. Real chip→column→tile hierarchy and
  four-wave execution are part of the completed implementation. Sequential
  stages do not multiply replica resource counts. Board receipts remain
  artifacts, separate from compiler tests. If final adapter growth exceeds
  the reserve, split whole-graph lowering and invocation-wave/final-AIE
  features, each with its actual focused tests; never split out correctness
  fixes or temporarily retain the rejected isolation algorithm.

## Publication checks

For each proposed parent-relative branch, run `git diff --numstat <parent>...HEAD`
and sum added+deleted including new files, tests, docs and shared registrations.
Do not publish if the result reaches 2,000. If a reserve is exceeded, split an
independent completed feature and its tests; do not move required P0/P1 fixes
into a later PR. Re-measure PRs 15–16 after the final bridge and complete-source
adapter tests settle. This snapshot counts its current implementation;
planned deletion is not subtracted from the review budget in advance. This
snapshot measures complete source files and their focused tests, not promised
future reductions.

Each public feature must build and pass its focused contracts with Neura off;
adapter PRs also build their backend. The actual branch must not depend on a
factory, header or test registered only in a later PR. The final aggregate suite
and actual AIE receipts are evidence for the integrated result, not a substitute
for these per-PR builds. No PRs or commits are created by this planning step.
