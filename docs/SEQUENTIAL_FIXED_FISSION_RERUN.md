# 修复主干后包含 fission 的匹配重跑

本批次保留原有 Joint/Sequential 比较范围和预先指定的 50/50 主分配。
25/75、75/25 是独立敏感性配置；GCN/LU 的剩余预算转交仍是单独补充变体。
旧 fast2 的数值不能与新批次混合，因为主干的原地分块证明、融合、mapper profile
和预测特征实现已改变。新批次重新运行 Joint，重新生成所有成本目录和预测缓存。

源基线是 `a75c848eccc010a5c6923cc16fc0e3d6073da73a` 加捕获时的主干未提交修复。
实际编译源码由新的 140 文件 exact-source contract 记录。模型成本命名空间仍使用
`6a1b6fcf6e155651e96b3b881565ad58fdf0c03e`；该字段不是实际编译源码的 Git HEAD。
编译只在独立工作树移植控制器及统计，借用已验收修复主干的未修改静态库。

图动作是 registry 原有 tiling、fusion、fission，以及既有图组合/替换动作。
资源动作是 shape、replica 和这些资源选择的替换/撤回。阶段 A 从组合动作投影掉
shape/replica；阶段 B 只允许资源后缀。没有新增变换，也没有直接搜索开始时刻；
时序由生产调度器的 critical-path dispatch 和相同显式 mesh 通信模型确定。

fission 使用现有 source-owned 前驱闭合非空 operation cut：每个原任务最多 64 个
完整合法切分，超过 cap 失败，不发布部分枚举。切分先在匹配的 pre-Neura Taskflow
源码执行，重放后再降到 Neura。源 fission 必须在普通 Neura 动作之前；保留主干
当前的这些限制。Harris 有 30 个合法 cut，LU 有 1 个，其余三个程序没有合法 cut。
原始 Ray 在 II20 支持域内仍被排除，不能使用另一个 fission 程序或 II23 结果填表。

阶段 A 复用已合法的 shape，replica 固定为 1。新节点先使用继承配置/节点属性/1×1，
如果不可行，依次查询既有八种 shape，使用第一个受模型支持的合法配置，不按 costs
排名。Joint 的结构候选也使用相同可行初始化，避免丢弃以后本可继续搜索资源的图。
显式资源动作不通过此规则改写为其他配置。阶段 B 冻结 anchor 的普通 typed-action
prefix、独立 `fissionActions`、初始 shape 与 canonical fact identity；replica 可展开
物理节点，但不能修改已冻结的图决策。A anchor 留在最终 incumbent/控制方案中。

每个正式流程最多 4096 次完整程序生产调度器目标调用，包括 identity 初始化和
失败调度。canonical duplicate 和 objective cache hit 不消耗目标调用额度，但均记录。
共同 beam=16、diversity=4、每轮 objective quota=512、非约束 safety rounds=8192。
固定比例不转交未用额度；转交补充仅在 A 的 `no-new-legal-candidates` 时转交。
每个流程最终都复评同样的五项 shortlist 和 identity/search_anchor 两项控制方案。
搜索 mapper 调用、验证 mapper 调用、预测查询、共享准备和额外 smoke 成本分别记录。

每个方法从相同的原 v38 canonical 字节和全新共同成本目录/cache seed 开始；转换图、
objective、mapper 缓存均为私有。Sequential A/B 在同一进程共享自己的缓存。
动作前缀重放 memo 曾截断 typed provenance，本批次两种流程均明确关闭该项加速。
结构事实、materializer proof、预测和目标缓存的其他规则保持一致；统计记录实际状态。
两条独立四核 lane 合计八核。后台队列使用 Linux pidfd 等待已有 12 核实验退出，
没有结果轮询；运行中的目录检查只用于搬移不可变成本文件，避免磁盘占满。
完成七项 native/numeric/mapper/trace 检查后无损压缩辅助文件、journal 和 checkpoint，
保留 SHA、最终方案和 trace。此存储开销另列，不是搜索目标调用。

运行入口复用 `scripts/run_sequential_comparison.py`，正式命令由封存后的
`.work/sequential-fixed-fission-v3/queue-manifest.json` 中 `phases[].argv` 记录。
该 manifest 同时绑定源码合同、编译器、输入、模型、验证脚本和原生工具。

```sh
cd /home/x/shiran/project/orbit-artifact
python3 scripts/show_sequential_comparison.py
```

这是一次查询：未完成时显示状态，全部完成时审计并导出主表、预算/时间曲线、
阶段敏感性、转交补充、最终方案索引和事实性论文结论。它不重跑搜索。
主表加速比始终是 `Sequential native cycles / Joint native cycles`。
