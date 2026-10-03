# Six-program input-0 cumulative ablation

All 30 workload-stage cells completed under the same v11 source and diagnostic protocol. Each cell has real mapper replay, whole-program native scheduling, an independent trace pass, and numeric validation. The experiments are budgeted **best-found** results; they do not establish exhaustive or global optimality.

## Stage definitions and common budget

| Stage | Enabled decisions | Dispatch |
| --- | --- | --- |
| S1 | Shape | Fixed dependency-ready |
| S2 | Shape | Production critical-path |
| S3 | S2 + replica | Production critical-path |
| S4 | S3 + tiling | Production critical-path |
| S5 | S4 + fusion | Production critical-path |

S1→S2 changes dispatch policy. S2→S5 cumulatively enables candidate dimensions. Every stage starts from a canonical complete program and preserves identity/no-op, compatible legal historical seeds, and the measured previous-stage winner as controls. Previous decisions may be replaced or withdrawn. Historical seeds are revalidated and rescored before admission.

The shared diagnostic budget is four rounds, at most 1,024 unique complete candidate scores, beam width 16, at least four diversity slots when available, and a native shortlist of five. All 30 cells stopped at the candidate budget. A partially explored round may leave zero completed rounds in the machine record. A larger 20-round/20,000-candidate run is a separate protocol and is not mixed into this table.

The first local action range uses shapes 1×1/1×2/2×1, replicas 1/2 and tiling factor 2. Later actions admit oriented shapes of area≤4 and legal cumulative factor 4. The current results do not include the queued parameter expansion to 8 or the two queued baselines.

C++ MLIR owns complete-program action generation, materialization, legality, canonical facts, deduplication, the beam and archive, production scheduling with explicit communication, and global predicted top-five ordering across all explored graphs/resources. Python launches, restores, validates, and reports those records. The search does not construct a full graph closure or enumerate all placement/order choices.

## Actual whole-program cycles

These are production scheduler cycles using **actual mapper II**, after mapping complete selected candidates. They are distinct from ML predicted II and from measured hardware/RTL execution time. Each stage value is the minimum among all legal, measured shortlist entries and the identity/previous-winner controls.

| Workload | S1 | S2 | S3 | S4 | S5 | S5 reduction from S1 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| GCN | 915,641 | 915,639 | 915,638 | 915,638 | 915,638 | 0.0003% |
| Harris | 839,846 | 816,791 | 781,760 | 573,628 | 523,090 | 37.7160% |
| LLaMA | 563,610,138 | 563,610,138 | 563,610,138 | 440,265,239 | 394,200,603 | 30.0579% |
| LU | 6,277 | 6,277 | 6,230 | 5,445 | 5,438 | 13.3663% |
| Radar | 351,980 | 349,933 | 344,848 | 344,847 | 333,755 | 5.1779% |
| Raytracing | 128,138 | 128,138 | 128,138 | 128,138 | 128,138 | 0.0000% |

![Normalized five-stage ablation](../reference/input0-neighborhood/figures/input0-ablation-normalized.png)

The normalized plot uses each program's S1 as 100%. [Absolute cycles](../reference/input0-neighborhood/figures/input0-ablation-absolute.png) use a separate scale for each workload. GCN improves by three cycles in this budget; Raytracing has no measured improvement. Those observations apply to this explored archive and budget. Enabling fusion in S5 does not require the measured winner to use fusion.

Both figures are available as PNG, SVG, and PDF in `reference/input0-neighborhood/figures`, alongside the exact plotted CSV.

## Predictions and execution evidence

The predicted column below is the best C++ archive prediction. The measured winner may be a different shortlist candidate or a retained control. Predicted and measured rankings remain separately recorded.

| Workload-stage | Best prediction | Measured stage cycles | Unique scores | Completed rounds | Search seconds | SRAM |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| GCN S1 | 924,396 | 915,641 | 1024 | 1 | 724.03 | pending |
| GCN S2 | 924,209 | 915,639 | 1024 | 1 | 573.41 | pending |
| GCN S3 | 924,024 | 915,638 | 1024 | 1 | 589.72 | pending |
| GCN S4 | 923,846 | 915,638 | 1024 | 1 | 730.46 | pending |
| GCN S5 | 923,674 | 915,638 | 1024 | 1 | 858.75 | pending |
| Harris S1 | 762,968 | 839,846 | 1024 | 1 | 96.26 | pending |
| Harris S2 | 755,494 | 816,791 | 1024 | 1 | 120.55 | pending |
| Harris S3 | 726,241 | 781,760 | 1024 | 1 | 207.80 | pending |
| Harris S4 | 518,904 | 573,628 | 1024 | 0 | 564.93 | pending |
| Harris S5 | 466,899 | 523,090 | 1024 | 0 | 602.71 | pending |
| LLaMA S1 | 532,821,411 | 563,610,138 | 1024 | 2 | 38.52 | pending |
| LLaMA S2 | 532,821,411 | 563,610,138 | 1024 | 2 | 39.79 | pending |
| LLaMA S3 | 532,929,773 | 563,610,138 | 1024 | 1 | 34.01 | pending |
| LLaMA S4 | 401,061,088 | 440,265,239 | 1024 | 1 | 216.85 | pending |
| LLaMA S5 | 357,435,935 | 394,200,603 | 1024 | 1 | 448.57 | pending |
| LU S1 | 7,599 | 6,277 | 1024 | 2 | 75.16 | pass |
| LU S2 | 7,599 | 6,277 | 1024 | 2 | 71.11 | pass |
| LU S3 | 7,550 | 6,230 | 1024 | 2 | 81.55 | pass |
| LU S4 | 6,765 | 5,445 | 1024 | 1 | 222.92 | pass |
| LU S5 | 6,758 | 5,438 | 1024 | 1 | 300.62 | pending |
| Radar S1 | 363,230 | 351,980 | 1024 | 1 | 137.65 | pending |
| Radar S2 | 360,621 | 349,933 | 1024 | 1 | 116.98 | pending |
| Radar S3 | 355,547 | 344,848 | 1024 | 1 | 168.75 | pending |
| Radar S4 | 354,492 | 344,847 | 1024 | 1 | 295.90 | pending |
| Radar S5 | 346,186 | 333,755 | 1024 | 1 | 308.40 | pending |
| Raytracing S1 | 123,400 | 128,138 | 1024 | 1 | 445.09 | pending |
| Raytracing S2 | 122,387 | 128,138 | 1024 | 1 | 669.87 | pending |
| Raytracing S3 | 121,211 | 128,138 | 1024 | 1 | 535.75 | pending |
| Raytracing S4 | 120,010 | 128,138 | 1024 | 1 | 568.79 | pending |
| Raytracing S5 | 123,400 | 128,138 | 1024 | 1 | 484.05 | pending |

The [machine table](../reference/input0-neighborhood/evidence/table/neighborhood-stage-table.json) and [readable table](../reference/input0-neighborhood/evidence/table/neighborhood-stage-table.md) record each candidate's selected shape, replica, tiling and fusion; predicted/native ranks; controls; cache hits and misses; rejection reasons; search time and stop reason; and changes from S1 and the previous stage. Per-stage mapper-II evidence distinguishes ML predictions from compiler-emitted II. All 204 native entries passed in this batch; there are no failed or untested entries. Fresh runs retain failed-candidate status and errors in their generated output.

Numeric, mapper equality, independent trace and SRAM are separate gates. LU S1–S4 report SRAM pass; the remaining 26 cells report pending. Pending residency/address evidence is preserved as a diagnostic limitation, and this publication does not claim a formal full-system SRAM GO. Sequential K uses state carry; parallel K uses private partial buffers and an explicit numeric reduction. Completion joins provide ordering rather than numeric addition.

## Source and reproduction

The source snapshot includes the sequential-K result-lifetime fix used by this v11 batch. The required Neura compiler is vendored in the separate [ORBIT source repository](https://github.com/guosran/orbit), with upstream revisions recorded in `UPSTREAM_PROVENANCE.json`. The original upstream source identity retained by task catalogues is separate from the publication commit. No older v9 result is substituted into the curves above.

Follow the [portable reproduction commands](INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md). The bundle includes static fixed-input MLIR, caller proofs, model payloads, parent cost tables, legal candidate seed programs, reference C++ sources, final normalized observations, and plot generation. Runtime caches, checkpoints, intermediate IR and logs are regenerated and are not committed. Exported historical paths use declared symbolic roots. A fresh run builds its own exact binding and resumable checkpoint; only final observations are published.

The host coordinator allocates up to three workload lanes with four mapper/native jobs each. This frozen v11 compiler scores candidates serially within each workload, so search alone can occupy fewer than twelve cores. A subsequent parallel-scoring compiler version must use a distinct binding and output namespace.
