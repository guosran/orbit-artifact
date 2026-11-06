> Publication snapshot of `results/taskflow/subgraph-execution-v19/RESULTS.md`. Experiment paths below are relative to that ignored local result directory. Frozen reports, raw observations, compiled artifacts and failures remain unchanged locally. See [results](taskflow-subgraph-execution-v19.md), [example](taskflow-subgraph-v19-example.md), and [reproduction](taskflow-subgraph-v19-reproduce.md).

# ORBIT v19: target-bound partial execution graphs

The complete source → original C++ search → checked public plan → AIR/AIE → actual outputs loop is implemented for the declared pointwise subset. The final eight-case generation and independent Core/AIR checks establish exact full-plan/full-graph correspondence. All eight execute correctly in two new-process NPU sessions. Fine performance ranking remains insufficiently reliable; the estimation-driven algorithm loop is enabled, but general performance search is not certified.

## Three audit defects and repairs

| v18 defect | v19 repair | Evidence |
|---|---|---|
| Public concrete NPU owner/capacity/port assumptions | Target domains, coordinates, resource and memory owners, directed links and explicit access; shared-resource demand closure; configurable target capabilities; native device/lifecycle separated. Backend explicitly rejects unsupported owner/position/kind. | target-binding-audit-r1; target binding44 checks |
| Complete-program-only resident task group and global retained list | Structured residency_groups / resolved scopes; partial and multiple disjoint groups, per-region versions/copies, required boundary export, final-output retention and per-input release contract. | subgraph45 checks; final compiled8 plans |
| Fixed diamond checker | C++ actual AIR structure/SSA checker and generic actual final-AIE scalar-dataflow/address/buffer/routing/lock/runtime/causal checker, with fail-closed support bounds. | air-final-delivery-r1; AIE21 and AIR9 actual negative controls |

The common chain reuses ProgramGraph, StaticConfig architecture, ProgramTiming, the existing resource scheduler and original search/cache/checkpoint driver. Python supplies experiments and numerical oracles, not production plans, legality, costs or search parents. Amoeba mapper/scheduler/network and CGRA ML contracts are preserved.

## Public decisions, support and boundaries

The architecture supplies concrete resource/memory/domain references; coordinates are opaque to common planning. Explicit compute access and directed DMA links authorize use, rather than resource-name prefixes. Two synthetic targets use different identifiers and hierarchies, including parent-owned shared SRAM; native planning accepts a declared65536-byte target budget. The default NPU description retains the original `(0,2)` and24576-byte payload policy. Its backend rejects other coordinates rather than silently remapping. Shared-resource implication closure uses the maximum minimum reservation within one activity; distinct activities still contend on the shared resource.

Source choices name task groups and retained storages. Resolved scopes carry phase spans, actual members, boundary exports and inputReleasePolicy. Semantic intergroup dependencies and implementation configuration dependencies are distinct. Invocation lifecycle is explicitly host-device or host-only, independent of a device label. Allocation owners, reusable-slot aliasing, copy creators/users and exact versions remain in the public graph. Data-only ordinals never become completion events.

Current native residency proof supports static scalar rectangular identity-grid pointwise tasks, matching regions/grids, unique writers and nonoverlapping contiguous intervals of source-topological tasks. Noncontiguous groups require a future dependency-convex contraction/alias proof. Whole-task pure-order barriers within a tiled group, reductions, in-place/cross-block work, repeated external input across different group tasks, complex layouts/addresses and multi-core execution reject or remain outside certification. Boundary data shared between configurations is explicitly exported/reloaded; there is no cross-configuration SRAM-preservation claim. Single-tile configurations are serialized by explicit implementation constraints, not fabricated semantic group chains.

## Concrete plans and execution

The seven-task program is U=A+1; X=2U; Y=X+3; Z=X-1; V=Y+Z; W=V/2; O=W+Y. Z and O are caller outputs. All arrays are17×136 FP32:73984 total logical array bytes, above24576; a full3- or4-array group also exceeds the budget. Tiles4×136 and8×136 fit with a final1-row tail. Explicit12×136 retention requiring26112 bytes is rejected although a three-buffer materialized tile needs only19584. See CONCRETE-PLAN.md and visualizations-r2.

| Final original-search representative | Groups/configurations | Requested transfer B | Peak local payload B | Estimate ms | Session1 wall median ms | Session2 wall median ms |
|---|---:|---:|---:|---:|---:|---:|
| baseline | 14 | 147968 | 6528 | 1.098312 | 1.257158 | 1.203750 |
| mixed_boundary | 12 | 138720 | 6528 | 1.006564 | 1.190650 | 1.128842 |
| internal_only | 12 | 129472 | 8704 | 0.994816 | 1.386405 | 1.119152 |
| two_groups | 8 | 101728 | 8704 | 0.791544 | 0.983896 | 0.969806 |
| tiling_composed | 10 | 120224 | 17408 | 0.887268 | 1.249898 | 1.047233 |
| output_role_boundary | 12 | 138720 | 8704 | 0.998536 | 1.121252 | 1.123821 |
| five_baseline | 10 | 101728 | 6528 | 0.833644 | 0.870609 | 0.893548 |
| five_mixed_boundary | 8 | 92480 | 6528 | 0.741896 | 0.749961 | 0.753961 |

Bytes are statically requested descriptor/region payload, not hardware-measured DDR traffic. Local payload excludes the separately emitted stack/runtime reservations; the compiler accepted actual allocations. Host system memory uses a configured unbounded allocation-domain limit, not a measured physical DRAM capacity.

The partial X group shares one local copy with Y and exports it for outside Z; X is not globally deleted. The internal V group removes the V host allocation and transfer pair. The final two-group winner retains X in tasks1/2/3 and W in tasks5/6, leaving prefix task0 and middle task4 ungrouped. Its Y host copy is used by two groups through explicit repeated loads. The output-role group retains Z for task4 and still exports Z to the caller, exporting V for task5 as well.

## Actual implementation checks and integration defects

AIR checks actual operations, SSA buffers, regions and token dependencies against the checked plan. Final AIE checks actual resource coordinates, concrete buffers/types/memory spaces/dense layouts, scalar value DAG/constants/addresses/loop domains, flow/channel/shim-to-buffer routing, exact element coverage after DMA coalescing, lock identities/initial states/amounts/cycles and release positions, wrapper ABI forwarding and unique configure/run/start/output-await structure. Actual and required public causal closures are checked in both directions. Binding attributes propose joins but cannot replace these operation facts. This certifies the inspected pre-LLVM AIE structure, not every downstream machine instruction or measured device timing.

The new output-role case exposed two real defects. The public first compute waited for a later-task input Y, but AIR did not import/wait Y at block entry. Actual checking rejected it before hardware execution. Upfront real DMA and wait now implement the public readiness. That made the compiler legally free X after task3 while Y remains live through task4; the old blanket input-tail rule then overconstrained actual execution. The resolved last-reader contract now records per-buffer refill dependencies before timing. The checker independently extracts actual releases, rather than accepting the policy declaration. The old erroneous AIE is still rejected. No artificial arithmetic or reread was inserted. See late-input-closure-r1, failed compiled-output-role-r2, corrected-r3 and final eight receipts.

Negative controls include missing required boundary/caller export, missing final-reader overwrite order, old/wrong logical version, wrong memory/owner/resource, missing/duplicate/overlapping regions, missing pure order, overlapping/wrong groups, actual scalar constant/operand/body-order/address mutation, changed metadata alone, wrong DMA route/ABI, missing await, duplicate run, invalid locks, and malformed resolved scope/unknown release policy. Invalid direct APIs reject without the former division-by-zero failure.

## Transparent mechanism estimate

No coefficients were fitted to these programs. All nine numeric parameters are reused unchanged from v18 and explicitly assumed. For scalar instance i, C_i=200+2·logical_arith_i+3·logical_load_store_i ns. For transfer j, D_j=500+payload_j/1 ns (bandwidth1 byte/ns). Each explicit group adds40000ns. One shared invocation has100000ns entry and100000ns completion; separate visibility costs0 because those host envelopes own them. Each public event has one charge; merged runtime BDs are not charged again.

| Parameter | Value/unit | Source and identifiable meaning |
|---|---|---|
| compute.startup |200 ns/instance | Assumed loop/task entry envelope |
| compute.operation |2 ns/source scalar op | Assumed; not SIMD/VLIW instruction latency |
| compute.memory_access |3 ns/source load/store | Assumed local access/index/loop envelope |
| communication.startup |500 ns/public delivery | Assumed lock/setup/service envelope; not isolated physical DMA or runtime-BD latency |
| communication.bandwidth |1 byte/ns | Assumed effective payload service; not measured DDR link bandwidth |
| configuration.startup |40000 ns/group | Assumed coupled group effect; not separately calibrated configuration time |
| host.submit / host.complete |100000 ns each | Assumed prepared-call entry/TO-sync and return/FROM-sync envelopes; per-BO variability not independently modeled |
| host.visibility |0 ns separate | Covered by host envelopes, not physically free |

ProgramTiming obtains completion from event dependencies, declared resource reservations, explicit group constraints and all-user buffer reuse. Strict mode returns required unknown mechanisms and no absolute ranking. Estimate mode records assumptions and produces the objective. The NPU DMA resource is a conservative serialized service model over the backend channels; observed hardware overlap and fluid bandwidth sharing are not identified. Synthetic scheduling tests cover independent compute resources, sharing, DMA exclusion, one/two-buffer overlap, capacity and illegal versions.

Baseline serial work is1.098312ms. Removing six configuration charges saves240µs; reducing46240 requested bytes contributes46.240µs and25 delivery starts contributes12.500µs. The final last-reader winner additionally permits8.028µs of predicted input/compute overlap, yielding0.791544ms instead of0.799572ms for the other two-group composition at the same bytes/configuration count. This is a model schedule consequence, not a measured8µs overlap claim. Hardware has not established the fine W-versus-V grouping preference.

## Original search and sensitivity

Final estimated-search-r3 archives29 candidates,26 assumption-priced scalar plans and3 unknown implementation plans. The first round compares several actual subgraphs; scores select the X group and the W→O group as parents. The second round actually expands those parents and selects their composition. The score-selected winner/source is466264…; actions, parents, rejection reasons, full graphs and schedules are archived. No workload-name or fixed fixture-task matching participates in discovery. Budgets limit proposals/groups/candidates and original source/graph/cache/checkpoint identity checks remain active.

final-search-guard-bridge-r1 proves all29 fresh-generation search artifacts equal the final guarded compiler artifacts without normalization. Final sensitivity-r3 re-evaluates all29 graphs in C++ under seven fixed parameter variants: bandwidth×0.5/2, configuration10/80µs, compute-operation and memory-access×0.5/2, plus reference. The same unique winner and exact selected parent set survive all seven in this final revision. This establishes sensitivity only within those declared assumptions, not real candidate ordering. Earlier revisions and their floating tie changes remain preserved.

## Frozen observations, errors and search readiness

Study1 observation-freeze-r1 bound seven plans before any v19 performance; two sessions ran462 calls/924 arrays, all correct. The unchanged assumed model supported all11 paired-median comparisons in both sessions under the descriptive rule.

Study2 fresh-generate-r2 bound eight actually compiled plans before their two sessions. Six source candidates recur; the W-group winner and output-role plan are newly measured organizations. Earlier seven-case timings had already been observed, so this is not an entirely unseen eight-plan test. Parameters and formulas were never refitted. Source/graph/native plan/actual AIR equality with final current tools is exact for these eight, and both independent actual-AIE checks and hardware output checks pass. Study2 ran528 calls/1056 arrays; cumulative990/1980 all correct.

All calls use same generated inputs/FP32 precision, original finite atol=rtol1e-5 versus source-rounded FP32 and an independent unrounded FP64 oracle, bound BOs/all contexts prepared, three seeds, two warmups and nine retained repeats/seed,20µs explicit host polling and alternating forward/reverse candidate order. Main agent alone holds /tmp/npu.lock through the existing observer. All raw inputs, outputs, references, submit/wait/poll/sync events and sample distributions are retained. Complete start/return boundaries are host perf_counter_ns; the completion query brackets visibility conditionally, not physical DMA/core time. Instrumentation can perturb the host quantity.

| Candidate minus own baseline | Predicted µs | Session1 paired median µs [bootstrap95%] | Session2 paired median µs [bootstrap95%] |
|---|---:|---:|---:|
| mixed_boundary | -91.748 | -75.649 [-123.896, -9.860] | -70.098 [-80.327, -52.499] |
| internal_only | -103.496 | -87.368 [-118.237, 69.698] | -100.278 [-115.157, -76.139] |
| two_groups | -306.768 | -280.853 [-396.640, -231.925] | -244.364 [-255.004, -226.604] |
| tiling_composed | -211.044 | -168.975 [-208.284, -82.508] | -159.917 [-184.515, -149.707] |
| output_role_boundary | -99.776 | -146.606 [-426.380, -129.037] | -83.329 [-93.658, -74.939] |
| five_mixed_boundary | -91.748 | -87.338 [-142.416, -81.808] | -135.156 [-145.825, -101.317] |

Intervals are descriptive paired resampling conditional on each process session, not independent-day confidence guarantees. Complete means, medians, quantiles, raw samples, all16 pair comparisons and identity/numeric audits are in observation-final-audit-r1/report.json. Supported median comparisons are10/16 then15/16. Session1 has a resolved wrong internal-only versus output-role ordering; session2 cannot resolve that small predicted3.720µs difference. Other first-session pairs remain unresolved. The two-group versus baseline improvement is supported in both sessions, but its first-session comparison with output-role is not resolved. Do not claim the winner is globally measured-best.

Across the two eight-context sessions, internal-only median changes23.88% and tiling-composed19.35%; winner changes1.45%. Means have long-tail effects and sometimes disagree with median ordering. The model does not identify whether the remaining variation is host/polling/context behavior or device execution; common unknowns cannot simply be assumed to cancel. No additional fitting or selective rerun was used to erase this noisy session.

**Readiness:** the original two-round estimate-driven algorithm loop is successful. Public planning, legal transformation, backend realization and correctness are demonstrated. A substantial baseline-to-composition benefit is observed. General fine-grained performance search remains paused;8µs preferences and all-candidate ranking are not validated. Further algorithm development can use explicit estimate mode and retain this uncertainty; reliable real-performance decisions require discrimination appropriate to the expected gain.

## Reproduction, evidence and engineering

REPRODUCE.md provides independent Core build, clean-shell CPU replay, complete fresh source/search/compile/freeze entry and small serialized NPU replay. Final tool hashes are in DELIVERY.json and the independent Core/AIR receipts. Exact eight-plan bridges need no normalization; older identity/lifecycle/reporting transitions have separate path-classified bridges and never rebind historical measurements. Discovery diagnostics are excluded from chosen execution identity; the explicit v19 identity revision is recorded.

Final clean-shell final-clean-regressions-r2 passes Core40, combined57, new AIR controls and old AIR13/10/15, preserved original Neura17/CGRA8 and unfiltered lit35, with unchanged tool hashes. Target44/subgraph45/Timing83/mechanism19 focused checks pass. Current Core and current AIR builds are distinguished from the preserved original Neura/CGRA compiler. Current Core adapts public graphs; preserved mapper/scheduler/network/model binaries are tested with their original contracts, not described as freshly rebuilt. All original dirty files were archived at intake, and new failures/builds/raw observations live in this independent directory. No push or commit was performed.

The remaining serialized `npu_single_core_serial` placement string is a compatibility diagnostic tag, not the target-derived invocation/resource binding. It has no production branch consumer. Do not interpret it as proof of physical position; concrete mapping references and actual IR are authoritative.
