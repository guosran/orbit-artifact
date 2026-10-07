# 给 fresh agent 的接手 prompt：解决 fusion / fission

你接手 ORBIT / AMOEBA input0 的 fusion/fission 实现、搜索与实测收益问题。请直接执行调查、修复和验证，不只给计划。用户已经授权启动实验、agent team、多核并行、合理清理，以及正常 commit/push `guosran/orbit` 和 `guosran/orbit-artifact`；不需要重复询问。其他 Neura / Amoeba PR 边界继续遵守，不能把本任务混入那些 PR。

## 当前基线：已经完成，不要重启旧队列

- 源码：`/home/x/shiran/project/orbit`，本次已提交并推送 `ae6d3cc6205e2f26d7d13758144d55dcb8ed7b68`。先检查实际 Git/远端状态，不把这个日期快照当成覆盖新提交的许可。
- Artifact：`/home/x/shiran/project/orbit-artifact`，以包含本 prompt 的最新 `main` 为准。现有 sequential comparison 及其结果是独立实验，保留，不混用其预算或 winner。
- 构建：`/home/x/shiran/project/orbit-build-publication`；LLVM/MLIR：`/home/x/shiran/llvm-project/build`。
- 最新 R9 queue-v2 **已完成全部六程序×五阶段，30 个 stage 都通过 native、numeric、independent trace 和绑定校验**。旧 PID 934863 是已结束队列的历史记录，不能称为仍在跑。
- 公共结果：`diagnostics/input0-memory-fusion-fission-r9-20261007/{README.md,summary.json,stage-receipts.json}`。里面的本机路径是原始证据出处，不能直接成为 clean-clone 的可复用 binding。
- 原始结果根：`/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/results-original-ray-v6/input0-neighborhood-2x2-v60-memory-fusion-fission-r5-20261006`。
- 本机严格只读查询：`python3 /home/x/shiran/project/orbit-artifact/scripts/show_input0_current_queue.py`。

| 程序 | 固定1×1 | AMOEBA共同DFG | S1 | S2 | S3 | S4 fusion | S5 fission |
|---|---:|---:|---:|---:|---:|---:|---:|
| LLaMA | 1,129,656,837 | 757,412,371 | 762,655,252 | 595,551,249 | 424,250,388 | 424,250,388 | 424,250,388 |
| LU | 18,501 | 9,811 | 11,347 | 9,486 | 9,486 | 9,486 | 9,486 | 9,486 |
| Harris | 988,258 | 926,769 | 941,012 | 899,620 | 621,600 | 621,600 | 621,600 |
| Radar | 1,317,811 | 1,317,811 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 |
| GCN | 95,775 | 83,802 | 89,388 | 86,987 | 86,987 | 86,987 | 86,987 |
| 原版 Ray | N/A | pending | 176,711 | 176,711 | 176,711 | 176,711 | 176,711 |

所有数字是完整程序调度 cycles。S4/S5 与前阶段相同是本轮结果；这本身不能证明 transformation 无效，也不能证明没有可获益候选。要把合法性、生成、预测、beam、native shortlist、真实映射及资源代价分别查清。AMOEBA共同DFG五个结果已完成，不要重跑它们；共同DFG Ray 仍是单独的待完成项。

## 实验定义必须保持

S1=`shape-temporal`；S2=`shape-temporal-replica`；S3=`shape-temporal-replica-tiling`；S4=`full-joint`；S5=`full-joint-fission`。C++ 内部 S5 对应 stage number 6，历史 public 标签不要混淆。**每阶段从相同原版 canonical 独立初始化，搜索全部已开放维度**；不能从前阶段 winner/frontier 继续或用它当唯一 seed。预算 4 rounds / 4096 unique complete-program scores / beam16 / diversity4 / native top5 + controls。搜索有界，不宣称全局最优。

固定1×1、ORBIT 和当前 AMOEBA 对照使用共同 canonical DFG/mapper、ORBIT production spatial-temporal scheduler、critical-path dispatch、相同显式网络。AMOEBA保留原 F45 counts/shapes/replica 选择，采用用户接受的 `ceil(full common-parent mapped duration / active replicas)` 估算；不再要求 AMOEBA 实际 child 重新映射，也不能改成 II/N。原分配与新的共享后端摆放/dispatch 要分别记录。

硬件：4×4 CGRA，每个2×2 PE，共64 PE，context6、register32；标准运行II20。原版Ray使用授权的 `amoeba_4x4_cgra_2x2_context6_ctrlmem23_diagnostic.yaml`，仅 control-memory 20→23，训练、归一化和模型权重保持20，并记录外推。网络 `amoeba_4x4_mesh_latency1_bandwidth32.yaml`，48 directed links，latency1/bandwidth32/local32。VectorCGRA 的128 payload bytes/CGRA、合计2KiB仅是参考实例；AMOEBA target SRAM admission 仍pending，`formal_go=false`，这不能成为阻止合法 mapper/numeric 的理由。

总12核，affinity0–11，独立4核lane；完整compile/link **j1**。mapper没有墙钟timeout，不因慢杀进程；长期队列约300秒轮询。大输出写`/tmp`；闭合阶段清理未选中临时文件，保留winner、bindings、checkpoint、mapper/numeric/trace和失败证据。不 reset/clean/stash/tag/force-push，不SHA256，不RTL。新代码/脚本/模型/架构/二进制必须新pin、新contract、新output root；不要覆盖R9证据。写worker用独立worktree和明确ownership，主线程验收。

## 已证明和已修复的部分

1. **输入已纠正。** Ray主实验是 AMOEBA-Test 原版未切分27tasks，绝不是旧28tasks的specialized fission补充。`git show :Evaluation/Raytracing/L3/raytracing.mlir` 经参数0=1472的native binding，与artifact原源完整generic IR逐字节相同；固定lowering也精确复现canonical。当地AMOEBA-Test checkout没有HEAD，不能宣称已认证某个上游commit。证据在 `.work/source-fission-original-ray-repair-20261006/{upstream-source-check/summary.json,canonical-lowering-record.json}` 和 `diagnostics/original-ray-input-correction-20261006/`。
2. Ray固定1×1是**编译器证明的模型域N/A**：Task13单位CGRA II下界83>runtime23，未执行该基线mapper；不是搜不到S1，也不是mapper跑崩。当前原图S1–S5均有176711cycles。
3. PC fusion私有中间存储能消除producer store与consumer load；公共可观察输出必须保留store，但仍可消除已证明的consumer load。Harris Task0+Task1 loads4→3/stores2→2；Radar Task16+Task17 loads6→5/stores2→2。不能以任务合并或少一条通信边冒充删了ld/store，也不能删公共输出以制造收益。
4. Sibling fusion可以共享完全等价、无干扰写入的input read。Radar Task4+Task5 loads8→4，stores2→2。真实单CGRA fused II12，原各II7；同总8PE的fused1×2 II9仍是1579954cycles，比固定1×1的1317811慢19.89%。mapper equality/numeric/trace都通过。这个候选证明内存操作减少，不证明整体更快。公开证据 `diagnostics/fusion-memory-elimination-20261006/`。
5. 泛化fission已接入全部程序的搜索维度和source-owned census/replay；合法cuts为零可以诚实记录。本轮census：Harris30cuts（Task0）、LU1cut（Task0）、原版Ray56cuts（Task12=3、Task23=30、Task24=23）；LLaMA/Radar/GCN各0。Task13多输出carried recurrence目前generic不支持，不能放宽证明或预切原图。其specialized best/index两段split是独立补充，可以研究接入显式typed动作，但需要完整多输出/carry/source-work证明。
6. R9已修复fission后重建canonical导致无关parent shape丢失：同步保留parent shapes，Task13维持支持的4-CGRA。已实际score3个Ray泛化fission候选，一个retained candidate通过exact typed replay；这只是预检，不是收益结论。
7. 所有fresh预测路径已传递Ray runtimeII23；ML cache readback也按严格绑定的20/23 ceiling验证。曾经搜索支持23而cache硬编码20的bug已修复，不要再诊断为当前blocker。
8. Mapper feature提取显式generic printer，已证明同216queries及cache bytes不随全局print flag变化。过去custom wrapper中的`func.return`产生phantom DFG node的问题已修复。
9. 验证记录：25native source/fusion/fission/tamper checks；20/23cache roundtrip、非法ceilings/mixed-YAML拒绝与216query打印一致性；提交时artifact146项pytest通过。140个实现文件与实际R9 pin逐字节一致，public `reference/input0-neighborhood/source-file-list.json`已补齐140项。

## 接下来必须做的工作

最新只读审计已经核对：所有S4 native top5 history都没有fusion family，所有S5 shortlist的`fissionActions`都是空数组，最终winner只有shape/replica/tiling/co-tiling等动作。本轮大多在4096scored停止；LU S4/S5分别3553/3554、因max-rounds停止。保存的reject reasons是全family汇总，不能把其中大量materializer rejection全部归到fusion/fission。当前缺的就是这些动作具体在哪一层退出的证据。

一个明确的覆盖限制需要优先研究：`JointNeighborhoodSearchPass.cpp:1270–1316` 的 `canAddFission = actionHistory.actions.empty()`，以及 `materializeNeighbor`约3554–3565的同类检查，要求fission必须是ordinary actions之前的prefix。已做shape/replica/tile/fusion后不能再加fission。这是已确认的代码限制，是否导致本轮无收益还未证明。扩展时必须保留prepared source/canonical replay一致性，不能直接删guard后混用旧body/history。

先读取每程序S4/S5 `result.json`、`search_header/search_footer`、`search/search-summary.json`、`search/top5.jsonl`、`previous-winner.jsonl`及native records。其他候选日志按实际路径检查；部分未选中临时IR已经清理，需要额外诊断时用新output root保留所需记录。输出每程序每family的完整漏斗：census合法动作→生成→成功materialize→fresh-cost scored→去重/beam保留→进入global top5→native mapper成功→numeric/trace通过→最终selected。保留typed fission history及其不同于post-Neura动作的字段，不能只数普通`actions`误报零。

对S4/S5等于S3分别给出证据支持的原因。优先调查：shape/replica/tiling扩展是否在4096budget内挤掉fusion/fission；每个candidate的重写body是否确实fresh映射/预测；fused/split child是否保留正确shape/II/trips/startup和通信；功能合法动作是否被错误proof拒绝；预测是否严重低估/高估某类重写；typed replay/native shortlisting是否改变候选。不要看到cycles相同就选择一个猜测当结论。

从Harris/Radar做可解释的PC/sibling案例，同时检查LLaMA GEMM/conv相关图是否因access、source-domain或shape restrictions完全没产生动作。用户要求PC融合真实抹掉合法ld/store，sibling也检查共享读/私有中间的类似机会；同alias/address/iteration/carry/effect证明不得弱化。用同资源完整程序实测，记录操作数、body字节、shape、II、source firings、通信及最终cycles，解释内存减少为何可能被更高II/资源占用抵消。

对fission至少给出一个原源→分割children→完整coverage/no-duplication→actual children body/cost→exact replay→native numeric/trace的完整正例及forged metadata/alias/effect/stale-domain负例。检查所有六程序的合法inventory是否正确接入搜索；不要添加独立预fission阶段替代S5维度。若需扩展Task13多输出carry支持，单独证明两个输出及状态顺序，不从28task supplement的结果回填原图。

修复后先跑有针对性的native正/负例；需要构建时新pin并j1。确认解决了具体blocker后，再用新contract/output root跑受影响程序的独立S3/S4/S5；最终需要完整六程序独立五阶段对照。不能通过手工换winner或给新增维度额外隐藏预算制造结果。性能没有提升也必须给出可核对原因。顺带完成共同DFG AMOEBA Ray时保持原27tasks/F45分配、II23诊断和共用后端，不重跑已完成五个baseline。

## 源码与脚本入口

- `lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp`：S5 stage guard、prepared source、typed `fissionActions`、重建与shape同步、fresh costs、预算/beam/排名。
- `JointNeighborhoodActions.{h,cpp}`：action family、枚举及stage gate。
- `MaterializeNeuraJointRewritePass.cpp`：PC forwarded/retained、indexed访问证明、sibling共享读、实际ld/store消除。
- `lib/Backend/Neura/Transforms/Optimizations/FissionTaskPass.cpp` 与 `include/Backend/Neura/Transforms/Optimizations/TaskflowFission.h`：源DFG cut、effects/alias/domain/carry合法性与children。
- `TaskflowFissionSourceReplay.{h,cpp}`：固定source lowering、精确canonical witness、census fail-closed及typed source replay。
- `ReplayJointNeighborhoodActionsPass.cpp`、`InheritReplicaAnalyticalTaskCostCatalogPass.cpp`：typed history重放与重写后body/cost继承验证。
- `PredictAnalyticalTaskCostCatalogPass.cpp`、`AnalyticalMLPInference.{h,cpp}`、`MapJointSchedulingTasksPass.cpp`：generic mapper feature、20/23cache、native映射和公共DFG。
- Artifact `scripts/{run_neighborhood_stage_chain.py,replay_cpp_global_top5.py,neighborhood_replay.py,run_input0_memory_fusion_fission_queue.py,cleanup_neighborhood_temporaries.py}`。
- Source fixtures/checkers在 `test/multi-cgra/taskflow/joint-scheduling/`，特别是 `producer-consumer-composite-source-domain`、`sibling-fusion-source-domain`、`neura-joint-rewrite-sibling-*-load-dedup`、`fission-task-source*`。

## 本机完整binding位置

冻结runtime：`/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/runtime-frozen-r6`。

在artifact下：

```text
.work/control-variables-and-tiling-20261006/
  mlir-amoeba-opt-memory-fusion-fission-r9-original-ray-ii23-stable-features-20261006
  source-model-contract-memory-fusion-fission-r9-original-ray-ii23-stable-features-queue-v2-20261006.json
  memory-fusion-fission-r9-queue-v2-native-acceptance-20261006.json
.work/input0-neighborhood-2x2-v60-memory-fusion-fission-r5-20261006/
  input0-chain-original-ray-ii23-r9-queue-v2.json
  protocol-bound-original-ray-ii23-r9-queue-v2.json
  protocol-bound-original-ray-ii23-r9-queue-v2-ray.json
.work/post-publication/
  full-input0-memory-fusion-fission-r9-original-ray-ii23-queue-v2-runtime-20261006.json
```

Native proofs：`/tmp/orbit-r9-source-proof-acceptance-20261006/summary.json`、`/tmp/orbit-r9-native-cache-acceptance-20261006/summary.json`、`/tmp/orbit-r9-native-search-acceptance-20261006/{summary.json,exact-replay-record.json}`。R6/R7/R8旧pin与bad-cache R7搜索已无损压缩归档，不需要解压回旧版本继续。

R9 runtime的19个artifact payload仍有精确字节binding。为继续读取旧结果，保留frozen目录和旧pin/contract；修改公开脚本后要用新binding，不能把旧结果说成新脚本的fresh measurement。旧 `.work/post-publication/FRESH_AGENT_HANDOFF_20261006_R9_QUEUE_V2.md` 的“队列仍在运行”等状态已过时，以本prompt及当前Git/实际结果为准。

最终交付：可核对的fusion/fission漏斗与根因、必要的源码修复和正/负例、同变量新的实测结果/图/复现说明，正常提交并push两个目标仓库。每个结论区分已证明、待验证及无收益原因，不把历史预切Ray、不同DFG或不同预算混入主曲线。
