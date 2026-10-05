| workload | stage | status | predicted_top5_cycles | native_stage_cycles | relative_to_s1_cycles | relative_to_previous_stage_cycles | unique_complete_candidates_scored | cache_hits | cache_misses | search_rounds | search_elapsed_seconds | stop_reason | numeric | trace | sram |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| raytracing | shape-only | native_replayed | [209549, 209565, 209587, 209593, 209607] | 187013 | 0 | None | 4096 | 115596 | 140 | 3 | 1420.054 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-temporal | native_replayed | [195846, 195846, 195846, 195846, 195846] | 178187 | -8826 | -8826 | 4096 | 115925 | 140 | 3 | 1592.992 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-temporal-replica | native_replayed | [184702, 184702, 184702, 184702, 184702] | 172303 | -14710 | -5884 | 4096 | 115925 | 140 | 3 | 1749.297 | max-unique-candidates | pass | pass | pending |
| raytracing | shape-temporal-replica-tiling | native_replayed | [174065, 174065, 174065, 174150, 174150] | 164948 | -22065 | -7355 | 4096 | 115925 | 140 | 3 | 2403.171 | max-unique-candidates | pass | pass | pending |
| raytracing | full-joint | native_replayed | [168273, 168328, 168332, 168387, 168428] | 162005 | -25008 | -2943 | 4096 | 115925 | 140 | 3 | 2877.953 | max-unique-candidates | pass | pass | pending |

Native controls and transformation records are retained in the JSON machine table.
