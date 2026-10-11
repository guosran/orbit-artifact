# Resumed GCN research, 11 October 2026

This addon preserves isolated GCN research. It does not change the published [Source35 four-program evaluation](../source35-four-workload-20261011/README.md) or paper results.

The Source37 Replica256 cell is verified: its original five finalists have native cycles **922559, 922560, 923358, 923358, 924554**, and all five pass strict numeric validation. Full256 is also verified at **931310 cycles**, a **+8751-cycle regression** against the same-version Replica cell. Its original five cycles are **931310, 932108, 932106, 932926, 932904**, with all five strict numeric checks passing. The policy is not admitted to the published evaluation. [results.csv](results.csv) retains both raw results.

Each cell independently starts from the same canonical program with a 256-objective-call cap. The original predicted five are validated in rank order, without replacements, a free known winner, or historical minima. Replica permits the cumulative shape/replica space; Full additionally permits tiling, fusion and source fission. Co-tiling belongs to tiling. The native mapper and scheduler are frozen.

| Role | Public ORBIT commit | Recorded optimizer SHA-256 |
|---|---|---|
| Source37 research search | `151cf509063bf93276665cea05fb71235f6dd123` | `1f20efe0dfc69881330b254e7f05fd437468f818e5ebb01f0117f758848de47d` |
| Native mapper/scheduler | `9e7015c3bd4d44dd2ec37df6f02c09aaa0372e55` | `80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761` |
| Historical Source35 search | `7c72cc4b4cd2d11f2c2449d8243dad93cf083067` | `2304dae3f8e1165950da939a84f58f5322371fa7edc74dd24ba5057991de4f6a` |

Source37 is public on [diagnostic/v37-old-parent-communication-shape-window](https://github.com/guosran/orbit/tree/151cf509063bf93276665cea05fb71235f6dd123), with policy `schedule-structure-retained-communication-shape-window-v37`. Captured search-protocol `source_commit=6a1b…` denotes the existing predictor/cost namespace; it is not the actual compiler commit. [protocol.json](protocol.json) records both identities separately.

The addon contains exact canonical/prepared program bytes, source/build receipts, normalized original-five native/numeric evidence and existing read-only reports:

- Source35 finalists and parent-retention reconstructions, preserving both v2 and v3;
- Source37 efficiency and materializer legality, with observation bounds;
- The Source35–Source37 Replica native difference: **+794 cycles** from an actual completing-chain difference of +798 compute and −4 transfer latency. Multiple selected shapes and placements changed, so this is not an isolated causal effect of one search rule;
- The same-version Full–Replica native difference: the actual completing-chain ledger sums to **+8751 cycles** (**+9177** from six tasks, **−433** from replication/tiling, **+7** transfer). This selected-combination comparison is not a single-rule counterfactual;
- The matched winner-path trace and rank/cut addendum: Full reached the first three Replica prefixes, but the next Task18 shape action was not tried before its parent was pruned;
- Task18's parameter-opportunity trace: a locally promising shape remained pending when its parent lost service. This is an observed search mechanism, not a native counterfactual result;
- Source35's original negative stages, including its **+5156-cycle** Full-versus-Replica regression.

The closed-pair performance report records Full search at 3312.20 seconds versus Replica at 295.97 seconds. Full made 165627 neighbor attempts, including 165372 zero-debit attempts; its 255 charged neighbors plus bootstrap still total 256 objective calls. Raw GNU time output is retained; its filesystem-output counter is not a retained file-size measurement.

The reports retain original seals and host provenance paths. [MANIFEST.json](MANIFEST.json) binds both completed cells and the matched comparison. The two prepared manifests and exact prior README/CSV/protocol/checker bytes are retained under `prepared-history/`; they describe earlier pending export states. Completing validation does not make this negative comparison a successful controller revision. No later search patch is included. The next isolated hypothesis prioritizes critical positive compute directions; its outcomes are outside this Source37 package.

```sh
python3 diagnostics/gcn-research-resumed-20261011/check_package.py
```

This command checks packaged hashes, source identities and recorded outcomes; it performs no experiment. The [portable build guide](../../docs/INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md) and public source pins identify the code needed for a fresh measurement. Captured absolute paths are historical provenance, not mandatory locations or a portable launcher. Large journals/checkpoints, ELF binaries and mapper caches stay on the experiment host. A fresh-machine end-to-end reproduction has not been tested for this addon.
