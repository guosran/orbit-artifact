# CP-SAT v22: implementation, scaling and NPU validation

The native implementation now composes bounded reuse modes with global tiling,
and separately places independent source shards on real NPU2 cores. Both paths
use the optional C++ OR-Tools backend. The measured conclusion is limited:
CP-SAT is usable as a bounded local optimizer; arbitrary whole-program optimal
scheduling and stable hardware speedup are not established.

The reviewable [summary](../evidence/cpsat-v22/summary.json),
[scaling figure](../evidence/cpsat-v22/scaling.svg),
[raw-file index](../evidence/cpsat-v22/raw-manifest.json), actual AIR/AIE,
per-core source checks and CPU JSONL are in `taskflow/evidence/cpsat-v22`.
Full ELFs, inputs, references, all complete output arrays, logs and failed
campaigns remain under `results/taskflow/cpsat-v22-*` on the validation host.

## What is implemented

`ORBIT_ENABLE_ORTOOLS` defaults off. The default Core build has no OR-Tools
runtime dependency; its solver tool explicitly returns `UNAVAILABLE`. The
validated optional C++ SDK is Google's v9.15.6755 Ubuntu 22.04 archive, SHA256
`0b30114d7c05f0596286bf3ef8d02adcf5f45be3b39273490e6bb74a2a9bd1ea`.
See the [official release](https://github.com/google/or-tools/releases/tag/v9.15).

The `cp-sat` native search policy generates single local residency modes,
fully prices them against per-tile baselines, then composes an exact task cover
with common tiling, exclusive retained storage and acyclic quotient ordering.
Signed deltas preserve local cost increases as well as savings. A full native
planner/checker reprices the composition. A worse or unsupported composition
falls back to the best already checked local plan. The additive surrogate,
restricted discovery and truncated pricing domains remain explicit; solver
`OPTIMAL` never means optimal measured hardware latency.

The physical path proves an independent first-axis partition, lowers one local
execution group per shard, and uses CP-SAT for tile placement and interval
reservations on explicit compute/DMA resources. AIR herds receive actual
`x_loc/y_loc` pins. Before projection, final AIE checks resource ownership,
all supported symbolic references, complete host output coverage and runtime
lifecycle; each projected core then passes the existing full arithmetic,
address, buffer, lock/DMA and source-causality checker. Local child plan/graph
identities remain in the manifest instead of masquerading as the merged graph.

This is an independent-shard backend entry, not automatic joint optimization of
all shard counts and reuse decisions in one universal model. It certifies direct
shim/compute streams, static pools and one/two-core examples. Packet routing,
memtiles and inter-core dependencies are rejected. Model durations are assumed;
readiness/resource arbitration does not promise the modeled timestamp dispatch
or measured physical overlap. The interval/exclusivity formulation follows the
[official scheduling model](https://developers.google.com/optimization/scheduling/job_shop),
with result states distinguished as in the [CP-SAT documentation](https://developers.google.com/optimization/cp/cp_solver).

## Does solving time grow out of control?

It can exhaust a useful budget as the finite domain grows. Single measurements
cannot establish an exponential curve or a universal task-count threshold.
The first campaign's single-tile synthetic cover took about 5.5/12.8/227.7 ms
at 8/16/32 tasks, then frequently exhausted the approximately one-second solve
budget at larger sizes. Multiple tile alternatives and shared-DMA schedules
increased the frequency of incomplete solves. A 25 ms return reserve was too
small: worker startup, parsing and serialization sometimes caused external
watchdog termination. That campaign and its failures remain intact.

The accepted r5 campaign assigns 65% of the external 0.1/1 s budget to native
model construction plus solving. This percentage applies only to the standalone
worker experiment. Native full search uses a separate deadline allocation:
discovery receives up to 25% of remaining time, local pricing up to 55% of the
subsequent remainder, then solving receives half of what remains. Unspent time
passes forward. Single planner calls are nonpreemptive; overshoot is reported.
The CLI's internal limit is soft, and the supervisor's process-group watchdog
provides the external stop. Baselines are independently validated and saved
before starting a worker; `EXTERNAL_TIMEOUT` retains its own status, even when
returning a baseline objective.

Accepted r5 standalone results (same fixed problem per time-budget pair):

| Model / external budget | Optimal | Feasible | Unknown | External timeout |
|---|---:|---:|---:|---:|
| Cover / 0.1 s | 4 | 2 | 7 | 5 |
| Cover / 1 s | 8 | 2 | 8 | 0 |
| Shared-DMA schedule / 0.1 s | 6 | 8 | 1 | 0 |
| Shared-DMA schedule / 1 s | 6 | 9 | 0 | 0 |

There are 36 cover runs (8–256 tasks, 1/4/8 tiles) and 30 offline scheduling runs
(4–64 shards, 2/4/8 tiles). Every run has a validated fallback. The supervisor
selects it in 20/36 cover and 15/30 schedule runs, including valid solver results
that fail to improve the cheap reference. Large feasible schedule gaps reach
about 95%; a feasible incumbent is not an optimality proof. Maximum observed
process RSS is about 136 MiB for cover and 37 MiB for scheduling. Unknown or
killed worker RSS is unobserved and is not silently treated as zero memory use.
These samples support bounded local use, not replacing the incumbent with every
CP-SAT result or assuming optimality will be cheap.

Full native search initially spent its five-second soft budget on discovery and
pricing at 32+ tasks before reaching the solver. After reserving phase budgets:

| Chain tasks | Full process | Discovery | Pricing | CP-SAT solve | Final recheck |
|---:|---:|---:|---:|---:|---:|
| 8 | 1.224 s | 0.150 s | 0.694 s | 5.7 ms | 18 ms |
| 16 | 3.313 s | 0.587 s | 2.269 s | 12.7 ms | 40 ms |
| 32 | 3.679 s | 1.172 s | 1.933 s | 8.7 ms | 63 ms |
| 64 | 3.984 s | 1.164 s | 1.970 s | 9.6 ms | 139 ms |
| 128 | 4.780 s | 1.084 s | 2.126 s | 17.9 ms | 349 ms |

Exact values are authoritative in `summary.json`; rounded phase values may vary
slightly from this table. Domains at 16+ tasks are truncated by the uniform
bounds, so this is a budget-control result, not identical-domain scalability or
a polynomial-time claim. Complete source planning/pricing is currently the
main end-to-end cost. Solver bounds belong only to the fully priced finite
surrogate domain and are not lower bounds on measured hardware latency.

## Hardware correctness and timing

Four source programs cover 17×64 and 31×64 chains, a 17×64 fork/join and a
17×136 chain with unequal row tails. Seven physical variants use one/two cores;
the last program has only a two-core variant. All final AIE source contracts
pass before any XRT submission. The final campaign has three fresh processes
per variant, three input seeds, two warmups and five hot samples: 441 actual
calls and 441 complete output arrays. Every call has exactly one observed
submission. Outputs pass source-rounded FP32 and independent FP64 references
with unchanged finite `atol=rtol=1e-5`.

Timing does not establish stable speedup. For the 31×64 chain, the separate
non-build-overlapping r2 campaign measured 0.617/0.388 ms (one/two cores), but
r3 measured 0.381/0.382 ms. Other small programs also vary across campaigns.
The existing host-to-host observation includes wait-checkpoint serialization;
no isolated device timing or measured overlap has been established. r1 also
overlapped an independent Core build and is retained as exploratory correctness
evidence, not the preferred timing campaign.

## Checks, failures and reproduction

Core44, combined61, preserved original Neura/CGRA contracts and lit35 pass.
Supplemental final tests pass 42 independent oracle/resource-limit cases,
six native integration/budget cases and 15 multi-core AIE cases (one positive,
14 corruptions). Corruptions include arithmetic changes, output gaps, wrong
placement/device, missing starts, duplicate waits, premature frees, cross-owner
flows and unknown runtime/symbol references. Crashes or parse-only rejection do
not count as successful semantic rejection.

Preserved development failures include insufficient 4096-byte stack space,
unsupported automatically introduced packet routing, wrong placement attribute
names, and an MLIR opaque-property clone failure. The accepted path uses an
8192-byte stack, correct pins, an explicit direct-stream subset and lossless
property preservation. The r4 reproduction relocation also preserved a missing
Python `random` import failure before the corrected r5 replay. Earlier timeouts
are not relabeled as successful solves.

Build instructions are in the compiler's `docs/taskflow-cpsat-v22.md`. With the
repositories as siblings:

```sh
bash orbit-artifact/taskflow/scripts/run_taskflow_cpsat_v22_cpu.sh \
  CORE_OFF_BUILD CPSAT_AIR_BUILD NEW_CPU_OUTPUT
source aie-toy/scripts/env.sh
python orbit-artifact/taskflow/scripts/run_taskflow_cpsat_v22.py \
  --tool CPSAT_AIR_BUILD/tools/taskflow-opt/taskflow-opt \
  --config TARGET_CONFIG --output NEW_HARDWARE_OUTPUT --execute
```

The target configuration may use the existing unchanged
`orbit/test/TaskflowGeneric/reuse-assumptions-v21.json`. Hardware workers serialize
under `/tmp/npu.lock` and have an external 60-second process deadline. The CPU
campaign freezes tool/script hashes, separates generation/pricing/model/solve/
verification and keeps worker stdout/stderr/status/bounds/gaps/memory telemetry.
Numerical fixtures and all performance orchestration live in the artifact;
production analysis, optimization and lowering stay in C++ in the compiler.
