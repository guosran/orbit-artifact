# ORBIT input-0 reproduction artifact

This artifact evaluates GCN, Harris, LLaMA, LU, Radar and Raytracing on their fixed input-0 programs. C++ MLIR owns budgeted whole-program neighborhood search, legal rewrites, deduplication, production scheduling with explicit communication, and the global predicted top five. Selected candidates then undergo real mapping, native scheduling, independent trace validation and numeric replay.

The hardware is the AMOEBA paper's 4×4 CGRA fabric with 2×2 PEs per CGRA, paired with the `orbit-2x2-predictor` four-member direct ensemble. The latest [R9 result snapshot](diagnostics/input0-memory-fusion-fission-r9-20261007/README.md) completed all six original-source workloads and five independently initialized stages: `shape-temporal`, `shape-temporal-replica`, `shape-temporal-replica-tiling`, `full-joint`, and `full-joint-fission`. All 30 stage results passed native replay, numeric, and independent trace checks. S4 fusion and S5 fission add no measured improvement in this run; the [fresh-agent instructions](docs/FRESH_AGENT_FUSION_FISSION_20261007.md) identify the remaining investigation.

Fixed1x1, ORBIT stages, and the latest common-DFG AMOEBA comparison use the same canonical DFG/mapper, ORBIT production scheduler, critical-path dispatch, and explicit network timing. AMOEBA retains original F45 allocation choices and the accepted full-parent/N replica estimate. Five AMOEBA results are verified; the common-DFG Ray result remains pending. Ray uses the authorized II23 diagnostic architecture while model training and normalization stay20. Its fixed1x1 row is compiler-proved N/A. Target SRAM admission remains pending and `formal_go=false`. Earlier cohorts and their distinct scheduler/stage definitions remain historical.

- [Experiment and results](docs/INPUT0_NEIGHBORHOOD_ABLATION.md)
- [Portable build and reproduction](docs/INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md)
- [Original AMOEBA input-0 and Ray II23 diagnostic](docs/ORIGINAL_AMOEBA_INPUT0.md)
- [Fusion/fission next-agent prompt](docs/FRESH_AGENT_FUSION_FISSION_20261007.md)
- [ORBIT compiler source](https://github.com/guosran/orbit)
- [Complete source inputs and caller evidence](reference/input0-source-domains/manifest.json)
- [Iteration-domain audit](reference/input0-neighborhood/evidence/iteration-domain-audit.json)

S1 combines shape search with the ORBIT production spatial-temporal scheduler and its critical-path dispatch policy; S2 adds replica, S3 tiling, S4 fusion and S5 generic source fission. The scheduler computes dependency-, resource- and network-ready start cycles. Search does not enumerate every dispatch order or arbitrary start time, and beam width 16 counts complete programs rather than tasks. Each stage starts from the same canonical input and searches all enabled dimensions. Historical results retain their original scheduler and stage labels.

The search budget is four rounds and 4,096 unique complete candidate scores per stage, beam width 16 with four diversity slots, and a five-candidate native shortlist plus identity control. Replica and tiling factors are 1, 2, 4 and 8. Results are best-found production scheduler cycles using actual mapper II. Numeric, mapper equality, trace and SRAM are recorded separately.

Generic source fission is an S5 search dimension for all six original programs. The specialized Ray Task13 carried best/index split remains a separate experiment; it does not replace the original unsplit 27-task main input. Historical fission results retain their original stage labels.

On the experiment host, query the latest measured stages, fixed 1×1 baseline and validated AMOEBA cycles:

```sh
python3 scripts/show_input0_current_queue.py
```

This read-only host viewer requires the preserved exact runtime bindings and evidence; a clean clone should read the [published R9 table and receipts](diagnostics/input0-memory-fusion-fission-r9-20261007/README.md). Local paths in captured receipts are provenance, not portable cache bindings. Reproductions must build a new optimizer and generate fresh contracts and outputs. The older `show_input0_results.py` retains earlier cohort views.

Use `--historical-v19`, `--historical-v38`, `--historical-v57`, or `--historical-v58` with the viewer to inspect archived cohorts. Their recorded stage order and labels are retained.

The separate [Joint versus Sequential](docs/SEQUENTIAL_COMPARISON.md) experiment compares simultaneous decisions with graph-then-resource decisions using one shared 4,096 production-scheduler-call allowance, identical fixed frontier quotas, private caches and identical real-mapper validation. Its preselected main split is 50/50; 25/75 and 75/25 are budget-allocation sensitivity runs. It does not reuse an S5 result as its Joint arm. The active batch uses [verified runtime acceleration and lossless compaction](docs/SEQUENTIAL_RUNTIME_ACCELERATION.md); `python3 scripts/show_sequential_comparison.py` queries it once and exports audited results when complete.
