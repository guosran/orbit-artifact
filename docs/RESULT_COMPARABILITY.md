# Result comparability audit

A prior result enters a current paper table only when exact source/protocol, architecture capacity, per-task limit, workload, evidence class, baseline pairing, completion state, and a regenerating artifact command are known and validated. Other results receive `historical_only`, `diagnostic_only`, `incomparable`, or `superseded` and are kept outside paper tables.

| Saved evidence family | Source/protocol audit | Classification | Paper use |
|---|---|---|---|
| ORBIT semantic closure JSON | AMOEBA `a57376e...`; canonical 8×8×8 i32; source C++ manifest and host JIT | Reference comparison only until fresh validation | Correctness table only after fresh run passes frozen invariants |
| Prior action-space checkpoint | AMOEBA `7111e8d...`; 5,280 attempts and 94 executable witnesses; differs from closure commit | `superseded` for current semantic run | No |
| Historical broad joint lit result | Six reported failures, one fixture without RUN; mixed explanations in context/report | `diagnostic_only` | No |
| CNN/GPT-2/FFT-256 workload outputs | Old `codex/joint-scheduling-review` at `c91151de...`, dirty worktree; current source/protocol matching fails | `historical_only`, `superseded` | No |
| Six-case activity scheduler microbenchmarks | Old synthetic protocol at `c91151de...`; 48 rows, six cases × eight policies | `diagnostic_only`, `historical_only` | No |
| Rank-2, halo, fusion and replica native microbenchmarks | Old 4×4 network and native mapper protocol at `c91151de...` | `historical_only`, `superseded` | No |
| VectorCGRA local blocked-GEMM/DMA/SPM experiments | Local memory/RTL protocol, distinct from multi-CGRA TaskEdgeGraph/NoC | `incomparable` to generic ORBIT network cost | No, unless a separately matched case study is added |

The old CNN/GPT-2/FFT-256 bundle used a 4×4 physical CGRA network (16 total), usually a four-CGRA per-task limit, an earlier shape/replica protocol, and a provisional predictor. It contains analytical and native mapper replay records, but no RTL or device-launcher verification. Its producing argv was not captured, and it lacks a same-protocol native baseline. The source commit is an ancestor of the semantic pin but ancestry alone cannot prove result comparability. CNN/GPT-2/FFT outcomes are therefore **pending_current_protocol_reproduction**; saved values are not current reference or speedup evidence.

The six saved synthetic scheduler cases are `communication_dominated`, `eager_consumer_harmful`, `independent_tiles`, `near_simultaneous`, `resource_saturation`, and `skewed_producers`. Their exact oracle was scoped to small synthetic graphs. They can guide a future current-protocol scheduler fixture, but cannot certify that the pinned C++ source implements pipeline-aware, beam, or exact activity scheduling; it does not.

Other preserved data: earlier `amoeba-paper-rerun-20260921` workloads use mismatched replica/candidate/shape budgets and are `incomparable`; `amoeba-top5-eval-20260916` is predictor screening only and `diagnostic_only`; older tiling/fusion evidence has only representative witnesses and is `superseded`; local VectorCGRA blocked-GEMM/RTL and DMA/SPM records are `incomparable` with general multi-CGRA NoC cost. None is deleted or silently entered into a paper table.

The comparability record for each future import must state workload ID, source commit, semantic protocol, architecture ID, total CGRA capacity, per-task shape limit, replication, scheduler, optimizer, predictor, evidence class, regenerating command, completion, and matched baseline. `modules/contracts.py` rejects historical or incomplete records for paper pairing. Missing fields remain unknown; no zero fills them.

Current gaps include no pinned-source CNN/GPT-2/FFT replay; missing producing argv for old workloads; provisional predictor incompatibility; no same-protocol native baseline; unverified replica partitions downstream; no normalized occupancy domain; and no proven equivalence between those workload sources and the canonical i32 graph. These prevent matched end-to-end performance tables.
