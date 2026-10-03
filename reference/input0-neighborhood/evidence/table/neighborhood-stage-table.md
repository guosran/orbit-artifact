| workload | stage | status | predicted_top5_cycles | native_stage_cycles | relative_to_s1_cycles | relative_to_previous_stage_cycles | unique_complete_candidates_scored | cache_hits | cache_misses | search_rounds | search_elapsed_seconds | stop_reason | numeric | trace | sram |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| gcn | shape-only | native_replayed | [924396, 924397, 924397, 924398, 924398] | 915641 | 0 | None | 1024 | 28448 | 224 | 1 | 724.027 | max-unique-candidates | pass | pass | pending |
| gcn | shape-temporal | native_replayed | [924209, 924209, 924210, 924211, 924211] | 915639 | -2 | -2 | 1024 | 28448 | 224 | 1 | 573.406 | max-unique-candidates | pass | pass | pending |
| gcn | shape-temporal-replica | native_replayed | [924024, 924025, 924025, 924025, 924030] | 915638 | -3 | -1 | 1024 | 28448 | 224 | 1 | 589.716 | max-unique-candidates | pass | pass | pending |
| gcn | shape-temporal-replica-tiling | native_replayed | [923846, 923847, 923852, 923852, 923852] | 915638 | -3 | 0 | 1024 | 27771 | 1081 | 1 | 730.46 | max-unique-candidates | pass | pass | pending |
| gcn | full-joint | native_replayed | [923674, 923674, 923674, 923674, 923676] | 915638 | -3 | 0 | 1024 | 27202 | 1865 | 1 | 858.75 | max-unique-candidates | pass | pass | pending |
| harris | shape-only | native_replayed | [762968, 763074, 763734, 763840, 764229] | 839846 | 0 | None | 1024 | 24384 | 192 | 1 | 96.263 | max-unique-candidates | pass | pass | pending |
| harris | shape-temporal | native_replayed | [755494, 755539, 755539, 755982, 756011] | 816791 | -23055 | -23055 | 1024 | 24384 | 192 | 1 | 120.553 | max-unique-candidates | pass | pass | pending |
| harris | shape-temporal-replica | native_replayed | [726241, 726346, 728548, 728698, 728763] | 781760 | -58086 | -35031 | 1024 | 17236 | 8765 | 1 | 207.8 | max-unique-candidates | pass | pass | pending |
| harris | shape-temporal-replica-tiling | native_replayed | [518904, 519212, 519291, 519599, 553407] | 573628 | -266218 | -208132 | 1024 | 10850 | 22729 | 0 | 564.929 | max-unique-candidates | pass | pass | pending |
| harris | full-joint | native_replayed | [466899, 466985, 469282, 469368, 471325] | 523090 | -316756 | -50538 | 1024 | 12034 | 22531 | 0 | 602.712 | max-unique-candidates | pass | pass | pending |
| llama | shape-only | native_replayed | [532821411, 532821411, 532821411, 532821411, 532821411] | 563610138 | 0 | None | 1024 | 9144 | 72 | 2 | 38.52 | max-unique-candidates | pass | pass | pending |
| llama | shape-temporal | native_replayed | [532821411, 532821411, 532821411, 532821411, 532821411] | 563610138 | 0 | 0 | 1024 | 9144 | 72 | 2 | 39.788 | max-unique-candidates | pass | pass | pending |
| llama | shape-temporal-replica | native_replayed | [532929773, 532929773, 532929773, 539973193, 539973193] | 563610138 | 0 | 0 | 1024 | 9178 | 170 | 1 | 34.011 | max-unique-candidates | pass | pass | pending |
| llama | shape-temporal-replica-tiling | native_replayed | [401061088, 401061088, 401061088, 401061088, 401061089] | 440265239 | -123344899 | -123344899 | 1024 | 12198 | 2234 | 1 | 216.852 | max-unique-candidates | pass | pass | pending |
| llama | full-joint | native_replayed | [357435935, 357435935, 357435935, 357435935, 357435935] | 394200603 | -169409535 | -46064636 | 1024 | 13545 | 3402 | 1 | 448.568 | max-unique-candidates | pass | pass | pending |
| lu | shape-only | native_replayed | [7599, 7599, 7599, 7599, 7599] | 6277 | 0 | None | 1024 | 9072 | 144 | 2 | 75.161 | max-unique-candidates | pass | pass | pass |
| lu | shape-temporal | native_replayed | [7599, 7599, 7599, 7599, 7599] | 6277 | 0 | 0 | 1024 | 9072 | 144 | 2 | 71.113 | max-unique-candidates | pass | pass | pass |
| lu | shape-temporal-replica | native_replayed | [7550, 7550, 7550, 7550, 7550] | 6230 | -47 | -47 | 1024 | 9205 | 468 | 2 | 81.552 | max-unique-candidates | pass | pass | pass |
| lu | shape-temporal-replica-tiling | native_replayed | [6765, 6765, 6767, 6767, 6767] | 5445 | -832 | -785 | 1024 | 13460 | 2240 | 1 | 222.924 | max-unique-candidates | pass | pass | pass |
| lu | full-joint | native_replayed | [6758, 6758, 6758, 6758, 6758] | 5438 | -839 | -7 | 1024 | 18574 | 1077 | 1 | 300.621 | max-unique-candidates | pass | pass | pending |
| radar | shape-only | native_replayed | [363230, 363247, 363296, 363297, 363346] | 351980 | 0 | None | 1024 | 21336 | 168 | 1 | 137.65 | max-unique-candidates | pass | pass | pending |
| radar | shape-temporal | native_replayed | [360621, 360638, 360679, 360688, 360696] | 349933 | -2047 | -2047 | 1024 | 21336 | 168 | 1 | 116.979 | max-unique-candidates | pass | pass | pending |
| radar | shape-temporal-replica | native_replayed | [355547, 355547, 355547, 355547, 356514] | 344848 | -7132 | -5085 | 1024 | 20658 | 1558 | 1 | 168.747 | max-unique-candidates | pass | pass | pending |
| radar | shape-temporal-replica-tiling | native_replayed | [354492, 354592, 354630, 354711, 354730] | 344847 | -7133 | -1 | 1024 | 25015 | 395 | 1 | 295.904 | max-unique-candidates | pass | pass | pending |
| radar | full-joint | native_replayed | [346186, 349022, 349141, 349160, 349196] | 333755 | -18225 | -11092 | 1024 | 21822 | 1971 | 1 | 308.404 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-only | native_replayed | [123400, 123502, 123506, 123511, 123512] | 128138 | 0 | None | 1024 | 27432 | 216 | 1 | 445.089 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-temporal | native_replayed | [122387, 122387, 122387, 122387, 122387] | 128138 | 0 | 0 | 1024 | 27432 | 216 | 1 | 669.873 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-temporal-replica | native_replayed | [121211, 121211, 121211, 121211, 121211] | 128138 | 0 | 0 | 1024 | 27432 | 216 | 1 | 535.75 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-temporal-replica-tiling | native_replayed | [120010, 120010, 120010, 120010, 120010] | 128138 | 0 | 0 | 1024 | 27432 | 216 | 1 | 568.791 | max-unique-candidates | pass | pass | pending |
| raytracing | full-joint | native_replayed | [123400, 123502, 123506, 123544, 123608] | 128138 | 0 | 0 | 1024 | 26004 | 1372 | 1 | 484.05 | max-unique-candidates | pass | pass | pending |

Native controls and transformation records are retained in the JSON machine table.
