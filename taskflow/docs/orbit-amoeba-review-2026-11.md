# ORBIT additions relative to Amoeba: review and cleanup

Review source: `e850af2ae623f00c64e18aab772496e7776a2f76`.
Primary Amoeba baseline: `a57376e7043b1681e64e7169c5a8cb02eb192331`, as
declared by `UPSTREAM_PROVENANCE.json`. Secondary current-upstream comparison:
`74621b75a979ed4519f771ceea437132b528411b`. These repositories have independent
published histories; there is **no Git merge base**. Comparisons use tree diffs.

The original rename-aware tree diff contains 890 records, 259,751 added and
25,782 deleted lines. Expanding its two rename records gives 892 actual paths. It includes publication/layout changes and inherited vendor code.
Neura is compared separately against `2c8f524f81135d50bcce507ec1599a264aa03571`:
95 of its 100 tracked files are byte-identical inherited files; five contain
local changes. Inherited code is not counted as ORBIT-authored review coverage.

The requested exact `code-review` skill was unavailable locally. The review
used the installed `requesting-code-review` workflow and `review-agent`
instructions: fresh independent reviewers, pinned revisions, source/caller/test
inspection, reproduced findings and priority-based fixes. The second pass used
all R1–R12 from [the distilled guosran review rules](review-guidelines-from-guosran-prs.md).
No GitHub review history was recollected or replaced.

[Per-path coverage](orbit-amoeba-review-coverage.jsonl) and
[disposition/migration inventory](orbit-amoeba-migration-manifest.jsonl) cover
917 canonical paths at the final code snapshot. ORBIT-added/changed production
implementations and relevant build/API deltas were read, including explicit
complementary ranges for the large replica and neighborhood files. Test records
distinguish full fixture/helper review from focused invocation/assertion review
and structural inventory; they do not claim exhaustive review of every test
body. Historical documents received inventory and claim-boundary checks, not a
new validation of every historical measurement. The inventory predates these
review-maintenance documents to avoid self-referential size accounting.

## Confirmed P1 corrections

No P0 has been established. The entries below identify independent failure
mechanisms; several share one implementation and regression suite.

| ID | Original failure and consequence | Correction / regression |
|---|---|---|
| P1-01 | `execute-heterogeneous.py` unloads BO/context owners after an unresolved native wait; an active command may retain them. | Drain terminal commands, quarantine the complete prepared owner graph otherwise, forbid reuse; failure/start/interrupt/state tests. |
| P1-02 | Qwen source identity omits `config.py`; RMS epsilon or helper semantics can change while the handwritten graph is reused. | Bind configuration and approved full-module semantic ASTs; recheck runtime files; configuration/helper/import mutations. |
| P1-03 | Loop perfection sinks unconditional effects into a dynamic or zero-trip inner loop, deleting their execution. | Require proven positive trip counts for every crossed loop; dynamic, empty and nonempty controls. |
| P1-04 | Parallel K splitting accepts multiplicative/non-additive accumulation; an input can change from 32 to 2. | Prove the exact additive recurrence, operands, indices, bounds, overflow promises and closed effects. |
| P1-05 | Sequential feedback K splitting ignores aliasing auxiliary reads; reblocking changes read/write order. | Prove every auxiliary root distinct from output before reblocking. |
| P1-06 | In-place M/N splitting ignores auxiliary aliases; private-output shortcuts also admit views of the output itself. | Shared distinct-storage proof for every read root; aliasing-view and valid private-allocation controls. |
| P1-07 | Presence-only `amoeba.noalias` checks treat `false` and malformed attributes as proofs. | One typed predicate accepts UnitAttr or BoolAttr(true); migrate actual proof consumers. |
| P1-08 | Retained producer/consumer fusion misses a root used as producer input and consumer output. | Compare cross-role memory effects before interleaving task firings. |
| P1-09 | M/N splitting resets scalar kernel-carried state on each shard. | Reject unproved carried state; retain stateless predicate-Phi support. |
| P1-10 | Terminal hyperblock replication resets prefix/scalar-carried state. | Reject unproved hyperblock iter_args/results. |
| P1-11 | Exact-score local and peer caches omit the network override: a 130-cycle slow network reuses a 6-cycle fast-network result. | Bind effective selection/full bytes in v2 score/frontier keys; validate peer selection, bytes and input stability, including incumbent proof caches. |
| P1-12 | Active-transfer analysis inspects only the first opaque-call memory operand; `B[3]` reads can receive a proven `[1]` transfer shape. | Audit all memory operands/results and reject unproved effects/roots. |
| P1-13 | Ordinary caller noalias import ignores address-taking/indirect target calls and certifies aliasing arguments. | Share complete symbol-use validation with prepared-mode proof. |
| P1-14 | Ray fission checks store operands but ignores affine maps; `[1-row]` scratch writes are read back as `[row]`. | Require supported identity load/store maps and typed noalias evidence. |
| P1-15 | Host lowering reads only the first two operands of variadic `neura.phi`; a valid third arm's store disappears. | Fold every arm with first-valid precedence; explicit third-arm store regression. |
| P1-16 | AIE arithmetic checking omits predicates, fastmath properties and result types; ReLU OGT→OLT is accepted. | Compare complete normalized numerical signatures; predicate/flags/type mutations and metadata-positive controls. |
| P1-17 | Recursive AIE walks accept all core work under `scf.if false`, despite no executed input/output work. | Validate the supported unconditional CFG and bounded loop multiplicity; conditional/CFG/side-effect negatives. |
| P1-18 | Generic semantic fusion forwards intermediate loads at different coordinates and can erase caller-visible intermediate writes. | Require exact forwarding coordinates, private unobserved storage, closed effects and supported state. |
| P1-19 | Generic semantic tiling infers disjoint outputs from counter ranges despite repeated writes to `out[0,0]`; source 12345678 becomes 12563478. | Require per-firing output ownership, authenticated local read/modify/write and closed effects. |
| P1-20 | Global ranking admits `valid=false` rows with empty schedules, ranks one first and emits `stage_certified=true`; normal mode also lacks cross-variant provenance binding. | Validate every admitted row and its command/catalogue, model/feature and effective network domain before certification. |
| P1-21 | A disjoint write removes a still-live writer/reader frontier: `p:a[0]`, `q:a[1]`, `r:read a[0]` loses p→r RAW. | Keep uncovered region frontiers, including local RMW read obligations; test RAW/WAW/WAR and disjoint controls. |
| P1-22 | Radar replication certifies disjoint output shards despite an unrecognized whole-buffer `memref.copy` in each clone. | Close the memory-effect proof before publishing independent output ownership. |
| P1-23 | Failed aggregate replica geometry retries its own temporary release events forever, even with finite fixed-point limits. | Retry only real baseline releases or communication readiness; terminate failed geometry with a diagnostic. |
| P1-24 | Radar completion joins assume canonical output order while source `done_writes` can swap typed results, rebinding a downstream consumer to the wrong buffer. | Authenticate source completion values in ABI order before replication; distinct-output and swapped-yield controls. |

Legality changes share rewrite contract v9 across closure and neighborhood
checkpoint binding. Pre-fix continuation state cannot certify the new search.
Historical source/receipt IDs retain their original bytes and acceptance scope.

## Remaining findings

These are recorded follow-up work, not silently treated as fixed. Priorities
reflect observed impact in the supported input/API described below.

| ID | Priority | Location / concrete trigger | Required follow-up |
|---|---|---|---|
| B01 | P2 | `ProgramResourceSchedule.cpp`: reversed groups with a declared dependency are accepted; group and implementation dependency vectors are ignored. | Authenticate dependency order in the public scheduler and checker. |
| B02 | P2 | `ProgramDataOrganization.cpp`: valid `memref<index>` reaches unguarded `getIntOrFloatBitWidth()` and asserts. | Define target index width or reject unknown width without aborting. |
| B03 | P2 | `ProgramBeamSearch.cpp`: duplicate warm-start compatibility work takes 2.531 s under a 0.2 s deadline before any callback. | Bound/deduplicate bootstrap work and check the deadline there. |
| B04 | P2 | `GenericReuse.cpp`: current tile `{0,1,1}` with divisibility checking reaches modulo zero after detecting the invalid tile. | Stop invalid input before arithmetic; add an API boundary regression. |
| B05 | P2 | Native transform/group metadata narrows an `i128` IntegerAttr through `getInt()` and asserts. | Check integer widths before narrowing in group/residency/lineage readers. |
| B06 | P2 | `ProgramAllSearch.cpp`: unreachable destination in a complete ten-memory graph traverses failed simple paths for 5.814 s, despite route limit 1 and 0.02 s budget. | Bound attempted path expansions and integrate deadline cancellation. |
| B07 | P2 | `StaticMapper.cpp` / `StaticChecker.cpp`: resources a/b share one capacity-1 resource but both schedule at 0..1. | Expand shared-resource reservations in mapping and independent validation. |
| B08 | P2 | `ProgramAllSearch.cpp`: native-composite search's own best candidate fails public replay because derived invocation receipts are compared with a bare native mapping; provider reconstruction also differs. | Share provider-aware reconstruction and timing between evaluation and replay. |
| B09 | P2 | `RepairLuAffineDeterminantCarryPass.cpp`: a matching external function declaration aborts at `getArgument()`. | Reject declarations before body/argument inspection. |
| B10 | P2 | `audit-qwen-r19-ready.py`: no references means `all([])` can mark original-reference gates true. | Require explicit nonempty reference coverage for that gate. |
| B11 | P2 | `launch-observed-search.py`: synchronous/unpriced valid modes omit sidecars the launcher always requires. | Validate outputs according to the selected execution mode. |
| B12 | P2 | `program-operator-search.cpp`: save checks file opening but not flush/final state; ENOSPC can leave a truncated file with success. | Atomic checked output/checkpoint publication and failure injection. |
| B13 | P2 | `JointNeighborhoodSearchPass.cpp`: pause at debit 2 records `[1,2]`; resume to 4 replaces the trace with `[3,4]`. | Persist/reconstruct cumulative objective debit history on resume. |
| B14 | P2 | `ScoreAnalyticalTaskCandidatesPass.cpp`: `double(INT64_MAX)` rounds to 2^63; a duration of 2^63 is narrowed out of range and clamped to 1, yielding a certified two-cycle schedule. | Check the exclusive upper limit before conversion. |
| B15 | P2 | `EnumerateJointSemanticRewritePass.cpp`: fused parallel reducer ABI/manifest omits the E read present in its actual `add_E` body (six graph candidates). | Derive serialized read contracts from the materialized body and compare the complete ABI. |
| B16 | P2 | The same semantic enumerator calls `isBeforeInBlock` on producer/consumer tasks in different blocks; a verified multi-block source asserts. | Check same-block ownership before ordering, then reject unsupported CFG. |
| B17 | P2 | `GlobalStageRankerPass.cpp`: output/input alias checks omit architecture/facts and compare lexical paths, so an output can overwrite an input or a symlink/hardlink alias. | Protect every input by filesystem identity before publication. |
| B18 | P3 | Large multi-responsibility modules (neighborhood 10k lines, replicas 7k, scorer 6k) make independent changes hard to review. | Extract typed state, source proof, evaluation, persistence and reporting modules in the staged migration plan. |

Potential constant-folding/counter-predicate concerns without an established
supported-path reproduction are investigation notes, not confirmed findings.

## Distilled-rule application

| Rule | Result |
|---|---|
| R1 dependencies / alias / order | P1-03/05–10/13–15/17–19/21/22/24; B01/B07 remain. |
| R2 logical shape vs replicas | Scalar carry and source/output coordinate guards; shape/replica API checks reviewed. |
| R3 source → selected → executed | P1-02/12/16/17; native replay B08 recorded. |
| R4 producer / consumer / checker separation | Shared typed legality predicate; independent AIR numerical and CFG checks. |
| R5 unknown / observation boundaries | Unresolved XRT execution retains owners; B10/B12 remain explicit. |
| R6 capacity / conflict | Actual CFG and shared-root effects guarded; shared-resource B07 recorded. |
| R7 scalability / rollback / cache identity | P1-11/23, v9 continuation invalidation; B03/B06/B13 remain. |
| R8 ranking / regression | P1-20 normal/seed certification guards; whole-program prices bound to network; positive controls retained. |
| R9 constrained adversarial cases | CPU arithmetic, alias, carry, zero-trip, mutation and resume reproductions. |
| R10 types / comments / LLVM format | Added invariant comments and typed helpers; modified C++ uses clang-format LLVM style. |
| R11 scope of claims | Source review, CPU verification and historical board evidence are reported separately. |
| R12 traceability | Pinned baselines, per-path disposition, regression sources and archived pre-cleanup code. |

## Cleanup and verification

Removed 42 obsolete experimental paths (6,096 lines), the duplicate root
progress logs and the unreachable recursive closure traversal superseded by
BFS. The active r18-named runtime helpers, current receipt contracts and
meaningful fitter/campaign tests remain; those tests now use current v2 code.
The compiler's shared noalias predicate replaces duplicated unsafe proof logic.
See [archive preservation](orbit-review-20261113.md#archived-development-history).

Validation is CPU-only for this change. Fresh builds enable Neura, AIR,
OR-Tools and SCIP in an isolated build directory; focused negative and positive
regressions exercise each confirmed correction. Test counts and the feature-delivery policy are recorded in
[the PR plan](orbit-amoeba-pr-plan.md). The 22 review commits are development
history; each future feature PR carries its final corrections and tests.
Artifact material is committed and pushed directly to the companion repository.
The review does not claim a new NPU measurement or global solver optimum.

## Preserved evidence

The pre-cleanup tracked source snapshot is
`orbit-artifact/.work/source-snapshots/orbit-e850af2ae623-before-review-cleanup.tar.gz`
(relative to the common project parent), SHA-256
`d2ae22c18415512c2d02a976dae21dba87e3d30625bebd445aeaea4c11e4f38e`.
It preserves all 834 original tracked members; every archived member was checked.

CPU review evidence archive:
`orbit-artifact/.work/source-snapshots/orbit-amoeba-review-evidence-20261113-v2.tar.gz`.
SHA-256: `d6c8f84843233b9957263fde5a013f4ad20c7ca86aa952ae9482f1dcf73bb26b`.
All 9,095 members were read back and checked; the adjacent
`.tar.gz.manifest.json` lists individual file hashes.

The CPU archive includes text reproducers and commands, independent findings,
original coverage ledgers, the source patch and final integration logs. Earlier
reproductions establish pre-fix failures; the final logs record the rebuilt
post-fix tools. The archive metadata binds their SHA-256 values. Compiled binaries,
large generated data and unrelated historical campaigns are excluded explicitly.
Current regression drivers and fixtures are versioned with each fix; remaining
B01–B18 use the concrete reproductions recorded in the archived review ledgers.
The final code commit is `2043e8ea32d4fc8a2b53560013ebe65000a194fd`; subsequent
commits add only review records and migration planning.
