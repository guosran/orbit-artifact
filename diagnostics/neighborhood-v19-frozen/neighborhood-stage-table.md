| workload | stage | status | predicted_top5_cycles | native_stage_cycles | relative_to_s1_cycles | relative_to_previous_stage_cycles | unique_complete_candidates_scored | cache_hits | cache_misses | search_rounds | search_elapsed_seconds | stop_reason | numeric | trace | sram |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| llama | shape-only | native_replayed | [708219469, 708243863, 708260025, 708267752, 708269661] | 746619416 | 0 | None | 2158 | 19350 | 72 | 4 | 112.608 | max-rounds | pass | pass | pending |
| llama | shape-temporal | native_replayed | [708219469, 708243863, 708260025, 708267752, 708269661] | 746619416 | 0 | 0 | 2158 | 19350 | 72 | 4 | 109.91 | max-rounds | pass | pass | pending |
| llama | shape-temporal-replica | native_replayed | [615140794, 616593101, 622866444, 623159840, 623159840] | 720929306 | -25690110 | -25690110 | 3926 | 55786 | 680 | 4 | 367.397 | max-rounds | pass | pass | pending |
| llama | shape-temporal-replica-tiling | native_replayed | [609354416, 609362143, 609365879, 609370153, 609386537] | 720929306 | -25690110 | 0 | 4096 | 64801 | 260 | 3 | 670.413 | max-unique-candidates | pass | pass | pending |
| llama | full-joint | native_replayed | [609354416, 609362143, 609365879, 609370153, 609386537] | 720929306 | -25690110 | 0 | 4096 | 64801 | 260 | 3 | 740.461 | max-unique-candidates | pass | pass | pending |
| lu | shape-only | native_replayed | [13129, 13228, 13244, 13255, 13268] | 10261 | 0 | None | 2230 | 19998 | 72 | 4 | 115.151 | max-rounds | pass | pass | pending |
| lu | shape-temporal | native_replayed | [13048, 13048, 13048, 13048, 13048] | 10261 | 0 | 0 | 2214 | 19854 | 72 | 4 | 122.742 | max-rounds | pass | pass | pass |
| lu | shape-temporal-replica | native_replayed | [12991, 12991, 12991, 12991, 12991] | 10261 | 0 | 0 | 3340 | 41283 | 558 | 4 | 311.926 | max-rounds | pass | pass | pending |
| lu | shape-temporal-replica-tiling | native_replayed | [12199, 12199, 12199, 12199, 12199] | 9925 | -336 | -336 | 4096 | 56524 | 2426 | 3 | 464.259 | max-unique-candidates | pass | pass | pending |
| lu | full-joint | native_replayed | [12199, 12199, 12199, 12199, 12199] | 9925 | -336 | 0 | 4096 | 66244 | 1566 | 3 | 582.784 | max-unique-candidates | pass | pass | pending |
| harris | shape-only | native_replayed | [757647, 758013, 758119, 758413, 758415] | 840477 | 0 | None | 4096 | 98112 | 192 | 2 | 376.399 | max-unique-candidates | pass | pass | pending |
| harris | shape-temporal | native_replayed | [745357, 745402, 745518, 745655, 745803] | 816790 | -23687 | -23687 | 4096 | 98112 | 192 | 2 | 421.441 | max-unique-candidates | pass | pass | pending |
| harris | shape-temporal-replica | native_replayed | [716103, 716110, 716209, 716217, 716250] | 783277 | -57200 | -33513 | 4096 | 59446 | 48785 | 1 | 984.995 | max-unique-candidates | pass | pass | pending |
| harris | shape-temporal-replica-tiling | native_replayed | [571551, 571938, 573191, 573281, 573499] | 632869 | -207608 | -150408 | 4096 | 51576 | 77373 | 1 | 1725.689 | max-unique-candidates | pass | pass | pending |
| harris | full-joint | native_replayed | [461467, 461531, 461775, 461839, 462470] | 523483 | -316994 | -109386 | 4096 | 63451 | 77781 | 1 | 2119.48 | max-unique-candidates | pass | pass | pending |
| radar | shape-only | native_replayed | [1173170, 1173380, 1173398, 1173458, 1173507] | 1172191 | 0 | None | 4096 | 85848 | 168 | 2 | 329.396 | max-unique-candidates | pass | pass | pending |
| radar | shape-temporal | native_replayed | [1173170, 1173380, 1173398, 1173458, 1173507] | 1172191 | 0 | 0 | 4096 | 85848 | 168 | 2 | 345.985 | max-unique-candidates | pass | pass | pending |
| radar | shape-temporal-replica | native_replayed | [1173170, 1173380, 1173398, 1173458, 1173507] | 1172191 | 0 | 0 | 4096 | 85848 | 168 | 2 | 406.6 | max-unique-candidates | pass | pass | pending |
| radar | shape-temporal-replica-tiling | native_replayed | [1173170, 1173380, 1173398, 1173458, 1173507] | 1172191 | 0 | 0 | 4096 | 85848 | 168 | 2 | 605.743 | max-unique-candidates | pass | pass | pending |
| radar | full-joint | native_replayed | [1173170, 1173380, 1173398, 1173458, 1173507] | 1172191 | 0 | 0 | 4096 | 85848 | 168 | 2 | 689.37 | max-unique-candidates | pass | pass | pending |
| gcn | shape-only | native_replayed | [79169, 79183, 79183, 79183, 79184] | 74310 | 0 | None | 4096 | 114464 | 224 | 2 | 1361.677 | max-unique-candidates | pass | pass | pending |
| gcn | shape-temporal | native_replayed | [78916, 78916, 78916, 78916, 78916] | 74304 | -6 | -6 | 4096 | 114464 | 224 | 2 | 1331.872 | max-unique-candidates | pass | pass | pending |
| gcn | shape-temporal-replica | native_replayed | [77331, 77331, 77331, 77393, 77395] | 72988 | -1322 | -1316 | 4096 | 116184 | 1723 | 2 | 1638.695 | max-unique-candidates | pass | pass | pending |
| gcn | shape-temporal-replica-tiling | native_replayed | [77089, 77090, 77091, 77091, 77091] | 72984 | -1326 | -4 | 4096 | 129608 | 670 | 2 | 3671.886 | max-unique-candidates | pass | pass | pending |
| gcn | full-joint | native_replayed | [76870, 76870, 76870, 76872, 76872] | 72984 | -1326 | 0 | 4096 | 129608 | 670 | 2 | 4105.215 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-only | native_replayed | [132819, 132921, 132925, 132930, 132931] | 136995 | 0 | None | 4096 | 110712 | 216 | 2 | 966.676 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-temporal | native_replayed | [130739, 130739, 130739, 130739, 130739] | 131110 | -5885 | -5885 | 4096 | 110614 | 216 | 2 | 1079.081 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-temporal-replica | native_replayed | [128792, 128792, 128792, 128792, 128792] | 131110 | -5885 | 0 | 4096 | 110712 | 216 | 2 | 1293.125 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-temporal-replica-tiling | native_replayed | [128792, 128792, 128792, 128792, 128792] | 131110 | -5885 | 0 | 4096 | 110712 | 216 | 2 | 1528.913 | max-unique-candidates | pass | pass | pending |
| raytracing | full-joint | native_replayed | [128792, 128792, 128792, 128792, 128792] | 131110 | -5885 | 0 | 4096 | 110712 | 216 | 2 | 2962.168 | max-unique-candidates | pass | pass | pending |

Native controls and transformation records are retained in the JSON machine table.
