# Fixed input-0 cumulative ablation

The active experiment is aligned to the AMOEBA paper: 4×4 CGRAs with 2×2 PEs each, using the new four-member direct model. See [reproduction instructions](INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md) and [hardware provenance](../reference/input0-neighborhood/architecture-2x2-provenance.json). The v38 main ablation is complete: 25 measured stages pass mapper, numeric and independent trace validation, and five Ray stages have source-bound model-domain exclusions. SRAM remains pending and formal GO is false.

Original Ray is explicitly out of the model domain in all five main stages. Its best allowed shape has lower-bound II 21, above the model ceiling 20. The separately authorized split-at-4 fission curve uses the same new hardware, model and 4-round/4,096-score budget.

## Current paper-aligned 2×2-PE results

The [frozen result record](../diagnostics/input0-neighborhood-2x2-v38-frozen/neighborhood-final-results.json) and [stage table](../diagnostics/input0-neighborhood-2x2-v38-frozen/neighborhood-stage-table.md) retain the C++ predicted shortlist order, measured winners and independent validation gates. [Plots and CSV](../diagnostics/input0-neighborhood-2x2-v38-frozen/plots/input0-ablation-normalized.png) use this same cohort.

| Program | Fixed 1×1 | S1 | S2 | S3 | S4 | S5 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| GCN | 99,506 | 89,389 | 84,199 | 78,138 | 76,492 | 76,262 |
| Harris | 988,256 | 933,326 | 925,389 | 851,243 | 625,665 | 560,137 |
| LLaMA | 1,129,656,836 | 762,655,252 | 704,983,574 | 549,902,875 | 497,281,562 | 497,179,163 |
| LU | 18,501 | 11,347 | 11,283 | 9,663 | 8,594 | 8,586 |
| Radar | 1,317,811 | 1,309,621 | 1,305,305 | 1,272,539 | 1,141,467 | 1,141,467 |
| Raytracing | Unavailable | Out of model domain | Out of model domain | Out of model domain | Out of model domain | Out of model domain |

All values are complete-program scheduling cycles using actual mapper II. The fixed 1×1 baseline means one 2×2-PE CGRA per task. It has the same input-0 and transfer contract; GCN uses proved active transfer extents for arguments 1–12. A historical GCN baseline with full-capacity communication is incomparable.

The separate [Ray fission result record](../diagnostics/input0-ray-fission-2x2-v38-frozen/neighborhood-final-results.json) contains S1–S5 cycles **187,013; 178,187; 172,303; 164,948; 162,005**. Each passes mapper, numeric and independent trace checks. These values do not fill the original Ray main-table exclusion.

The [current original-AMOEBA summary](../reference/input0-neighborhood/evidence/2x2-original-amoeba-baselines.json) records validated cycles separately from failures under repair. GCN is **106,351**, Harris **1,072,495**, LLaMA **636,723,751**, LU **11,602**, and Radar **1,321,316** cycles; all five pass numeric, selected-body mapper binding, source-domain and independent trace checks. These are fixed-decision retimed makespans preserving the original f45 scheduler's shapes, placements, replicas and dispatch. Internal placement slots are stored separately. The records do not certify an original-paper full-flow hardware execution or formal performance GO. Multi-replica programs retain the original F45 ceiling division estimate, with unchanged mapper II and explicit `replica_timing_policy` evidence. ORBIT stage results continue to use their actual rewritten task bodies and mapped costs.

```sh
python3 scripts/show_input0_results.py
```

The tables below are **historical 4×4-PE diagnostics**, not measurements of the new paper configuration. The repaired-source LLaMA focused run later reached 22.1546% reduction on that older hardware; it is neither a global guarantee nor a result for the new 2×2-PE configuration.

## Historical frozen v19 cohort

The frozen corrected-domain v19 cohort is complete: all six programs and five stages have actual native results. It is a pre-fix diagnostic cohort. Later LLaMA DFG, GCN read-completion, and nested tiling-lineage changes belong to separate source and result batches; they cannot be replayed bit-for-bit from a newer source tree. The earlier v11/v12 tables were superseded because their cost domains omitted source iterations and are excluded from this cohort. The v19 source captures complete affine iteration domains before lowering and verifies partition coverage against the canonical source.

The compact [result record](../diagnostics/neighborhood-v19-frozen/neighborhood-final-results.json), [stage table](../diagnostics/neighborhood-v19-frozen/neighborhood-stage-table.md), and [table data](../diagnostics/neighborhood-v19-frozen/neighborhood-stage-table.json) retain candidate order, winner identities, measured controls, failures, and validation status. The [absolute-cycle plot](../diagnostics/neighborhood-v19-frozen/plots/input0-ablation-absolute.png) and [normalized-cycle plot](../diagnostics/neighborhood-v19-frozen/plots/input0-ablation-normalized.png) were rendered from that 30-cell table; PDF, SVG, and CSV are alongside them.

All 30 cells pass native replay, mapper equality, numeric comparison, and independent trace validation. SRAM passes for one cell and remains pending for 29, so this cohort is diagnostic-only and does not claim formal GO. Three descriptive protocol fields (`optimizer_pin`, `source_contract_file`, and `source_variant`) say v17 while exact runtime bindings and checkpoint payloads identify v19; the result record discloses each discrepancy and does not claim byte-identical resume under the stale descriptor.

## Stages and common budget

| Stage | Enabled dimensions | Dispatch |
| --- | --- | --- |
| S1 | Shape | Fixed dependency-ready |
| S2 | Shape | Critical path |
| S3 | Shape, replica | Critical path |
| S4 | Shape, replica, tiling | Critical path |
| S5 | Shape, replica, tiling, fusion | Critical path |

Each workload-stage uses at most four rounds and 4,096 unique complete candidate scores, a beam of 16 with at least four diversity positions when available, and a global predicted native shortlist of five. Identity and the previous measured winner are additional controls. Replica and cumulative tiling factors are 1, 2, 4 and 8; oriented shapes have area at most four. Repeated legal pairwise fusion can create larger fusion groups. The search does not precompute a complete rewrite closure or enumerate a Cartesian product.

C++ MLIR owns candidates, legality, rewrites, deduplication, cost prediction, explicit-communication production scheduling and predicted top-five ranking. Python starts and resumes processes, runs validation and renders observations. Three disjoint four-core lanes use at most twelve host cores; compilation and linking use one job.

The stage value is the minimum whole-program scheduling cycles among legal measured shortlist and control candidates. Native scheduling uses actual mapper II rather than predicted II. Results are budgeted **best-found** observations; there is no exhaustive or global-optimality claim. Native mapper equality, independent trace, numeric comparison and SRAM are separate gates. Pending SRAM does not constitute a full-system performance GO.

## Completed curves

These are actual native stage cycles from the completed v19 cohort. Each stage uses production scheduling with measured mapper II. The bounded search reports best-found observations, not exhaustive or globally optimal results.

| Program | S1 | S2 | S3 | S4 | S5 | S5 reduction from S1 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| GCN | 74,310 | 74,304 | 72,988 | 72,984 | 72,984 | 1.78% |
| Harris | 840,477 | 816,790 | 783,277 | 632,869 | 523,483 | 37.72% |
| LLaMA | 746,619,416 | 746,619,416 | 720,929,306 | 720,929,306 | 720,929,306 | 3.44% |
| LU | 10,261 | 10,261 | 10,261 | 9,925 | 9,925 | 3.27% |
| Radar | 1,172,191 | 1,172,191 | 1,172,191 | 1,172,191 | 1,172,191 | 0.00% |
| Raytracing | 136,995 | 131,110 | 131,110 | 131,110 | 131,110 | 4.30% |

All six curves pass native replay, mapper equality, numeric comparison, and independent trace validation; SRAM remains a separately recorded diagnostic limitation. GCN S5 reached the 4,096-candidate score limit in two rounds and is best-found, not exhaustive. Harris's S5 winner adds tiling to its inherited replica/tiling graph and does not use fusion. LLaMA's S3 winner replicates Task_8 eight ways along axis 0. LU's S4 winner tiles Task_0 eight ways along axis 0. Their S5 winners retain the previous stage's measured result; opening fusion does not require the winner to use fusion.

The v19 search has known coverage limitations. Its fixed neighbor order can consume the score budget before every beam parent is expanded, imported seeds lose their action history, and selective lineage withdrawal is rejected. LLaMA's Task_0, Task_1 and Task_3 replicas are rejected before scoring by its specialized DFG validator. A repeated tiling fixture also exposes an immediate-parent versus canonical-parent range mismatch. The later v38 cohort includes the accepted controller, replica and nested-lineage repairs; it uses the new 2×2-PE hardware/model binding and does not change this frozen v19 cohort.

Harris's static-bound arithmetic and equivalent `neura.data_mov` index checks have passed focused materialization probes in the later compiler. Guarded replica replay passes, while retained fusion still lacks the required multi-origin source-partition proof. This limitation is recorded separately from semantic legality. Historical Harris results remain useful diagnostic evidence; the superseded batch does not establish that all historical gains were invalid.

## Historical v19 model domain and transfer protocol

This section describes the old 4×4-PE v19 cohort only. Its model weights and production scheduler were held constant within that cohort. The portable model files change only informational provenance paths; C++ recomputation confirmed all 944 original task/shape catalog entries are unchanged, including unsupported status. A fresh reproduction binds its own exact portable model bytes and evidence paths, rather than reusing runtime caches from the development run.

GCN uses compiler-proved active transfer shapes for arguments 1–12 while retaining full physical capacity and strides. Proofs are regenerated after rewrites. Unproven transfers retain the established capacity contract; different communication protocols must not be mixed into a speedup claim.

Raytracing Task_13 contains eight internal reduction steps per outer firing. Its all-unit mapper lower bound is 21, beyond the existing model's ceiling of 20. This shape is recorded as unsupported by the model, not semantically illegal. The historical v19 search used the minimum-area supported initial shape, 1×2, for this task and records that the initial control is not the all-unit baseline. A separate all-unit mapper attempt confirms the bound failure: 329 tile-consuming operations on 16 PEs give `ResMII = ceil(329/16) = 21` against maximum II 20. The inclusive II loop is empty, so it tried no II values; 13 earlier tasks had mapper cache successes, but no whole-program native result was produced. This does not prove semantic illegality or a mapping above the current bound.

## All-unit identity baseline

For these five programs, the measured v19 S1 identity candidate is 1×1 for every task. Each row passes native replay, mapper equality, numeric comparison, and independent trace validation; SRAM is pending and `production_ready` is false.

| Program | Tasks | All-unit identity cycles |
| --- | ---: | ---: |
| GCN | 28 | 80,954 |
| Harris | 24 | 871,595 |
| LLaMA | 9 | 746,619,416 |
| LU | 9 | 11,284 |
| Radar | 21 | 1,172,191 |

Raytracing's v19 S1 identity is 139,936 cycles and passes mapper, numeric, and trace checks, but Task_13 uses 1×2. It is not an all-unit identity and has no all-unit whole-program native result.

## Historical 4×4-PE original AMOEBA status

The original fusion, resource-allocation, and throughput-guided flow has per-task profile records for 118 tasks across eight shapes each (944 task-shape records). LLaMA and LU records came from the earlier static-v1 tool pin, so those 144 candidates do not establish static-v2 mapper provenance. These profiles are not a completed native full-program baseline.

Available fixed-decision retiming records are diagnostics rather than formal baseline GO. Their cycles are whole-program retimed estimates using captured selected-shape profiles, not fresh mapper replays of complete programs. Numeric and independent trace checks pass for Harris, LLaMA, and Radar, while source iteration-domain coverage remains pending.

| Program | Diagnostic cycles | Numeric comparisons / mismatches | Trace | Remaining status |
| --- | ---: | ---: | --- | --- |
| Harris | 883,343 | 884,736 / 0 | Pass | Domain coverage pending; formal GO false |
| LLaMA | 437,084,724 | 131,072 / 0 | Pass | Domain coverage pending; formal GO false |
| Radar | 636,859 | 259,904 / 0 | Pass | Domain coverage pending; formal GO false |
| GCN | — | Not run | Not run | Active replicas lack verified per-replica input-domain materialization |
| LU | — | Not run | Not run | Active replicas lack verified per-replica input-domain materialization |
| Raytracing | — | Not run | Not run | Current adapter rejects retained sequential control in Task_13 |

The current Raytracing adapter error is `task Task_13 has retained sequential control without source-domain coverage`. Task_13 retains its internal loop over eight reduction steps; do not unroll it and reuse those loop-body profiles or scale II by the trip count. GCN's original schedule has thirteen factor-2 replicated tasks. LU's original schedule has Task_2 at factor 3 and Task_6/Task_7 at factor 2; these require source-certified per-replica materialization before numeric admission. An earlier Harris/Radar retimer attempt reported `data-carrying task edge has unknown payload size`; later caller-shape diagnostics pass fixed retiming, numeric, and trace checks but still do not establish full-domain GO. No complete original full-flow baseline is claimed.

The separate repaired-source LLaMA focused run completed at 581,208,602 cycles versus S1 746,619,416 (22.1546% reduction), with native, numeric and independent trace validation. Its one-round/16-score budget and older 4×4-PE hardware make it a diagnostic outside the frozen v19 curves and the new paper configuration.

## Historical v19 Ray fission diagnostic

This is the old 4×4-PE, one-round/16-score comparison. The new paper-aligned 2×2-PE fission supplement is measured separately and does not use these cycles. The C++ `fission-ray-carried-reduction` pass splits Task_13 at lane 4 into ordered prefix and suffix tasks. Explicit private best/index buffers carry state across the split, preserving all 11,776 source-work units as 5,888 plus 5,888. Completion dependencies do not perform numeric reduction. Preparation is reproducible with `prepare_input0_source_domains.py --ray-fission-split-at 4`.

Within that historical cohort, using the same compiler, model, architecture, dispatch and one-round/16-score diagnostic budget, the original graph's best measured result is 139,936 cycles and the split graph's is 136,999, a 2.10% reduction. Both pass native mapper, independent trace and numeric checks. The original graph's larger-budget main S1 already reaches 136,995 cycles, so the diagnostic does not establish an additional improvement over that result. Fission remains outside the main S1–S5 definitions. SRAM is pending and no formal performance GO is claimed.

## Reproduction

[Portable build, run and resume instructions](INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md) describe how to generate canonical programs and cost catalogs from the [complete fixed-input sources](../reference/input0-source-domains/manifest.json). Runtime caches, intermediate IR, checkpoints and logs are regenerated and excluded from the minimal publication. The model's legacy cost-provenance source label is distinct from the actual compiler source revision and exact source/binary binding.
