# Taskflow unification PR plan

This plan covers the current Taskflow unification delta relative to
`6302bbde073c6e7c3ecd700d36a38904ac9418b9`. It does not turn every older ORBIT
artifact or already-reviewed feature into a new PR. Search optimization and new
performance campaigns are paused. The existing implementation and its
correctness fixes remain in this series.

Each PR must contain the final implementation of its feature, comments and
relevant tests. No fix-only PR is planned. Public implementations land before
their Neura adapters switch; removing the old backend implementation is itself
the completed adapter migration. Neura targets Amoeba CGRA. AIR/AIE is an
independent physical backend.

## Proposed dependency order

Counts below are added plus deleted lines in the current working delta, grouped
by files before distributing shared CMake/CLI hunks and composition tests.
The final PR budgets reserve room for those hunks. These are measured planning
inputs, not claims that eleven separately built PR branches already exist.

| PR | Completed feature | Current file footprint | Final budget |
| --- | --- | ---: | ---: |
| 1 | Public source iteration facts, graph legality, context-owned output proof service | 1,124 | 1,300 |
| 2 | Public DFG fission and multistage replay | 1,503 | 1,650 |
| 3 | Neura fission adapter; remove its redundant implementation | 1,241 | 1,350 |
| 4 | Public source tiling and independent replicas; Neura tiling adapter | 1,208 | 1,400 |
| 5 | Public producer/consumer and sibling fusion, basic legality tests | 1,480 before test split | 1,800 |
| 6 | Neura fusion adapter; remove its redundant implementation | 1,219 | 1,350 |
| 7 | Checked counter normalization, resident partial writes and AIR/AIE transfer validation | 677 before shared mapping hunks | 1,000 |
| 8 | Task-local tile selection consumed by mapping, projection and replay | 712 | 950 |
| 9 | Transactional compound actions, source-bound native policies and composition tests | 1,279 before test split | 1,500 |
| 10 | Neura consumes public facts/actions; source-derived factors and target shapes | 1,367 | 1,550 |
| 11 | Public source beam and CLI integration, identity and diagnostic reporting | 1,516 | 1,750 |

All budgets are below 2,000 lines. A 1,000-line target is practical for PRs 7–8;
the complete fission and fusion implementations are already larger than that.
Splitting their logic across artificial files would make review harder.

## Shared files and build dependencies

- PR 1 adds `SourceIterationDomain.h`, `GraphRewriteLegality.h` and the proof
  service changes. Neura forwarding aliases are deferred to PR 10, where their
  public action-type dependency is available.
- PRs 2–6 own the matching `TaskflowFission`, `TaskflowTiling`, `TaskflowReplica`
  and `TaskflowFusion` APIs, implementation files and adapter changes. PR 5
  includes the basic direct-API assertions from `source-fusion.cpp`; PR 9 adds
  its compound replay and fusion→fission/tiling/replica assertions after
  `SourceActions` exists. These are distinct feature tests, not later fixes.
- PR 7 owns resident partial-write/addressing hunks in `GenericMapping.cpp`
  and `GenericCommunication.cpp`, normalized join-region proof in
  `TaskflowOps.cpp`, normalization CLI flags, and the actual repeated-DMA
  byte/address proof plus forged-descriptor tests in `AIEImplementation.cpp`.
- PR 8 owns `TaskTiling`, the remaining task-local tile hunks in mapping,
  heterogeneous projection, initializer reindexing and `Search.cpp`.
  The `SourceSearchDriver` include/dispatch hunk in `Search.cpp` belongs to
  PR 11, so PR 8 builds without a future driver.
- PR 9 owns `SourceActions` and `SourceMappingActions`; it depends on PRs 1–8.
  PR 10 can then replace Neura action structures with public aliases and
  migrate its source-domain helpers without a forward dependency.
- Each feature takes its own library registration, link dependency and test
  target hunks from `lib/Taskflow/CMakeLists.txt` and
  `tools/taskflow-opt/CMakeLists.txt`. PR 11 receives only the remaining beam
  and driver registrations. The whole final CMake diff must not land early.
- Documentation and review findings accompany the owning feature. Source
  search integration documentation accompanies PR 11.

Before opening each PR, build its actual parent-relative branch and measure
`git diff --numstat <parent>...HEAD`; reject a split whose added+deleted total
reaches 2,000. If a budget is exceeded, move an independent completed feature
and its tests into another PR rather than postponing its correctness fixes.

## Validation and artifact boundary

Public transforms and proof services must build and pass their focused tests
with Neura disabled. Adapter PRs also build `mlir-amoeba-opt` and run the related
Neura regression. PR 7 validates actual final AIE descriptors and mutations;
board correctness receipts are artifacts, not substitutes for compiler tests.
PRs 8–11 run their focused selection, replay, binding and CLI contracts.

Experimental Qwen evaluators, runtime variants, decoder adapters, raw results
and board receipts belong in `orbit-artifact`, committed and pushed directly
with an exact path allowlist. They do not consume compiler PR budgets. Existing
sealed receipts retain their original source and baseline identities.
