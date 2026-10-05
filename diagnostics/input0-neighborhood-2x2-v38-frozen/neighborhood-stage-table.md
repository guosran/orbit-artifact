| workload | stage | status | predicted_top5_cycles | native_stage_cycles | relative_to_s1_cycles | relative_to_previous_stage_cycles | unique_complete_candidates_scored | cache_hits | cache_misses | search_rounds | search_elapsed_seconds | stop_reason | numeric | trace | sram |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| llama | shape-only | native_replayed | [682338116, 684909266, 687532480, 689115617, 690103630] | 762655252 | 0 | None | 2274 | 20394 | 72 | 4 | 254.637 | max-rounds | pass | pass | pending |
| llama | shape-temporal | native_replayed | [605448235, 605789674, 605789674, 605789674, 605789674] | 704983574 | -57671678 | -57671678 | 2289 | 20529 | 72 | 4 | 162.662 | max-rounds | pass | pass | pending |
| llama | shape-temporal-replica | native_replayed | [456258848, 456258848, 456258848, 456258848, 456258848] | 549902875 | -212752377 | -155080699 | 4096 | 38592 | 18083 | 3 | 719.059 | max-unique-candidates | pass | pass | pending |
| llama | shape-temporal-replica-tiling | native_replayed | [399748371, 399748371, 399748371, 399748371, 399748371] | 497281562 | -265373690 | -52621313 | 4096 | 54105 | 9026 | 3 | 1129.322 | max-unique-candidates | pass | pass | pending |
| llama | full-joint | native_replayed | [399669419, 399748370, 399748370, 399748371, 404049337] | 497179163 | -265476089 | -102399 | 4096 | 75615 | 6490 | 3 | 2276.576 | max-unique-candidates | pass | pass | pending |
| lu | shape-only | native_replayed | [10910, 11145, 11186, 11188, 11249] | 11347 | 0 | None | 2211 | 19827 | 72 | 4 | 249.507 | max-rounds | pass | pass | pending |
| lu | shape-temporal | native_replayed | [10711, 10711, 10711, 10711, 10711] | 11283 | -64 | -64 | 2250 | 20178 | 72 | 4 | 156.438 | max-rounds | pass | pass | pending |
| lu | shape-temporal-replica | native_replayed | [8911, 8911, 8911, 8911, 8911] | 9663 | -1684 | -1620 | 4096 | 56202 | 1879 | 3 | 976.394 | max-unique-candidates | pass | pass | pending |
| lu | shape-temporal-replica-tiling | native_replayed | [7885, 7885, 8068, 8068, 8161] | 8594 | -2753 | -1069 | 4096 | 68169 | 709 | 3 | 1959.486 | max-unique-candidates | pass | pass | pending |
| lu | full-joint | native_replayed | [7706, 7706, 7706, 7706, 7706] | 8586 | -2761 | -8 | 4096 | 94172 | 2652 | 3 | 1935.226 | max-unique-candidates | pass | pass | pending |
| harris | shape-only | native_replayed | [941600, 941600, 942050, 942050, 942083] | 933326 | 0 | None | 4096 | 98174 | 130 | 3 | 527.117 | max-unique-candidates | pass | pass | pending |
| harris | shape-temporal | native_replayed | [902748, 902965, 903944, 903959, 903983] | 925389 | -7937 | -7937 | 4096 | 98178 | 126 | 3 | 428.77 | max-unique-candidates | pass | pass | pending |
| harris | shape-temporal-replica | native_replayed | [836966, 836972, 841033, 841033, 841039] | 851243 | -82083 | -74146 | 4096 | 90527 | 26747 | 3 | 1041.492 | max-unique-candidates | pass | pass | pending |
| harris | shape-temporal-replica-tiling | native_replayed | [623750, 623750, 623820, 623968, 623969] | 625665 | -307661 | -225578 | 4096 | 32622 | 106635 | 3 | 165.406 | max-unique-candidates | pass | pass | pending |
| harris | full-joint | native_replayed | [552670, 552670, 552670, 552670, 553329] | 560137 | -373189 | -65528 | 4096 | 92144 | 68602 | 3 | 6330.628 | max-unique-candidates | pass | pass | pending |
| radar | shape-only | native_replayed | [1322656, 1322700, 1322914, 1322914, 1322958] | 1309621 | 0 | None | 4096 | 85772 | 244 | 3 | 545.191 | max-unique-candidates | pass | pass | pending |
| radar | shape-temporal | native_replayed | [1316858, 1316859, 1316859, 1316860, 1316880] | 1305305 | -4316 | -4316 | 4096 | 85893 | 123 | 3 | 1744.273 | max-unique-candidates | pass | pass | pending |
| radar | shape-temporal-replica | native_replayed | [1258059, 1258069, 1258073, 1258092, 1258104] | 1272539 | -37082 | -32766 | 4096 | 85890 | 126 | 3 | 2060.326 | max-unique-candidates | pass | pass | pending |
| radar | shape-temporal-replica-tiling | native_replayed | [1026316, 1026369, 1026378, 1026431, 1026432] | 1141467 | -168154 | -131072 | 4096 | 85888 | 128 | 3 | 2082.49 | max-unique-candidates | pass | pass | pending |
| radar | full-joint | native_replayed | [1018648, 1018649, 1018649, 1018649, 1018649] | 1141467 | -168154 | 0 | 4096 | 85895 | 121 | 3 | 1284.315 | max-unique-candidates | pass | pass | pending |
| gcn | shape-only | native_replayed | [91069, 91069, 91069, 91069, 91069] | 89389 | 0 | None | 4096 | 114424 | 264 | 3 | 1613.004 | max-unique-candidates | pass | pass | pending |
| gcn | shape-temporal | native_replayed | [85412, 85412, 85412, 85417, 85417] | 84199 | -5190 | -5190 | 4096 | 114548 | 140 | 3 | 1566.102 | max-unique-candidates | pass | pass | pending |
| gcn | shape-temporal-replica | native_replayed | [78235, 78235, 78268, 78268, 78297] | 78138 | -11251 | -6061 | 4096 | 115212 | 17715 | 3 | 3502.468 | max-unique-candidates | pass | pass | pending |
| gcn | shape-temporal-replica-tiling | native_replayed | [75783, 75813, 75814, 75818, 75843] | 76492 | -12897 | -1646 | 4096 | 143172 | 5818 | 3 | 10098.915 | max-unique-candidates | pass | pass | pending |
| gcn | full-joint | native_replayed | [74993, 74993, 74993, 74995, 74995] | 76262 | -13127 | -230 | 4096 | 167983 | 1499 | 3 | 18202.738 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-only | unsupported_model_domain | None | None | None | None | None | None | None | None | None | unsupported_model_domain | not_applicable | not_applicable | not_applicable |
| raytracing | shape-temporal | unsupported_model_domain | None | None | None | None | None | None | None | None | None | unsupported_model_domain | not_applicable | not_applicable | not_applicable |
| raytracing | shape-temporal-replica | unsupported_model_domain | None | None | None | None | None | None | None | None | None | unsupported_model_domain | not_applicable | not_applicable | not_applicable |
| raytracing | shape-temporal-replica-tiling | unsupported_model_domain | None | None | None | None | None | None | None | None | None | unsupported_model_domain | not_applicable | not_applicable | not_applicable |
| raytracing | full-joint | unsupported_model_domain | None | None | None | None | None | None | None | None | None | unsupported_model_domain | not_applicable | not_applicable | not_applicable |

Native controls and transformation records are retained in the JSON machine table.
