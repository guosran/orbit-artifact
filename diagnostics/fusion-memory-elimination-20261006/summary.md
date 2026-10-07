Radar Task_4 + Task_5 sibling fusion removes 4 of 8 loads and preserves 2 output stores. Original individual II: 7 and 7. Fused II: 12 on 1x1; 9 on 1x2.

With the same total 8 PEs, the 1x2 fused candidate costs 1,579,954 native cycles, compared with 1,317,811 for the original fixed1x1 program (+262,143; +19.89%). Native mapper equality, independent trace, and full input0 numeric checks pass. This is an explicit candidate, not a search winner.

Retained producer-consumer fusion removes one load and preserves public output stores: Harris Task_0+Task_1 loads 4→3, stores 2→2; Radar Task_16+Task_17 loads 6→5, stores 2→2. Private storage forwarding removes the paired store/load; public-storage forwarded modes are rejected.
