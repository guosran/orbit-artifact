# S3 tiling 收益偏小：受控实验与根因

截至 2026-10-06，input0，4×4 CGRA fabric，每 CGRA 2×2 PE，context6/register32/II20；统一 latency1/bandwidth32 网络。

**LLaMA 的联合分块实测已达 50.90% 收益。原表没有覆盖此方案，还把合法的 Task6 分块挡在证明环节。**

当前 S3 的主要能力是输出域拆分：克隆完整 kernel，缩小 M/N counter 的区间，保留其余 counter 与 kernel body。它没有通用的输入 tile/subview、局部缓存与数据复用、卷积 halo 或已接通搜索路径的并行 K reduction。因而不能把它等同于通常预期会显著减少数据搬运的 GEMM/conv blocking；它与 S2 replica 的输出分片能力高度重叠。

## 实测结果

|实验|对照 cycles|处理 cycles|下降|说明|
|---|---:|---:|---:|---|
|LLaMA，三个 QKV 都 M-axis tile8|595,551,249|430,140,475|27.77%|保留 S2 shape/replica 选择|
|LLaMA，三个 QKV 都 replica8|595,551,249|430,140,475|27.77%|与 QKV tile8 完全相同|
|LLaMA，只将 Task6 M-axis tile8|595,551,249|435,653,658|26.85%|已修复原地区域证明|
|LLaMA，QKV 与 Task6 都 M-axis tile8|595,551,249|292,394,049|50.90%|保留其他 S2 资源选择|
|Harris，Task2/3/4 三个卷积都 M-axis tile8|899,620|823,640|8.45%|保留 S2 其他选择|
|Harris，现有搜索 S2 → S3|899,620|621,600|30.90%|S3 在此程序已有较大收益|

上述显式处理均通过实际 mapper、独立 trace 与 numeric；LLaMA 比较 131,072 元素且 0 mismatch。它们是显式诊断处理，尚未成为自动搜索 winner，不替换正式阶段表。SRAM admission 仍 pending，formal_go=false。

## 为什么搜索没找回 QKV 收益

两阶段都是从同一 canonical 程序独立开始，预算都是 4 rounds / 4,096 scored / beam16 / top5 native。

LLaMA S3 archive 有 2,398 个带 tiling 的有效候选，但没有两个以上 QKV 同时 tiling 的候选，也没有 QKV tiling 与 Task7 1×3 的组合。S2 archive 则覆盖三个 QKV 各自的 replica2/4/8，却没有两个以上 QKV 同时复制的组合。实际 Q、K、V 的共同完成时间为 188,743,680 cycles；只拆其中一个，会被其余未拆任务的完成时间卡住。单任务动作难以跨过这类收益屏障，有限 beam 在组合出现前就将路径剪掉。

强制组合的正确 transformed output 经 C++ source ledger / child 数量 / mapper output identity 验证后，tile8 与 replica8 都达到 430,140,475 cycles。这证明是 S2 和 S3 共同的搜索覆盖缺口，而非 S3 独占的理论优化收益。初次误用 replay 主输出的旧探针已明确标为 treatment_valid=false；这些结论只使用 typed-replay/candidate.mlir 的有效结果。

## 为什么卷积局部分块只有 8.45%

三个卷积的所有 child duration 加总由 116,305 变成 116,354 cycles，增加 49 cycles startup；总计算工作基本不变。收益来自并行与数据流重叠。Task5 提前 75,979 cycles 开始，Task9 提前 75,980 cycles，之后未拆分的关键后缀仍保留其原始时长和传输。

同时，Task1 的两个 replica 原先各向 Task2 传一次 1,048,576-bit 输入，合计 2,097,152 bits。Task2 tile8 后，每个来源向八个 child 都传完整输入，trace payload 合计 16,777,216 bits，恰为八倍。这是共同网络模型的传输量，不是独立测得的 DRAM traffic。缺少每块输入读区域与 halo/reuse 描述，削弱了输出拆分的增益。

完整关键路径与 route 数值见 [attribution.json](../control-variables-root-cause-20261006/attribution.json)。

## 分块合法性实现问题

Task6 是原地读写的 GEMM。旧证明无法解析真实 storage base 的 constant → data_mov → grant_predicate → data_mov 链，以及两臂都对应同一 counter 的 Phi；修复后可严格证明其输出位置。第二处遗漏是通过证明的 rank2 child 没有输出区域 attrs；补全后 predictor 与 source-domain ledger 可接受。

第三处已修复并完成 native 验证：已证明的原地读写此前只发布输出区域，未发布同一 storage root 的输入读区域，因此图分析仍给 sibling 加 ordering-only RAW 边；通信模型对无 payload 的 RAW 边 fail-closed 拒绝。修复仅在所有输出读写都已证明相同 counter 坐标后，为同一 original storage root 的 read slot 发布同一矩形；其他输入保留 unknown。新图没有 Task6 sibling 间 RAW 依赖；未知 payload 拒绝仍保留。六项正/负证明检查、串行构建、实际 mapper、独立 trace 与 input0 numeric 均通过。

Task6 八个 child 的计算时长合计 183,500,816 cycles，对照 parent 为 183,500,802，仅多 14 cycles startup；实际工作没有少算。只拆 Task6 时它最晚完成从 403,792,908 提前到 243,754,003；再与 QKV8 联合时提前到 100,756,539。整程序最终为 **292,394,049 cycles，比对照少 303,157,200（50.9036%）**。证据见 [task6-timing.json](task6-timing.json)。

同样的 QKV+Task6 全 replica8 处理也进行了源码检验：QKV 可通过，但当前 S2 的原地 replica 路径因 Task6 存在 carried kernel state 而拒绝，未进入 mapper，因此没有可比较的 native cycles。该保守 carry gate 保留不变。QKV 的 27.77% 已证实两阶段都有；Task6 处理的差异属于目前 materializer/proof 支持域差异，不能推导成 tiling 相对于 replica 的固有优势。

多输出 Task7 与 parallel K 的支持仍需单独实现；不能直接放宽 gate 或忽略未知依赖来获得更好的 cycle。

## AMOEBA 比较的变量控制

Harris Task1 的 II10 对 II7 跟随输入 DFG，而非 compiler 二进制：AMOEBA profiler 的 void wrapper 合成 true 返回并重跑完整 lowering，添加 grant/phi/return 等十个 PE ops（37 对 27）；ORBIT 复用已 lowered kernel 的 void wrapper。相同 DFG 交叉映射时，两编译器得到相同 II。

现在由同一个 mapper pin 在同一 canonical DFG 上生成共同 parent profiles，Radar 完成 168/168、Harris 完成 192/192。Radar 的两决策臂使用相同 DFG、实际 II/duration 向量、硬件、trip/startup、后端 scheduler 和网络，且均选 21 个 1×1 单 replica；结果均为 **1,317,811 cycles，差 0**，numeric 259,904 比较/0 mismatch。旧差 3,486 cycles 来自 profile/frontend 成本差异，不能作为 AMOEBA 调度较差的证据。

Harris 的共同 parent profile 与 F45 资源选择已完成；完整多 replica 的共同输入 native 配对尚未在本研究中宣称完成。

## 后续修复方向

1. 用 deterministic 的短程共同消费者拓扑识别 2–4 个独立 producer，提供原子的 grouped replica/tiling action；复用已有严格 materializer，而非扩大 beam 后仍依赖偶然组合。
2. 已完成 Task6 原地读写区域证明与 paired native 验证；在搜索中重新覆盖此合法方案，并单独统一 replica/tiling 的 carry 支持域。
3. 若 S3 定义包括传统 blocking，需要实际实现输入区域、局部数据复用与卷积 halo，并接通合法的 K reduction。此类变化应重新做独立阶段对照，不能由 output sharding 结果代替。

机器记录：[controlled-study.json](controlled-study.json)、[search-coverage.json](search-coverage.json)、[qkv-timing.json](qkv-timing.json)。
