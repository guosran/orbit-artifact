# Completed input0 R9 memory fusion/fission experiment

Six original-source workloads completed five independently initialized stages. All 30 stage results passed native replay, numeric, independent trace, and the bound receipt checks. This is a captured diagnostic, not a formal performance GO.

| Program | Fixed1x1 | AMOEBA common DFG | S1 | S2 | S3 | S4 | S5 |
|---|---:|---:|---:|---:|---:|---:|---:|
| llama | 1,129,656,837 | 757,412,371 | 762,655,252 | 595,551,249 | 424,250,388 | 424,250,388 | 424,250,388 |
| lu | 18,501 | 9,811 | 11,347 | 9,486 | 9,486 | 9,486 | 9,486 |
| harris | 988,258 | 926,769 | 941,012 | 899,620 | 621,600 | 621,600 | 621,600 |
| radar | 1,317,811 | 1,317,811 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 |
| gcn | 95,775 | 83,802 | 89,388 | 86,987 | 86,987 | 86,987 | 86,987 |
| raytracing | N/A | pending | 176,711 | 176,711 | 176,711 | 176,711 | 176,711 |

S1 shape plus spatial-temporal scheduling; S2 adds replica; S3 tiling; S4 fusion; S5 generic source fission. Each stage starts from the same original canonical input and explores all enabled dimensions. The budget is four rounds, 4096 unique candidate scores, beam16/diversity4, and native top5 plus controls.

S4 and S5 add no measured improvement in this run. This does not establish that fusion/fission cannot help: action legality, generation, model scoring, beam retention, native ranking, and resource/communication costs require separate analysis. See [fresh-agent work instructions](../../docs/FRESH_AGENT_FUSION_FISSION_20261007.md).

Original Ray is the unsplit 27-task input; Task13 specialized carried fission remains a separate supplement. Ray uses the authorized runtime-II23 diagnostic YAML while training/normalization stay20. Its fixed1x1 Task13 lower bound83 exceeds23, so that row is compiler-proved N/A and was not mapped. Common-AMOEBA Ray is still pending.

The AMOEBA comparison uses the common canonical DFG/mapper, retained original F45 allocations, and shared ORBIT scheduling/network, with the accepted parent/N replica duration policy.

[Summary](summary.json) and [captured stage receipts](stage-receipts.json) retain local raw evidence paths as provenance. They are not reusable clean-clone bindings. A changed source, binary, script, model, or architecture requires a fresh contract/output root. Target SRAM admission remains pending; formal_go=false.
