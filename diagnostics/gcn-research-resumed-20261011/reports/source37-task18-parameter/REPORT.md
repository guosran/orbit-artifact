# Source37 Replica: Task18 parameter opportunity

Winner1978 inherits Task18=1×3 from child1505, generated from parent795 in round5. The original parent catalogue already supports2×2 and predicts a shorter local duration.

| Shape | Predicted II | Startup | Predicted duration (400 trips) | Geometry penalty | Order |
|---|---:|---:|---:|---:|---:|
| 1×2 | 6.768088 | 9 | 2710 | 1 | 1 |
| 2×1 | 6.853718 | 9 | 2744 | 1 | 2 |
| 1×3 | 6.279234 | 9 | 2515 | 2 | 3 |
| 2×2 | 4.739610 | 9 | 1901 | 2 | 4 |
| 3×1 | 6.337876 | 9 | 2538 | 2 | 5 |
| 1×4 | 5.783475 | 9 | 2317 | 3 | 6 |
| 4×1 | 5.843132 | 9 | 2341 | 3 | 7 |
| 1×1 | 9.818808 | 9 | 3927 | 1e+08 | 8 |

In round5, compute chooses Task8; communication chooses Task18. Its three parameter signatures are1×2,2×1,1×3. Cached2×2 is fourth under Manhattan distance, then lexical action signature; the parameter selector does not rank by cached duration. Calls75/76/77 score the first three; no2×2 attempt occurs from the exact same parent key.

The shape-direction window has allowance4 but closes with charged3/unused1 at refresh6. Calls78/79 are assigned to other parents to satisfy the remaining original-charge reserve. The next-round Task18 direction has2×2 first in rounds6/7, so the three-parameter limit does not permanently erase it. Parent795 remains in the beam but receives zero attempts in both rounds; it is pruned at refresh8.

The retained communication-window pool requires zero previous attempts for the parent/family/target. Task18 already has three, so parent795’s pool switches to Task12 in rounds6/7. The ordinary Task18 direction remains, but it receives no service before retirement. Existing windows instead go to other retained parents; REPORT.json records all relevant window and charged-attempt events.

The cached local duration is1,901 for2×2 versus2,515 for1×3 (614 lower). This identifies available local information and a lost actual search opportunity. It does not establish the unscored child’s whole-program native cost or a guaranteed794-cycle repair. No new score, mapper, scheduler, numeric run, checkpoint read, or live Full access occurred.

Source: [parameter penalty](/home/shiran/project/orbit-repair-study/directional-old-parent-communication-shape-window-source/lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp:6361), [three-parameter selection](/home/shiran/project/orbit-repair-study/directional-old-parent-communication-shape-window-source/lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp:6540), [unserved target filter](/home/shiran/project/orbit-repair-study/directional-old-parent-communication-shape-window-source/lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp:6570), [parent-tier feedback selection](/home/shiran/project/orbit-repair-study/directional-old-parent-communication-shape-window-source/lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp:6785).
