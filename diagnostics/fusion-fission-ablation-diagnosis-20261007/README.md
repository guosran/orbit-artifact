# R9 fusion/fission 无最终收益的独立诊断

**完成，原消融主表及 checkpoint 保留。不能统一归因于程序本身。** 部分 fusion 在评分前被实现校验阻断；LU 的可评分 fusion/fission 预测较差且未入最终 shortlist；已测 fission 在固定资源及64点资源调优后仍无增量收益。本轮没有找到在可比资源对照下更快的 R9 变换见证；所有合法变换是否无收益仍未知。后续 R11b 正例另列，不能回填 R9。

## 实际消融

最后完整结果为 R9 queue-v2，六程序×五阶段，2026-10-06T23:20:47Z完成。使用 frozen-r6目录中**实际R9 binary**，不是旧R6算法或当前main。contract source namespace为`6a1b6fcf6e155651e96b3b881565ad58fdf0c03e`，发布基底`a75c848eccc010a5c6923cc16fc0e3d6073da73a`，当时源码dirty；140个嵌入源码逐字匹配。当前main `4547a385…` 是后续版本。[完整hash、当时源码diff、27 bindings、模型和120条阶段命令](provenance/README.md)。文件hash为BLAKE2b-256，Git身份保留原SHA1。

| public stage | 内部stage | 开放维度 | fusion / fission |
|---|---:|---|---|
| S1 shape-temporal | 2 | shape、temporal | 否 / 否 |
| S2 shape-temporal-replica | 3 | 上述+replica | 否 / 否 |
| S3 shape-temporal-replica-tiling | 4 | 上述+tiling、配对co-tiling | 否 / 否 |
| S4 full-joint | 5 | 上述+PC/sibling fusion、既有组合规则 | 是 / 否 |
| S5 full-joint-fission | 6 | 上述+source-owned fission | 是 / 是 |

**已证实：** 每阶段独立从同一原canonical开始，identity typed history无fusion/fission，不继承上一stage winner、archive、shortlist或warm-start。Ray初始Task13=1×4是支持性资源选择，仍为原27tasks；不能替换为历史预切28-task图。各组都搜索开放的资源维度，并统一native top5、numeric、trace复评。[语义逐项核对](semantics/report.md)，[JSON](semantics/summary.json)。

共用4rounds/4096unique program scores/beam16/diversity4/top5，scoring-workers=4，partition factor≤8，fission cuts/task≤64。机器4×4CGRA，每个2×2PE；R9单task形状≤4CGRA，共八种既有shape。标准runtime II20，原版Ray II23，训练/模型仍20；SRAM容量admission仍pending。

无固定family quota；按已评分/预留次数自适应交织，轮次评分额度是全局额度；diversity4不是每family保留席位。10/12个S4/S5跑满4096；LU S4/S5分别3553/3554、因max-rounds停止。**证据支持但未确认：** 新动作可能挤占其它探索机会，不能把同4096当成各维度等探索预算。本轮没有quota/beam sweep。

S3=S4=S5 native cycles仍为LLaMA424250388、LU9486、Harris621600、Radar1309622、GCN86987、Ray176711。正式消融支持“当前搜索配置开放变换没有改善最终结果”；本诊断只补充有限实例的调优负结果，不能升级为“所有合法变换无收益”。

## 分开的候选流向

[原批次12stage漏斗](funnel/original-r9.json) 用null明确表示未知：cleanup删除了原archive/journal，不能把成本日志缺席说成beam淘汰，也不能把未入native shortlist当成native负结果。

**已证实：** 12个最终beam均0/16 fusion/fission，60个native top5、12个winner均无这两种变换。Harris的producer-consumer-co-tiling是两个tile primitive，不是fusion。S4 fission因gate为0；S5合法cut census为LU1、Harris30、Ray56，LLaMA/Radar/GCN0，census不是尝试数。所有12个checkpoint的`pending[cursor:]`中fusion/fission未处理descriptor均为0；完整pending菜单含已处理descriptor，不能误算尾部。这个尾部也不覆盖尚未生成的后续轮次。

只补一次 **LU S5原flags日志恢复运行**，另存输出/cache/checkpoint，unused pause guard3555未触发，无源码/随机数/排序修改。3554scores、4rounds，与原终止beam和top5逐项复现ID、完整key、typed history、顺序和预测cycles。[审计和全部成功key](funnel/lu-r9-replay-report.md)。

| LU补跑环节 | fusion（含既有组合） | fission |
|---|---:|---:|
| 原始枚举/尝试总数 | 未知；dedup后5408条archive，journal5411事件 | 1条archive；枚举次数未知 |
| source materializer拒绝 | 5366 | 0 |
| rewrite后source-domain不可证明 | 27 | 0 |
| 合法、materialize并成功评分 | 15 | 1 |
| 不同结构图 | 1：Task0+1 sibling | 1：Task0 cut `[0]` |
| 实际kernel/DFG改变数 | 代表性同结构已核验；15条历史逐body未留 | 代表性已核验；历史body未留 |
| 中间轮次beam保留 | 未知 | 未知 |
| 最终beam / native shortlist / native成功 | 0 / 0 / 0 | 0 / 0 / 0 |
| 相对直接父图整程序预测改善 | 0/15；反而+79…313 | 0/1；+415 |
| 原搜索kernel/native程序改善数 | 未知 / 未知 | 未知 / 未知 |
| 最终winner含变换 | 否 | 否 |

最佳fusion预测14229，原top5为9477…10110；fusion全局rank2415…3539，fission rank3540/3554。它们未被预测选入native，尚不能断定其所有资源配置native都差。5366个source-owned-materializer-rejected只有第一失败阶段，不能全算作下述metadata bug。

## 五个冻结结构的后端证据

选择规则：Radar队列中的sibling4+5和retained PC16→17；LU唯一fission cut；Harris census第一cut；LU补跑唯一可评分fusion结构。不是按预测收益挑选。初始建议Radar PC3→4在exact replay中因RAW规则拒绝，没有冒充合法候选。[初始inventory](inventory/report.md)。

[原/变换IR及raw kernel hash、task数和域](forced/materializations.json)，[代表性IR正文](forced/representative-kernels.mlir.txt)，[六个fixed fission receipts](backend-witnesses/report.md)，[六个额外native receipts](forced/native-summary.json)。22个kernel用**实际mapper cache func wrapper和shape**核验；双射SSA重命名保留连接关系，源与wrapper逐字相等。[严格复核](backend-witnesses/strict-mapper-body-check.json)。

| 结构 | task数 | 每个原工作量firing的访存 | 域/新增通信 |
|---|---|---|---|
| Radar sibling4+5 | 21→20 | loads8→4，stores2→2 | 131072firings；共享读真实消除、两个输出保留 |
| Radar retained PC16→17 | 21→20 | loads6→5，stores2→2 | 840firings；公共producer写出必须保留，Task18仍独立 |
| LU Task0 fission | 9→10 | loads1→2，stores1→2 | 64firings；8×8 i32临时数据、2048bit RAW |
| Harris Task0 fission | 24→25 | loads3→4，stores1→2 | 8064=63×128firings；新增258048bit RAW |
| LU sibling0+1 | 9→8 | loads1→1，stores4→4 | 64firings；无共享读，Task0输出等待整个fused kernel |

fission两child各保留原完整迭代域，不能把trip count相加当原工作量。新增跨cut物化/通信，原计算逐操作覆盖，Harris算术保留在右child。所测Task0 cut无reduction，不把正确性外推至未支持carry/reduction。接口、lineage、source-work和数值证据保留。Radar正共享读fusion仅证明typed materialization/source-domain；其numeric/native仍未知。

**已证实的实现问题：** R9 materializer输出sibling `eliminated_loads=4`或retained `eliminated_loads=1, stores=0`，extractor分别要求load=0或0/0，导致二者在**评分前metadata校验**拒绝。属性齐全且类型正确，不是beam或mapper性能失败。[源码/拒绝详情](fusion-metadata/report.md)，[强制required-target错误](forced/fusion-errors.json)。零共享读LU fusion通过，因此不是所有fusion都被阻断。

**证据支持但未确认全面排除：** graph/catalogue/task覆盖、body/shape成本key、完整IR scorekey、mapper wrapper+架构+shape完整cachekey及22个实际body检查未发现旧body成本复用。所测DFG确实变化，不是仅Taskflow分组；不构成全实现无缓存bug的证明。Radar候选没有R9成本，不能诊断其预测排序或mapper缓存性能。

## 四项对照与native

表内为 **预测整程序 / native整程序 cycles**。固定策略：fission parent Task0=2×1，两child各1×1；fusion两个parent各1×1，fused=1×2；其它task1×1。保持同一机器/并发约束和局部总8PE，是总资源转移策略，不能说逐task配置完全相同。

| 图 | 固定可比资源 | 每侧64点调优：预测best / 该配置native |
|---|---:|---:|
| LU fission原图 | 18365 / 18438 | 15765 / 15435 |
| LU fission变换图 | 18646 / 18694 | 16009 / 15628 |
| Harris fission原图 | 1045501 / 988258 | 1017733 / 988258（identity） |
| Harris fission变换图 | 1081713 / 1012450 | 1058281 / 988261 |
| Radar sibling/PC原图 | 1336015 / 1317811（复用同R9 identity） | 未运行；另一侧评分前阻断 |
| Radar sibling/PC变换图 | N/A：R9 metadata拒绝 | N/A：同一gate，修复后收益未知 |
| LU零共享读fusion原图（补充） | 18231 / 18501 | 未知；没有额外panel |
| LU零共享读fusion变换图（补充） | 18442 / 18629 | 未知；没有额外panel |

[完整LU64点前缀](resources/lu-64.json)、[Harris](resources/harris-64.json)：保存可重建key、typed action、shape、fresh成本、调度和命令，不保留所有完整快照。双方同确定性round-robin算法，全task最小支持1×1起步，所有task均可调，遍历既有八种shape，目标配置预算均64，不以赢家资源初始化；无PRNG seed。每oracle强制identity+target共2scores，不展开ordinary邻居；原图第0点identity与第1点共享oracle，共126scores，变换侧128scores，各案例254。源事实、graph/body成本、调度重新生成；同一有效预测cache可复用，不复用失效分析。模型ensemble种子17/41/113/239。task数不同导致有限前缀覆盖不同，不能宣称全空间等覆盖或全局最优。

**已证实的排序偏差：** Harris原图第50点Task1=1×3预测1027665，排在identity1017733后，但native964067优于identity988258。变换图对应资源第53点native988261，仍比同Task1=1×3原图慢24194。表中native不是全64点native最优；仅复评代表性配置。已测native资源点中Harris原图最好964067、变换图最好988261。这证明原图shape排序偏差，**没有证明漏排有益fusion/fission**。

LU调优fission15628低于固定原图18438，但同Task6=2×2原图15435更快；不能归因给fission。这是已有fission+shape组合，无新增动作；Harris同样包含fission+shape。

fixed LU parent2×1 nativeII1、0→66；split两child II2，0→129和193→322，中间64cycles为实测临时数据传输。Harris parent II3、0→24195；左child II2、0→16129，右child II3、24193→48388，中间8064cycles传输。不能用左child低II宣称完整split更快。[LU实际起止/成本/route](backend-witnesses/receipts/lu-rank-2.json)，[Harris](backend-witnesses/receipts/harris-rank-2.json)。

LU原Task0/1并行，II2/4、时长129/257；fused1×2 II4、时长257，Task0输出从129推迟至257，Task6启动7460→7588，程序18501→18629。[fusion完整trace/实际DFG](forced/native/lu-fixed-fusion-rank-1.json)，[原图](forced/native/lu-fixed-fusion-rank-5.json)。调优后Task6两边都II11→5、时长5632→2566，拆分仍使其晚193cycles，程序15435→15628。Harris matched Task1 II4/时长32261不变，但fission新增前序计算/传输，Task1启动56963→81156，程序964067→988261。各receipt保存全task起止、预测startup和通信；native没有独立startup/resource-wait字段，资源等待因果拆分未知，不能把所有gap叫资源竞争。

## 原因判断

| 类别 | 状态与结论 | 证据 |
|---|---|---|
| A 候选覆盖 | **已证实**：三个应用fission census=0，LU唯一cut在copy Task0。fusion合法总量未知 | semantics/summary.json |
| B 实现 | **已证实**：DFG真实改变；Radar正共享读fusion被不匹配metadata拦在评分前 | fusion-metadata/report.md |
| C 评分 | **已证实**：Harris原图shape排序偏差；**未知**是否漏排有益fusion/fission | forced/native/harris-resource-original-50.json |
| D 搜索 | **已证实**：LU所评分变换均不如直接父图、未入native，fission只能ordinary动作前的prefix。**证据支持但未确认**该限制/4096拥挤丢失好解 | funnel/lu-r9-replay-summary.json |
| E 资源耦合 | **未知/未找到正例**：64点所测没有相对同资源调优原图的增量收益；LU绝对baseline下降来自其它task shape | resources/、forced/native-summary.json |
| F 局部→全局 | **已证实**：Harris子kernel II下降不等于完整split快；LU fusion推迟输出及后续依赖 | backend-witnesses/、forced/native/ |
| G 负结果 | **已证实**：已测两个fission结构fixed及有限64点调优/代表性native仍无增量收益。**未知**其它cut、更长前缀和全64点native | 本表与ledger.json |

保守新增 **4088/4096目标评估**：4076个搜索/评分（含4个坏cache校准identity、3554个唯一LU日志补跑scores），另12个native整程序调度。mapper请求186，cache miss76、hit110，独立入账。只剩8个评估，不能完整等预算延长至256；没有256重启、quota/beam sweep或4096外隐藏评分。[总账](ledger.json)。错误空JSON cache、缺输出目录属于新诊断launcher校准失败，不能当R9模型bug；本轮launcher仅修正输出目录创建和计账。[launcher hash及diff](analysis-launchers.json)。

**是否已有正确且更快的方案：** R9可比原图/资源对照尚未找到变换增量加速，是否存在仍未知。后续不同源码 **R11b** 已有四个PC fusion固定对照正例：Harris955485/939361对988258，Radar1310353/1312031对1317811，numeric/equality/trace通过。[后续独立结果](../fusion-fission-controlled-r11b-20261007/README.md)。它们没有证明胜过正式Harris621600/Radar1309622。R9 metadata gate解释同类候选不能进入其评分通路；“R9放行就得到R11b收益”未确认，因为后续materializer也改变了DataMov forwarding。

后续版本已经分别修正metadata范围和DataMov检查，这是实现修复。本轮没有重建binary、扩展动作、放宽证明或重构搜索。多输出合法候选、fission顺序覆盖和预测/native评价机制可能需要另立任务；资源相关性本身不构成创新。

Task7单列 **已证实的规则限制**：双输出让tiling/fission/fusion评分前拒绝，复用[现有审计](../sequential-comparison-fixed-fission-4096-llama/multi-output-case/case.md)。没有正确且整程序更快的Task7改写，不能判定IR表示缺陷或性能根因。既有增资源II/时长相同的实测来自另一版本，未回填R9；本轮没有重跑Task7/Joint/Sequential。

## 一次查询和复核

```sh
python3 /home/x/shiran/project/orbit-artifact/scripts/show_fusion_fission_ablation_diagnosis.py
```

只读本诊断，不启动搜索或轮询。[summary.json](summary.json)索引四项表/状态；完整argv在[新命令](forced/commands.json)、两resource前缀、native receipts及provenance/commands.json。[资源launcher](../../scripts/run_fusion_fission_ablation_diagnosis.py)、[native代表性复评](../../scripts/replay_fusion_fission_diagnosis_resources.py)。复跑是新的预算，不可用已有4088账目重启。合同/binary的本机/tmp路径不是clean-clone分发包。

原R9、负结果、其他agent数据均保留。仅清理本诊断可重建校准IR/零评分dry-run，LU原始日志逐字校验无损gzip；[清理记录](cleanup-receipt.json)。后台R11b仅暂借8–11核，已按命令逐字验证PID后恢复；未操作其他Joint/Sequential进程。[分配/恢复记录](resource-allocation.json)。
