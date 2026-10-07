# DFG 與排程差異的受控根因報告

本報告只新增診斷文件；沒有改動編譯器、執行建置、映射或啟動工作。

## Harris Task_1：差異在映射前已經形成

交叉映射實驗使用相同的 2×2 PE、1×1 CGRA、heuristic mapper、架構檔與 `--map-to-accelerator=x-tiles=2 y-tiles=2`。兩個 compiler 都得到同一結果：AMOEBA pre-mapper DFG 的 II 是 10，ORBIT pre-mapper DFG 的 II 是 7。AMOEBA DFG 有 37 個 PE-consuming ops，ORBIT 有 27 個。

AMOEBA 相對 ORBIT 多 8 個 `grant_once`、2 個 `grant_predicate`、1 個 `phi`、1 個 `return_value`，少 2 個 `constant`；`data_mov` 多 12 個，但不計入上述 PE-consuming 數量。這些差異精確合計為多 10 個 PE ops。

F45 的 `TaskProfiler.cpp` 會把抽出的 kernel body 複製到 `func.func @__task_profile__`。原 kernel 沒有回傳值時，wrapper 會額外回傳合成的 `i1 true`，再對 wrapper 重跑完整的 mapper lowering pipeline。`TransformCtrlToDataFlowPass` 的 function 路徑無視原 task counter，呼叫預設 `has_task_counter=false` 的 `GrantPredicateInEntryBlock`，所以每個傳給分支區塊的 predicated live-out 都多一個 `grant_once`。Kernel 路徑則把實際 task-counter 狀態傳入；有 counter 時會抑制這些 grants。合成回傳值又帶來兩個分支 `grant_predicate`、合併 `phi` 與 `return_value`。F45 的 promote-input-arg-to-const/fold 流程讓 constant 少兩個，抵銷一部分增加量。

ORBIT 的 `MapJointSchedulingTasksPass` 直接複製已 lower 的 kernel body，依 `neura.yield` 建立 mapper wrapper；void kernel 仍回傳 void，且只跑 `InsertDataMov` 和 mapper。因此它不會產生 dummy return，也不會重跑 F45 的 return/live-in/control-to-dataflow lowering。交叉實驗把 compiler 互換後 II 不變，確認 Harris Task_1 的 10 對 7 由 pre-mapper DFG 解釋；診斷也指出不能把這個單一 kernel 結果推廣到所有任務。

輸入源頭可追到 `reference/input0-source-domains/manifest.json`：`inputs/harris.mlir`，benchmark `Evaluation/Harris/L3/harris.mlir`，固定 input 0，且 scalar argument 0 綁定 63。當前 F45 全模組輸入和 profile 在 `.work/input0-amoeba-full-2x2-v59-shared-scheduler/parent-inputs/harris/`；ORBIT canonical 全模組在 `results/input0-all-unit-2x2-v59-shared-scheduler-r3/harris/canonical-input.mlir`。交叉映射的完整命令與兩份 pre-mapper DFG 都保存在 `diagnostics/neura-mapper-input-comparison-20261005/`。

## Radar：3486 cycles 來自 task cost，不是 trips 或圖結構

AMOEBA 共享 ORBIT scheduler 的結果是 1,321,297 cycles；ORBIT all-unit 結果是 1,317,811 cycles，差 3,486。兩份 trace 都有 21 tasks、同一組 33 條依賴邊、28 組 routed data pairs、相同的 `Task_0` 至 `Task_20` dispatch 順序、同一份 latency-1/bandwidth-32 明確網路。每個 task 都是 1×1、單一 replica；21 個 trip counts 完全相同。

真正不同的是 mapper body/profile。AMOEBA 的 duration 用 F45 compiled II 加共同 catalog startup；ORBIT 用 ORBIT 實際 compiled II 加 structural startup，兩者皆依 `startup + II × (trip_count − 1)` 計算。II 不同的 tasks 為 0、1、2、6、7、8、12、14、15、16、19。所有 tasks 的 duration delta 加總只有 +239 cycles，因為早期 II 差異互相抵銷；但沿著匯合後的依賴鏈，Task_12 的 +1 II、960 trips 增加 959 cycles，Task_14、15、16 各自以 840 trips 增加 839 cycles。這使 Task_18 與 Task_20 的啟動時間晚 3484 cycles，Task_20 再多 2 cycles startup，最後正好增加 3486。

Task_16 是唯一 placement 不同的 task：AMOEBA 在 (col 1,row 1)，ORBIT 在 (col 1,row 2)。因此 Task_15→16 的路由差少 1 cycle，Task_16→17 多 1 cycle，兩者抵銷；這不改變上述總數。JSON 中列出完整 21-task II/startup/trip/duration-delta 向量和 critical-branch 算式。

## 建議的共同輸入控制

先用 ORBIT source-domain prep pipeline 產生一份完整 Taskflow/Neura canonical module。以一個固定 ORBIT `MapJoint` binary、架構和 mapping cache，為每個 task、每個合法 shape 產生 mapper II、`max time_step + 1`、materialized op count、靜態 trip count，以及共同 startup/duration。這份 table 同時提供兩個決策臂。

F45 的 `task-profile-json` 可以讀入這份共同 profile，而不用啟動 F45 `TaskProfiler`。格式是 `amoeba-task-profile-v1`，須提供相同 function 與每個 task 名稱，且每個 shape profile 要有 `composed_cgra_count`、`composed_cgra_shape`、`compiled_ii`、`steps`、`sample_trip_count`、`materialized_operation_count`、`estimated_latency`、`mapper_succeeded=true`。讀取器只檢查欄位、正值和 task coverage，不會驗證 DFG/mapper/architecture identity，也不會重算 latency 公式。將 `estimated_latency` 設為共同 C++ cost adapter 的整數 duration，便可讓 F45 使用相同 II、trip 和 startup 成本；`steps` 保留共同 mapper 的 `max time_step + 1`。

ORBIT 的 score JSONL 可讀 startup 和預期 II，但 `MapJointSchedulingTasksPass` 仍會映射 kernel；預期 II 相等目前只輸出 equality attribute，不會因 mismatch 直接失敗。因此要用同一個 ORBIT mapper/cache，並把每 task II equality 作為配對 run 的硬性驗證。

把 F45 選出的 shape 回放到共同 canonical module，可用現有 `--enumerate-analytical-task-candidates` 加 `--materialize-analytical-task-candidate`。這條路徑驗證 task 順序、靜態 trips、架構與合法方向，且不依賴原 F45 body-equivalence 或固定決策 provenance。Radar 的所有選擇已是 1×1/single replica；`scripts/run_input0_all_unit_baselines.py:172-185` 展示了 max-CGRA=1 的 factored candidate、`candidate-0` materialization、MapJoint 與 native schedule。Harris Task_1 kernel fixture 可直接沿用交叉映射診斷腳本與兩份固定 DFG。

一項明確限制：F45 `TaskScheduler` 使用 Taskflow dependencies 和每-task latency，但沒有 ORBIT 那種 routed link/network cost input；F45 的內部目標是 `pipeline_interval`。因此把 F45 pipeline interval 留作演算法變數，再把兩邊選出的 resource choices 都交給共同 ORBIT production scheduler 和相同 network 評估最終 makespan。若選擇包含多個 replica，需另用 source-owned replica materializer，且兩邊共用一個 replica duration policy。

詳細數值、檔案與 C++ 行號見同目錄的 `attribution.json`。

## Harris held-S2 卷積 tiling：改善來自資料流重疊，不是 PE 總工作量下降

`controlled-conv-runtime.json` 記錄三組 mapper、numeric 與 trace 全通過的對照：control 為 899,620 cycles，只將 Task_2 做 axis-0 factor-8 tiling 為 872,911，Task_2/3/4 都 factor-8 為 823,640，總改善 75,980 cycles（8.4458%）。但三個卷積 task 的 duration 加總沒有下降：control 是 116,305 cycles；只切 Task_2 是 116,319（多 14）；切 Task_2/3/4 是 116,354（多 49）。因此整體改善由分塊執行和傳輸重疊帶來。

trace 的控制 critical path 是 Task_0.replica.2 → Task_1.replica.1 → Task_2 → Task_3 → Task_5 → Task_9 → Task_12 → Task_15 → Task_16 → Task_17 → Task_18 → Task_19 → Task_20.replica.1 → Task_21.replica.1 → Task_22 → Task_23。三個 task 都切分時，成為 Task_3.tile.0.7 → Task_5 → Task_9 → Task_12 → Task_15 → Task_16 → Task_17 → Task_18 → Task_19 → Task_20.replica.1 → Task_21.replica.1 → Task_22 → Task_23。Task_5 本身仍花 69,175 cycles，Task_5→Task_9 仍傳 1,048,576 bits；route 延遲由 control 的 32,770 降為 32,769 cycles（path latency 由 2 降為 1）。上游分塊讓 Task_5 提早 75,979 cycles 開始，Task_9 提早 75,980 cycles；之後 critical suffix 的 duration 和 route transfer 都相同，這個時間差一路傳到 Task_23。

Task_4→Task_6 的非關鍵支線從一筆 1,048,576-bit route 變成八筆分塊 route，總 payload 245,952 bits，最晚在 cycle 158,355 到達；它已不再限制 makespan。真正限制 final time 的是未切分的 Task_5 輸出與後續長鏈。task-start、end、route 和 payload 數值都從三個 native MLIR 的 `joint_scheduling_actual_trace` 解析。

另有輸入 fan-out 限制：control 時 Task_1.replica.0 和 .1 各以一筆 1,048,576-bit edge 輸入 Task_2，兩者合計 2,097,152 bits。Task_2 切八塊後，每個來源仍要向八個 child 傳完整 1,048,576 bits，單一來源 8,388,608 bits，兩來源合計 16,777,216 bits，是八倍 trace payload。這顯示輸出 tile 有區域證明，但這些輸入讀取沒有每 tile 的 input-region 證明；這是 mapper trace 的 edge-volume，不等同於直接量到八倍實際 DRAM 讀取。

## QKV factor-8 三 task 群組：可行動作與搜尋建議

保守的 QKV8 診斷將 Task_0、Task_1、Task_2 都以 axis 0、factor 8 切分，native cycles 從 595,551,249 降至 430,140,475，減少 165,410,774（27.7744%）。共同 mapper equality、獨立 trace 和 numeric 檢查通過；numeric gate 比較 131,072 個元素、0 mismatch。SRAM gate 仍 pending，formal admission 未宣稱，故 `production_ready=false`。這是診斷證據，不代表它已成為搜尋 winner。

目前 `JointNeighborhoodActions.cpp` 會輸出單 task tiling；producer-consumer co-tiling 只按直接 SSA edge、factor 2 配對。stage 5 的 pairwise action 是 fusion，沒有對兩至四個獨立 producer 作 atomic grouped tiling。這正是可補的搜尋空隙：可按 SSA/task DAG 形成 deterministic、至多四個兩兩不可比較、在同一 bounded dependency cone 匯合的 producer 組，把組內 tile primitives 包成一個 `NeighborhoodAction`，並由既有 materializer 做 fail-closed legality 檢查。這項建議以拓樸和來源證明產生候選，不硬編碼 QKV 名稱；目前還不能聲稱新增後必定找回上述候選。
