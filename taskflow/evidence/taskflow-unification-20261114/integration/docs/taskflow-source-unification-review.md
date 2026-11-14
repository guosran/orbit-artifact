# Public Taskflow source transformation review

This record covers the source fission, domain partition/replica, counter
normalization and source-action search changes. It does not certify complete
Qwen coverage or physical NPU placement. Neura is the Amoeba CGRA adapter;
AIR/AIE is a separate adapter.

## Correctness fixes included

- Fusion followed by fission, tiling or independent-domain replication accepts
  unused read-completion results only when the yield exactly forwards the
  corresponding original read arguments. Used completions remain unsupported;
  no WAR completion join is invented.
- Source interval partitioning checks actual pointwise loads/stores and rejects
  output feedback, hidden aliases, unknown effects and recurrence. Uneven
  intervals cover the source domain and preserve each iteration once.
- Replica instances carry an explicit independent-resource obligation. Fusion,
  fission and tiling cannot silently discard or merge that obligation. The
  generic AIR adapter rejects it until it has a checked physical implementation.
- Fission replay authenticates derived stages by replaying previous actions;
  metadata alone cannot authorize an alleged derived source. Unused stage read
  inputs are removed without weakening output ownership or recurrence checks.
- Counter normalization clones original scalar operations and access indices;
  a separately bound source/physical witness is independently replayed.
- Unknown, timeout and missing cost observations are never assigned zero cost
  or retained as scored search survivors. Deterministic unsupported cases are
  cached distinctly from runtime unknown observations.
- Shape names and geometry are validated, callbacks cannot mutate read-only
  candidates, and source-search publication rejects config/dependency drift and
  creation of an already-existing output directory.

The integration cross-review found and corrected the P1 completion-storage
binding issue recorded below. No further P0/P1 was found in the reviewed delta.
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
| R1, R3 | Sibling fusion deduplicated read states without deduplicating their original-memory summary | Matching state/summary assertion and 44-check public fusion suite |
| R1, R3 | **P1:** normalized join coverage checked stores but did not bind the actual yielded completion to the declared output storage | Yielding a same-typed input rejects; a compatible cast of the correct output remains valid |
| R1, R3 | Resident partial writes cleared other disjoint regions; allocation facts described a reused slot | Normalized three-part source maps successfully; forged reusable-slot addressing rejects |
| R2, R3, R6 | Source replicas could otherwise be mistaken for physically concurrent AIR execution | Direct planner/checker and source capability reject unsupported replica obligations |
| R3, R4 | A complete anchored source pipeline was nested under another module manager and silently skipped | Actual tile→normalize→map→AIR source pipeline contract |
| R3, R6 | Final AIE checker omitted repeated runtime BD runs and did not authenticate repeated length against sizes | Actual compiled descriptor plus nine count/length/dimension/address mutations |
| R3, R4 | Fusion read-completion results blocked safe follow-on transforms | Fusion→fission/tiling/replica compound replay; used or incorrectly bound completions reject |
| R5, R7, R11 | Configured costs, unimplemented placement and experimental measurements could be confused | Explicit unknown capability, phase timing, exact source/target identity and separate artifact receipts |
| R10 | New public APIs and integration needed consistent presentation | LLVM clang-format over changed C++ files, contract comments and `git diff --check` |

No P0 was identified in this targeted pass. The corrected correctness issues
are included in their owning feature's final state; they do not require separate
fix PRs. Remaining capability and proposal-quality limits below stay visible.

## Completed validation

- Full configuration (AIR, Neura and optional solvers enabled) and a separate
  AIR configuration with Neura and optional solvers disabled build successfully.
  Focused public fission, tiling, replica, fusion (44 checks), proof services
  (18 checks), task-local tiling (24 checks) and normalization tests pass.
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
- LLVM format validates all 60 changed C++ files; `git diff --check` passes.
  Experimental runtime/adapters and raw receipts live in `orbit-artifact`.
  Search/performance campaigns remain paused.

## Remaining work and lower-priority issues

- **P2 / fission proposal quality:** large-DFG proposals use structural resource
  counts and unique live-value traffic. They do not yet consume real mapper
  pressure/II feedback, and bounded exploration is explicitly incomplete.
- **P2 / cut-buffer implementation:** source fission still materializes complete
  static counter-domain tensors. Tile-local buffers, on-chip storage selection
  and lifetime reuse require target lowering and graph-level decisions.
- **Deferred capability:** source interval partitioning covers proven canonical
  pointwise domains. Permuted output coordinates, reductions, dynamic domains
  and cutting recurrence cycles need additional explicit proofs/lowerings.
- **Deferred composition:** applying fusion/fission/tiling to existing replica
  groups is rejected until group-resource obligations can be composed. Fusion
  before domain replication is supported and replay-tested.
- **Deferred physical implementation:** independent source replicas do not prove
  simultaneous placement, DMA resource capacity or backend concurrency. The
  separate NPU independent-shard helper explores a limited physical domain.
- **Deferred search optimization:** current source beam retains priced states;
  richer diversity/exploration allocation and live persistent checkpoint resume
  are not completed by the source-action serializer alone. The CLI adapter
  explicitly rejects its unsupported resume/checkpoint route.
