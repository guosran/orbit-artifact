LLaMA 路径审计：所有数据来自既有档案，未增加搜索、预测或mapper预算。

Joint 479,470,611 cycles；Sequential 50/50 435,570,204 cycles；Sequential / Joint = 0.908440。
Sequential winner neighborhood-59061，完整图canonical等价匹配 0，完整图及资源配置匹配 0；Joint graph witnesses 1426。

| 相同typed动作前缀长度 | Joint候选 | 父候选 | round | 预测makespan | 直接archive子候选数 |
|---:|---|---|---:|---:|---:|
| 1 | neighborhood-155 | neighborhood-0 | 0 | 988800132 | 289 |
| 2 | neighborhood-3791 | neighborhood-155 | 1 | 902494473 | 0 |

按pinned控制器重建增量beam，每个prefix选择均与完整已评分prefix选择一致；下一轮父候选集合与原档案完全相同。
round 0: neighborhood-155 为第9个合法child，已评分9个child中rank3；实际增量保留输入9项中rank3；下一轮beam保留=True。
round 1: neighborhood-3791 为第64个合法child，已评分64个child中rank44；实际增量保留输入17项中rank17；下一轮beam保留=False。

第二步候选合法且已经评估，失去的是beam扩展机会，永久archive仍保留。最终两种方案的预测排序方向与真实mapper排序一致。member SHA256和大小逐项核验；tar SHA为本次审计身份，历史manifest绑定的是各未压缩member。
