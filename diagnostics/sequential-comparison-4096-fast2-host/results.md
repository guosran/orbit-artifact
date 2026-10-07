# Joint versus Sequential

>1 in Sequential/Joint favors Joint. Main ratio is preselected 50/50.

| Program | Joint cycles | Sequential cycles | Sequential/Joint | Joint search s | Sequential search s | Joint / Seq objective calls | Joint / Seq mapper calls |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| gcn | 79,801 | 85,363 | 1.0697 | 12410.22 | 3499.28 | 4096 / 2053 | 54 / 53 |
| harris | 480,727 | 546,937 | 1.1377 | 3368.48 | 2588.15 | 4096 / 4096 | 58 / 51 |
| llama | 479,470,611 | 435,570,204 | 0.9084 | 6414.47 | 3101.98 | 4096 / 4096 | 59 / 43 |
| lu | 9,798 | 9,094 | 0.9281 | 1834.93 | 950.47 | 4096 / 2262 | 44 / 33 |
| radar | 1,307,352 | 1,312,036 | 1.0036 | 1406.52 | 359.66 | 4096 / 2050 | 31 / 29 |
| Ray | N/A | N/A | N/A | — | — | — | — |

## Split sensitivity

| Program | 25/75 cycles | 50/50 cycles (main) | 75/25 cycles |
| --- | ---: | ---: | ---: |
| gcn | 82,902 | 85,363 | 88,559 |
| harris | 614,196 | 546,937 | 490,811 |
| llama | 482,735,635 | 435,570,204 | 462,153,231 |
| lu | 9,094 | 9,094 | 9,971 |
| radar | 1,309,399 | 1,312,036 | 1,313,715 |
