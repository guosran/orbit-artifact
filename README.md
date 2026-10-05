# ORBIT input-0 reproduction artifact

This artifact evaluates GCN, Harris, LLaMA, LU, Radar and Raytracing on their fixed input-0 programs. C++ MLIR owns budgeted whole-program neighborhood search, legal rewrites, deduplication, production scheduling with explicit communication, and the global predicted top five. Selected candidates then undergo real mapping, native scheduling, independent trace validation and numeric replay.

The current experiment uses the AMOEBA paper's 4×4 CGRA fabric with 2×2 PEs per CGRA and the `orbit-2x2-predictor` four-member direct ensemble. The v38 main ablation is complete: five measured program curves and five explicit out-of-model-domain cells for Raytracing. Its source-owned fission supplement also has all five measured stages. Native, mapper, numeric and independent trace checks pass; SRAM remains pending and formal GO is false. Completed v19 results remain historical diagnostics on the older 4×4-PE configuration.

- [Experiment and results](docs/INPUT0_NEIGHBORHOOD_ABLATION.md)
- [Portable build and reproduction](docs/INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md)
- [Original AMOEBA input-0 and Ray II23 diagnostic](docs/ORIGINAL_AMOEBA_INPUT0.md)
- [ORBIT compiler source](https://github.com/guosran/orbit)
- [Complete source inputs and caller evidence](reference/input0-source-domains/manifest.json)
- [Iteration-domain audit](reference/input0-neighborhood/evidence/iteration-domain-audit.json)

The corrected common budget is four rounds and 4,096 unique complete candidate scores per stage, beam width 16 with four diversity slots, and a five-candidate native shortlist plus identity and previous-winner controls. Replica and tiling factors are 1, 2, 4 and 8. Results are best-found production scheduler cycles using actual mapper II. Numeric, mapper equality, trace and SRAM are recorded separately.

Ray fission is a separate experiment. The source-owned pass splits the carried best/index reduction into ordered tasks with explicit state buffers. `prepare_input0_source_domains.py --ray-fission-split-at 4` reproduces the graph preparation; the main S1–S5 definitions remain unchanged.

View the measured stages, fixed 1×1 baseline and validated AMOEBA cycles:

```sh
python3 scripts/show_input0_results.py
```

The viewer reads live results when available and portable frozen evidence otherwise. Mapper profile completion is separate from whole-program cycle validation. AMOEBA retains its original allocation and dispatch decisions and its replica duration estimate; its reported cycles use the common network and source-certified work in a fixed-decision retiming check. All five standard programs and the separate Ray II23 diagnostic pass. The [baseline comparison](diagnostics/input0-baseline-comparison-2x2/README.md) and [archived-parent replay](docs/ORIGINAL_AMOEBA_INPUT0.md#replay-archived-parent-measurements) are portable.
