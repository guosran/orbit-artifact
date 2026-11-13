# ORBIT 抽象与搜索的 PR 计划

PR 主线是 **ORBIT 的抽象和搜索**。实验、执行／测量脚本、标定、硬件结果和历史
归档进入 `guosran/orbit-artifact`，直接 commit/push，不为它们创建 PR，也不把
artifact 的行数计入编译器 PR 预算。

## 提交原则

- **每个 PR 都交付所属功能的最终改后状态**：实现、P1 修复、必要注释、构建接入
  和最小正／负例一起进入。不单独发 P1 修复 PR，不先交有缺陷的版本再补修复。
- PR 按功能和接口依赖组织；一个 PR 可以包含多个开发提交。此前 22 个本地提交
  是审查／清理过程记录，不是 22 个待发 PR，不要求上游重放这些中间状态。
- 每个实际 PR 按相对其目标基线的 **新增行＋删除行** 计数，硬上限 2,000，
  尽量不超过 1,000。代码、测试、注释、移动及构建修改均计入。
- 大模块先按职责提取。每个交付单元都可构建、可调用、可检查；不靠空实现、
  禁用检查或不完整的半个 pass 达到行数限制。
- 若某个 P2 会破坏该 PR 对外承诺的语义，应在这个功能 PR 内解决；其他 P2
  保留在[审查记录](orbit-amoeba-review-2026-11.md)，不冒充已经修复。

## 功能系列与依赖

下列是六个功能系列，**不是承诺只有六个 PR**。先确定每个可独立使用的接口／
行为单元，再从修复后的源码提取实际分支、构建并检查 diff；超过预算则继续按
职责拆分。最终 PR 数由这些可验证的边界决定，不再按全仓行数预报总数。

| 顺序 | 最终交付内容 | 主要现有实现 | 相关修复随功能进入 |
|---|---|---|---|
| 1. 源程序与图抽象 | 值／算子／任务、源依赖、访问区域和版本、完整源覆盖及独立验证。第一批先交付最小可构建表示与验证器。 | `include/Taskflow/`、`ProgramGraph.cpp`、`ProgramOperatorSource.cpp`、Taskflow dialect | 区域依赖前沿 P1-21；已有 source/body 检查一同保留。 |
| 2. 异构执行抽象 | CPU/NPU 执行区、实现／分组、资源和容量、传输、launch／同步边、数据 residence 与完整程序计时；明确 inclusive wall time，避免重复计费。 | `ProgramOperatorMapping.cpp`、`ProgramDataOrganization.cpp`、`ProgramTiming.cpp`、`GenericMapping.cpp` | 分组／资源／计时约束与对应检查器同时进入。运行时所有权 P1-01 在 artifact 的最终执行器中交付。 |
| 3. 决策空间与合法动作 | fusion/fission、tiling、replica size、placement、spatial/temporal dataflow、data residence 的显式决策；每个动作绑定源域、别名、carry、输出所有权和封闭副作用证明。 | `GenericReuse.cpp`、`NativeTransforms.cpp`、Neura materializers 与共享证明 helper | P1-03–10、12–15、18–19、22、24 合入各自动作的最终实现及负例。 |
| 4. 评估与独立检查 | 调度／容量／执行图验证、已知与未知成本、网络／模型／实现身份、实际结果认证。 | `StaticChecker.cpp`、`ProgramResourceSchedule.cpp`、exact scorer、global ranker | 缓存与排名认证 P1-11/20、aggregate 调度终止 P1-23 随对应评估器交付。 |
| 5. 搜索 | 基于上述决策的 beam／neighborhood、候选 replay、预算／取消、动作历史、checkpoint、缓存和结果报告。先交付可在小图上完成“构造→搜索→独立检查→replay”的最小闭环，再扩展动作。 | `Search.cpp`、`ProgramBeamSearch.cpp`、`ProgramAllSearch.cpp`、`JointNeighborhoodSearchPass.cpp` | 当前 v9 合法性绑定和有效缓存域从第一版带入；预算／恢复的相关 P2 按该 PR 的承诺处理。 |
| 6. 后端接入 | 将选中决策落到已有 Neura/AIR/NPU 后端；证明执行覆盖与数值／控制流一致。按搜索闭环需要接入，避免把整个后端历史一起迁入。 | `lib/TaskflowAIR/`、Neura adapter／lowering | AIE 数值／控制流 P1-16/17 随检查器交付；Qwen 源绑定 P1-02 在 artifact 注册器中交付。 |

依赖为 1→2，1＋2→3，1＋2→4，3＋4→5；6 与相应的抽象／动作配套接入。
Core 抽象和搜索应能在没有 artifact、模型权重、设备及可选后端时运行 CPU 回归。
可选 CP-SAT／SCIP 只是同一抽象的求解适配，不作为搜索主线的强制依赖。

## 哪些内容直接进入 artifact

| 内容 | 交付方式 |
|---|---|
| Qwen／PolyBench 等 workload 注册、执行、标定、测量、绘图、数值参考和实验报告 | 在 `orbit-artifact` 的相应 namespace 直接提交、push；不创建 PR。 |
| 本轮运行时最终实现及 CPU 契约测试 | 与对应执行／注册入口一起直接 push，不单独发布“先旧后修”的版本。 |
| 审查底稿、复现输入、覆盖清单和便携验证证据 | 直接 push 到 artifact；完整大规模原始运行和冻结构建继续放在 Git 忽略的本地存储。 |
| 过时原型与重复开发日志 | 保留原 Git／快照恢复路径，在维护分支完成清理；不作为 Amoeba 功能 PR。 |

公共搜索算法、决策模型和独立检查器留在编译器仓库。实验 driver 通过公开接口
调用搜索，不在 artifact 中维护另一份规划器或搜索实现。

## 原始盘点的用途

[逐路径清单](orbit-amoeba-migration-manifest.jsonl)固定在审查后的功能源码
`2043e8ea32d4fc8a2b53560013ebe65000a194fd`，用于追踪来源、处置和模块归属。
其中 `historical_size_bucket` 仅保留原来的行数分桶记录，**不是 PR 编号**；原先的
329 个装箱估算不再作为交付计划。继承 Neura 文件不重复提交，ORBIT 发布时
省略的 Amoeba 原工具／CI／测试也不向上游发删除 PR。

对比采用已声明的 Amoeba tree baseline；两个发布历史没有 merge base。
在实际准备某个 PR 时，应再次对照目标上游状态和前置 PR 后的基线，不能直接
把 ORBIT 的出版目录差异或本轮修复 diff 当成上游功能 PR。

## 验收与大小检查

每个功能 PR 从最终源码中提取后，分别完成相关构建、正／负例、独立 checker 和
必要 replay。格式采用 LLVM，注释说明语义不变量和失败条件。大小检查入口：

```sh
python3 scripts/check-pr-size.py --base BASE_COMMIT --head PR_HEAD
```

本轮最终实现已有的验证证据：隔离构建启用 Neura、AIR、OR-Tools、SCIP，51 个
工具／测试程序构建成功；62 组 CPU 回归、41 个 lit 测试通过；298 个本地增量
C++／头文件通过 `clang-format 23.1.5 --dry-run --Werror`。运行时专项 39 项、
保留实验单测 56 项通过，与集成测试有重叠，不累加。缺少 SciPy 的三项标定检查
不计作通过；本轮没有新的 NPU 性能结论。

这些证据属于已审查的整体实现。未来提取后的每个功能 PR 仍须验证自己的实际
代码状态，不能用整体实现的通过记录替代。原始证据和范围边界见[审查记录](orbit-amoeba-review-2026-11.md)。
