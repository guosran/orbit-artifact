# Public Taskflow source transformation review

This record covers the source fission, domain partition/replica, counter
normalization and source-action search changes. It does not certify complete
Qwen coverage or physical NPU placement. Neura is the Amoeba CGRA adapter;
AIR/AIE is a separate adapter.

## Correctness fixes included

- Fusion followed by fission, tiling or independent-domain replication accepts
  unused read-completion results only when the yield exactly forwards the
  corresponding original read arguments. Used completions become a real
  read-completion barrier over actual reader tokens and a checked write anchor;
  source replay authenticates that no original read obligation was dropped.
- Source interval partitioning proves actual same-coordinate loads/stores,
  including exact same-root in-place updates. Unknown aliases and shifted
  accesses reject. Outermost recurrence intervals pass actual final state to
  the next task; independent replica creation cannot duplicate that recurrence.
- Multi-output interval/replica materialization retains every declared write
  state and creates a checked join for each output. Public counter/loop bodies
  prove selected actual stores, yielded roots and optional legacy witnesses.
- Replica-instance fission/tiling preserve the same resource obligation;
  same-instance fusion requires identical placement and replica choices.
  Nonzero source interval bounds and externally used final carries survive
  fission, with each recurrence SCC kept in one stage. Identity and invariant
  transitions preserve their actual seed/evolution. Exact-coordinate in-place
  cuts retain real incoming versions and RAW/WAR/WAW dependencies.
- Structured conditionals remain indivisible fission nodes with their implicit
  captures treated as real DFG edges. Unknown effects or hidden output aliases
  reject rather than dropping control or reordering effects.
- Replica instances carry an explicit independent-resource obligation. Fusion,
  fission and tiling cannot silently discard or merge that obligation. The
  AIR adapter checks actual target placement. Nested creation retains the root
  contract and appends explicit source ownership levels; the physical checker
  requires real disjoint target subdomains, not distinct string identifiers.
- Fission replay authenticates derived stages by replaying previous actions;
  metadata alone cannot authorize an alleged derived source. Unused stage read
  inputs are removed without weakening output ownership or recurrence checks.
- Counter normalization preserves actual scalar operations and structured
  control. SCF iter_args preserve lexicographic recurrence; cross-task scalar
  values become real single-element stores/loads and memory-state dependencies.
  Triangular bounds clone at their actual loop depth. Last-iteration outputs
  remain separate from next recurrence state, including empty-domain undefined
  behavior. Source/physical witnesses remain independently replayed.
- Deferred plans specialize checked actual invocation parameters before ordered
  source-action replay and normalization. A different runtime scalar or memory
  shape fails the dispatch guard; no assumed dynamic extent becomes authority.
- Canonical N-D placement survives source transformations and replay serde.
  Legacy 2D shape actions cannot silently flatten a higher-dimensional choice.
- Unknown, timeout and missing cost observations are never assigned zero cost
  or retained as scored search survivors. Deterministic unsupported cases are
  cached distinctly from runtime unknown observations.
- Shape names and geometry are validated, callbacks cannot mutate read-only
  candidates, and source-search publication rejects config/dependency drift and
  creation of an already-existing output directory.

The integration cross-review found and corrected the P1 issues recorded below.
The final fixed source-pipeline P1 also passed its approved bounded regression
in full and Neura-disabled configurations after the two root causes were fixed.
Test/build results are recorded by the integrating parent; this statement is
not an independent whole-repository audit.

## Integration review against the distilled guidance

The applicable guidance is
[review-guidelines-from-guosran-prs.md](review-guidelines-from-guosran-prs.md).
The checks below concern this unification delta; the earlier repository audit
and sealed comment collection remain separate records. No `code-review`
`SKILL.md` was available in the installed skill directories for this pass;
these are explicit manual and agent reviews, not a claimed execution of that
missing skill.

| Guidance | Corrected integration issue | Meaningful verification |
| --- | --- | --- |
| R1, R3 | Sibling fusion deduplicated read states without deduplicating their original-memory summary | Matching state/summary assertion and 61-check public fusion suite |
| R1, R3 | **P1:** oversized external replica integers reached an unchecked 64-bit conversion | Exact i64 schema guard before conversion; i128 count validator/materializer negative |
| R1, R3 | **P1:** normalized join coverage checked stores but did not bind the actual yielded completion to the declared output storage | Yielding a same-typed input rejects; a compatible cast of the correct output remains valid |
| R1, R3 | Resident partial writes cleared other disjoint regions; allocation facts described a reused slot | Normalized three-part source maps successfully; forged reusable-slot addressing rejects |
| R2, R3, R6 | Source replicas could otherwise be mistaken for physically concurrent AIR execution | Actual target-domain hierarchy, concrete leaf owner and whole-graph physical checks |
| R3, R4 | A complete anchored source pipeline was nested under another module manager and silently skipped | Actual tile→normalize→map→AIR source pipeline contract |
| R3, R6 | Final AIE checker omitted repeated runtime BD runs and did not authenticate repeated length against sizes | Actual compiled descriptor plus nine count/length/dimension/address mutations |
| R3, R4 | Fusion read-completion results blocked safe follow-on transforms | Fusion→fission/tiling/replica replay; actual reader barriers preserve used WAR obligations |
| R1, R3 | Nested join attributes could be accepted without independently authenticating child coverage | Parent-only verifier recursively checks actual leaves; forged child coverage rejects |
| R3, R4 | A recurrence composition interpreter omitted carry-free affine suffixes | Execute actual affine and SCF loops; compare eight true scan results after tiling/fission |
| R5, R7, R11 | Configured costs, unimplemented placement and experimental measurements could be confused | Explicit unknown capability, phase timing, exact source/target identity and separate artifact receipts |
| R1, R3 | **P1:** physical native projection filtered cross-owner dependencies although overwrite/read-before-reuse obligations were not all separate order edges | Preserve every mapped native dependency; require a single compute consumer for each data edge |
| R1, R3 | **P1:** shape expansion kept old ordinal source-policy bindings | Authenticate source replay, project every descendant's tile/implementation/init/group choices, then refresh the existing binding |
| R1, R3 | **P1:** explicit boundary export/reload was rejected by the ordinary phase-local import rule | Boundary-only BO lifecycle path preserves actual versions, routes, byte counts, write exports and read/prefetch ancestry; full and Neura-disabled boundary coverage passes 15 checks |
| R1, R3, R6 | **P1:** final AIE checking confused selected event-copy slices with inactive pool inventory | Check exact pre-canonicalization AIR selection; actual wave-zero positive and missing-active-view-tag negative pass while active payload/owner/alias proof remains strict |
| R3, R4 | **P1:** copying parsed evaluator JSON after erase hit a local LLVM DenseMap tombstone-copy crash | Independent LLVM repro exits 139; build fresh owned filtered evaluator fields and retain original target receipt/config bytes |
| R3, R4 | **P1:** generic CLI fallback received raw public counters and could not score a baseline | Normalize the actual source and verify its witness before generic planning; approved full/Neura-disabled fixed regression passes with a scored best |
| R10 | New public APIs and integration needed consistent presentation | LLVM clang-format over changed C++ files, contract comments and `git diff --check` |

No P0 was identified in this targeted pass. The corrected correctness issues
are included in their owning feature's final state; they do not require separate
fix PRs. Remaining capability and proposal-quality limits below stay visible.

## Completed validation

- Full configuration (AIR, Neura and optional solvers enabled) and a separate
  AIR configuration with Neura and optional solvers disabled build successfully.
  This earlier full/off checkpoint passed the public source contracts. The
  expanded fusion suite subsequently passed 61 checks; proof services passed
  18 and task-local tiling passed 24. Later abstraction additions are tracked
  by their focused results below, rather than attributed to the earlier build.
- After the completion-storage fix, normalization's forged-input negative and
  compatible-output-cast positive pass in both configurations. The actual
  source→normalize→map→AIR CLI contract also passes in both configurations.
- The repeated runtime DMA proof passes one actual descriptor and nine forged
  descriptors. Existing AIE semantic regressions pass all 13 cases. The final
  checker, including the completion-storage fix, accepts all four existing
  physical implementations without another device submission.
- Four already compiled pointwise implementations (`Y=(X+X)*(X+X)`, FP32
  64×64) each execute three independent inputs on the NPU: 12/12 agree exactly
  with CPU references (`max_abs=0`, `normalized_l2=0`). Each input uses one
  submission and zero warmups. This establishes correctness for this workload,
  not Qwen coverage, general placement or a performance improvement.
- The latest recurrence-composition binary executes actual normalized affine
  and SCF loops and passes scan, triangular bounds, identity/invariant carries,
  distinct last-result and tiled in-place WAR checks. Public fission and tiling
  pass. The integrating parent also reports physical graph 15 checks, hierarchy
  8, generic carry 6, specialization 24, deferred plan 20 and state 26 passing.
- The source `shape=2x2` whole-program path compiles to four waves and passes
  final AIE checking. Three actual inputs execute 12 NPU submissions with
  `max_abs=0`; all waves use the same BO and only the first input is copied
  host→device. The receipt is `orbit-artifact`'s `shape2x2-r2`. This validates
  this complete pointwise graph and its transfers, without a speedup claim.
- The state `shape=2x2` path additionally passes three sequential calls on
  the same BO for each of three inputs: nine calls and 36 submissions, all
  `max_abs=0`. State transfers initially once; later calls consume the actual
  prior result. Neura source-domain replay regression also passes (separate
  Amoeba CGRA adapter, not the AIE backend).
- Wave 11 passes source-mapping-actions, source-actions and source-search
  contracts, including controlled source-binding refresh after authenticated
  replica replay and complete descendant policy projection. Placement-only
  edits refresh existing bindings; structural actions do not grant one.
- The cross-core same-BO path passes six NPU submissions across three inputs
  with `max_abs=0` and no intermediate host staging between waves.
- Wave 14 passes 22 native policy→physical-ledger projection checks, including
  real same-instance fission stages, task-local tiles, retained state/cut copies,
  per-task implementations and complete source-group→owner-scope projection.
  Source-policy projection and actual AIR placement contracts also pass,
  including an eight-instance policy-shape source. The policy `shape=2x2`
  path then passes eight waves over three inputs: 24 actual NPU submissions,
  all `max_abs=0`, using the same BO without intermediate uploads. The current
  eight-case board campaign totals 147 correct submissions. These are numeric
  correctness checks, without a search or speedup claim.
- New current board receipts pass `three-row-r4` (seven waves, 21 submits),
  `multidfg-shape2x2-r3` (two DFGs, eight instances/waves, 24 submits) and
  `replica-shape1x2-r1` (nested two replicas × shape 1×2, 12 submits).
  All eight current cases have `max_abs=0`, zero warmups and same-BO execution
  without private host staging. Historical three-row-r1's 18 submits are not
  counted again. Shape/nested `r2` replace the earlier receipts in the current
  total. The latest selected-AIE recheck passes all 41 current waves with
  immutable source/target/final-AIE SHA identities verified and zero additional
  NPU submissions.
- The selected-pool AIE checker rebuild passes in full and Neura-disabled
  configurations. One actual wave-zero selection passes; removing an active
  view tag fails with the specific checker diagnostic. Selected active payload,
  ownership and alias checks remain strict; inactive inventory is not required
  to impersonate an executed selection.
- Approved fixed-pipeline debugging completes two rounds, at most 24
  candidates and beam width three in both full and Neura-disabled builds;
  both regressions exit zero with a scored best, preserved target receipt
  bytes and an existing-output negative. Placed alternatives remain explicitly
  unpriced, have no estimated milliseconds and make no physical-execution
  claim. These tests submit no NPU work and do not resume performance search.
- LLVM format passes all 111 changed C++/header files. Latest full and
  Neura-disabled focused runs pass boundary coverage (15), physical mapping
  (16), native projection (22), public multi-output/noalias partition contracts
  and AIR multi-DFG source contracts. The fixed
  source-pipeline regression now passes in both builds after the approved
  bounded debugging run. Final full and Neura-disabled aggregate runs both
  exit zero, including all agreed fixed-pipeline/AIR contracts. The rebuilt
  tool passes all 41 current AIE waves again with zero device submissions;
  LLVM dry-format passes all 111 changed C++/header files. No integration
  P0/P1 remains open.
  Experimental runtime/adapters
  and raw receipts live in `orbit-artifact`. Search/performance campaigns
  remain paused.

## Remaining work and lower-priority issues

- **P2 / fission proposal quality:** large-DFG proposals use structural resource
  counts and unique live-value traffic. They do not yet consume real mapper
  pressure/II feedback, and bounded exploration is explicitly incomplete.
- **P2 / cut-buffer implementation:** source fission still materializes complete
  static counter-domain tensors. Tile-local buffers, on-chip storage selection
  and lifetime reuse require target lowering and graph-level decisions.
- **Capability boundary:** source interval partitioning covers canonical
  same-coordinate domains and serial outermost recurrence intervals. Permuted
  output coordinates and numeric reductions need their own explicit proofs.
  Dynamic plans bind guarded actual arguments before static partition replay;
  no unspecialized symbolic interval-join claim is made.
- **Resource boundary:** cross-instance fusion cannot erase distinct source
  instance obligations. Nested independent replicas now carry an explicit
  hierarchy; same-instance transformations preserve each level's count rather
  than treating stage count as resources. Arbitrary backend topologies still
  need actual resource-domain support; source metadata cannot create it.
- **Boundary data organization:** the fallback with an explicitly selected
  boundary BO now emits actual per-write exports and later matching imports in
  the existing version/copy ledger. It does not pretend local values survive a
  configuration boundary or replace an explicitly chosen native retained scope.
  Its full and Neura-disabled focused coverage passes 15 checks; the separate
  fixed source-pipeline failure still blocks final aggregate completion.
- **Multi-output backend boundary:** public partition/replica coverage does not
  certify physical multi-output AIE execution. `ProgramGraphAIRSelection`'s
  transfer-isolation contract currently permits at most one host-output event
  per configuration. A compute with multiple live local outputs may have no
  safe cut; the backend must provide its own proof or explicitly reject it.
- **Backend capability boundary:** independent source replicas alone do not
  prove simultaneous placement, DMA capacity or backend concurrency. The AIR
  adapter now supplies actual hierarchy/placement/wave checks for its supported
  target domain; it does not establish exhaustive physical-domain search.
- **Deferred search optimization:** current source beam retains priced states;
  richer diversity/exploration allocation and live persistent checkpoint resume
  are not completed by the source-action serializer alone. The CLI adapter
  explicitly rejects its unsupported resume/checkpoint route.
