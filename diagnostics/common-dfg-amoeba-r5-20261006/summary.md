公共 DFG AMOEBA input0 对照已完成。五个程序均通过 mapper 包装与源语义绑定、独立网络 trace 和实际 native 整程序数值验证。

| 程序 | 固定1x1 cycles | AMOEBA cycles |
| --- | ---: | ---: |
| gcn | 95,775 | 83,802 |
| harris | 988,258 | 926,769 |
| llama | 1,129,656,837 | 757,412,371 |
| lu | 18,501 | 9,811 |
| radar | 1,317,811 | 1,317,811 |

资源分配来自原 F45；公共 mapper 对相同 canonical DFG 测量 parent，replica 按原 AMOEBA 规则取 ceil(parent cycles / N)。最终摆放、dispatch 与通信由共同 ORBIT production scheduler 计算。

这轮 Radar 的 AMOEBA 与固定1x1完全相同，先前由不同 DFG 产生的对照差异已经排除。GCN 的 AMOEBA 比固定1x1更快，不能把 AMOEBA 一概归为较慢。

formal_go=false。VectorCGRA 的参考配置测得128 payload bytes/CGRA；当前容量检查给出 pending，尚无实际驻留/流式访问证明。
