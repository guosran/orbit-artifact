# Original Ray common AMOEBA baseline: R11 receipt

This receipt adds the completed common-DFG AMOEBA record for original Ray. The native whole-program result is **177,426 cycles**. Native mapping, independent trace, and numeric validation pass; the numeric gate compared 61,892 elements with zero mismatches. The record is diagnostic: `formal_go` is false, formal/SRAM proof remains pending, and stage admission is not claimed.

The original throughput-guided F45 allocation contributes each task's selected CGRA count, profile shape, and active replica count. The common ORBIT production spatial-temporal scheduler then recomputes placements and dispatch. Its 177,426-cycle schedule is not a replay of the original F45 placement/dispatch. The independent trace covers 27 tasks, 66 dependencies, and 39 routed data pairs.

For each task, the full-parent mapped duration is read from the verified task-cost record. The effective task duration is `ceil(full parent mapped duration / original active replicas)`. All 27 computed effective durations match the recorded mapped duration, F45 source-scheduler duration, and common scheduler task duration.

| Task | F45 CGRA count / selected profile shape | F45 active replicas | Original F45 placed footprint | Common scheduler placed shape | Full-parent mapped duration (cycles) | Effective duration (cycles) |
|---|---:|---:|---:|---:|---:|---:|
| Task_0 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,890 | 5,890 |
| Task_1 | 1 / 1x1 | 1 | 1x1 | 1x1 | 4,418 | 4,418 |
| Task_2 | 1 / 1x1 | 1 | 1x1 | 1x1 | 17,672 | 17,672 |
| Task_3 | 1 / 1x1 | 1 | 1x1 | 1x1 | 7,360 | 7,360 |
| Task_4 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,890 | 5,890 |
| Task_5 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,890 | 5,890 |
| Task_6 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,890 | 5,890 |
| Task_7 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,890 | 5,890 |
| Task_8 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,890 | 5,890 |
| Task_9 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,890 | 5,890 |
| Task_10 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,890 | 5,890 |
| Task_11 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,890 | 5,890 |
| Task_12 | 1 / 1x1 | 1 | 1x1 | 1x1 | 2,947 | 2,947 |
| Task_13 | 4 / 1x4 | 2 | 4x1 | 1x4 | 30,934 | 15,467 |
| Task_14 | 1 / 1x1 | 1 | 1x1 | 1x1 | 7,360 | 7,360 |
| Task_15 | 1 / 1x1 | 1 | 1x1 | 1x1 | 2,945 | 2,945 |
| Task_16 | 1 / 1x1 | 1 | 1x1 | 1x1 | 7,362 | 7,362 |
| Task_17 | 1 / 1x1 | 1 | 1x1 | 1x1 | 14,724 | 14,724 |
| Task_18 | 1 / 1x1 | 1 | 1x1 | 1x1 | 14,724 | 14,724 |
| Task_19 | 1 / 1x1 | 1 | 1x1 | 1x1 | 22,085 | 22,085 |
| Task_20 | 1 / 1x1 | 1 | 1x1 | 1x1 | 22,085 | 22,085 |
| Task_21 | 1 / 1x1 | 1 | 1x1 | 1x1 | 22,085 | 22,085 |
| Task_22 | 1 / 1x1 | 1 | 1x1 | 1x1 | 22,085 | 22,085 |
| Task_23 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,891 | 5,891 |
| Task_24 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,891 | 5,891 |
| Task_25 | 1 / 1x1 | 1 | 1x1 | 1x1 | 8,831 | 8,831 |
| Task_26 | 1 / 1x1 | 1 | 1x1 | 1x1 | 5,889 | 5,889 |

Task 13's F45 selection is **four CGRAs per replica, profile shape 1×4, two active replicas**. Its full-parent duration is 30,934 cycles and the effective per-replica duration is `ceil(30,934/2) = 15,467`. The original allocation record's occupied-cell footprint is 4×1; the selected profile geometry is 1×4, and the common scheduler layout is 1×4. These columns report distinct allocation and placement fields from the receipts. They are not a candidate-count discrepancy.

The authenticated captured Task 13 profile set contains two successful candidates:

| Composed shape | CGRAs | Profile latency (cycles) | Compiled II | Status |
|---|---:|---:|---:|---|
| 2×2 | 4 | 32,405 | 22 | Successful alternative |
| 1×4 | 4 | 30,934 | 21 | Selected F45 shape |

No unit-CGRA Task 13 profile appears in the captured set; a marker negative control rejects claiming that unsupported profile as present. The marker's `count=4` means selected CGRA count, not four found candidate profiles. The selected II 21 is above the model training ceiling 20 but within the diagnostic runtime ceiling 23; runtime extrapolation is enabled.

The parent mapper profiles were generated in the earlier R10c profile capture: 216 expected and completed mapping attempts over the original 27 tasks. R11 reuses that authenticated profile file, canonical module, and original F45 scheduled module. The summary records direct comparisons of their complete serialized bytes between the R10c and R11 snapshots; all three pairs are exactly equal. R11 did not remap children or regenerate child mapper profiles. The saved profile-generation runtime states that the whole-program scheduler was not invoked during those mapping attempts; the R11 native replay and production-scheduler result are separate evidence.

The R11 optimizer pin was built from source commit `2dd2bb327269eaff23e5dc8cdff11d968b0dda15`. Its build acceptance records 140 source files and exact source bytes unchanged during the build; the source contract records 26 replay payloads and also marks the source tree as dirty. The copied architecture, network, and source-contract files compare exactly, byte for byte, with the main configuration and contract paths recorded by the run. Identity is established by direct equality of complete serialized byte sequences; no content-derived token is used. These are capture and pin identity facts, not a claim that the host checkout is clean or that its absolute paths can be reused from a clean clone. The R11 marker acceptance has one positive captured-Ray run and five rejected negative controls (extra field, forged count, forged fallback, forged shape, and unsupported unit profile).

The run used a 4×4 grid of 2×2 CGRAs (64 processing elements), six context-memory items and 23 control-memory items per CGRA. The 4×4 mesh has 48 directed links, one-cycle link latency, and 32-bit/cycle bandwidth. `formal_go=false`; SRAM/formal sign-off remains pending.

Only the Ray common-AMOEBA native record was run for this receipt. The other five common-AMOEBA baselines were not rerun, and no R9 record was changed. The summary retains all 27 task timing values, public validation values, marker results, and file byte counts. A single-file path and byte count are descriptive provenance only; they do not establish identity. The explicit paired byte comparisons show the files for which exact identity was checked. Paths under `/tmp` and the build checkout in [`summary.json`](summary.json) are provenance pointers only, not reusable clean-clone source bindings.

Raw capture roots:

- Native replay: `/tmp/orbit-r11-common-amoeba-ray-native-20261007`
- Reused profiles and F45 allocation: `/tmp/orbit-r10c-common-amoeba-ray-20261007-r2/profiles/raytracing`
- Marker positive and negative controls: `/tmp/orbit-r11-common-profile-marker-acceptance-20261007`
