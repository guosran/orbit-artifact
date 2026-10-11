Source38 GCN Full action-family budget. Source37 is a different-policy reference.

| Family | v38 attempted | materialized | paid | zero | v37 attempted | materialized | paid | zero |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| canonical-reset | 174 | 174 | 1 | 173 | 126 | 126 | 1 | 125 |
| fission | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| fusion | 17620 | 0 | 0 | 17620 | 13394 | 0 | 0 | 13394 |
| fusion-plus-shape | 8813 | 0 | 0 | 8813 | 6757 | 0 | 0 | 6757 |
| fusion-plus-tiling | 8813 | 0 | 0 | 8813 | 6757 | 0 | 0 | 6757 |
| identity | 174 | 174 | 0 | 174 | 126 | 126 | 0 | 126 |
| k-tiling | 28794 | 0 | 0 | 28794 | 22428 | 0 | 0 | 22428 |
| lineage-replacement | 4792 | 156 | 2 | 4790 | 3108 | 246 | 29 | 3079 |
| producer-consumer-co-k-tiling | 26427 | 0 | 0 | 26427 | 20031 | 0 | 0 | 20031 |
| producer-consumer-co-tiling | 26427 | 0 | 0 | 26427 | 20031 | 0 | 0 | 20031 |
| replica | 62 | 58 | 58 | 4 | 59 | 51 | 51 | 8 |
| shape | 164 | 164 | 159 | 5 | 170 | 170 | 161 | 9 |
| sibling-fusion | 66173 | 0 | 0 | 66173 | 55134 | 0 | 0 | 55134 |
| tiling | 4137 | 39 | 35 | 4102 | 10753 | 29 | 13 | 10740 |
| tiling-plus-fusion | 8807 | 0 | 0 | 8807 | 6753 | 0 | 0 | 6753 |

A charged objective scheduler call, including a scheduler rejection. The canonical call is separate; 255 expansion calls plus canonical equals 256.

Attempted/materialized/paid distinguish tested materializer rejections from unattempted queue entries. Zero materialized tested edges does not prove every unattempted fusion edge is illegal.

complete_cut_action_count is the pass-start prepared-source legal-cut catalog. An empty catalog supplies no fission action to schedule; this is a limitation of the current legal domain.
Observed complete fission cuts: Source38 0, Source37 0.

Menu/generated queue counts can include the same unattempted edge at multiple refreshes. They are not counts of distinct legal materialized candidates.
