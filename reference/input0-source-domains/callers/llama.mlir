module {
  func.func @_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg5: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg6: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg7: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg8: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>}) attributes {amoeba.graph_variant_id = "identity", amoeba.static_bound.arg.0 = 320 : i64, joint_scheduling_actual_makespan = 653107729 : i64, joint_scheduling_actual_trace = {candidate_id = "shape-19175518/schedule-0", communication_mode = "explicit", dependencies = [{consumer = "Task_3", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_0", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_3", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_1", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_4", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 8388608 : i64, producer = "Task_3", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 16384 : i64, producer = "Task_4", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 8388608 : i64, producer = "Task_4", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_4", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 8388608 : i64, producer = "Task_5", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_2", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_7", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_6", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_8", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_7", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_8", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_7", producer_index = 1 : i32, producer_segment = "done_writes"}], routes = [{bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_3", destination_col = 1 : i32, destination_row = 0 : i32, edge_indices = [0 : i32], links = [{col = 1 : i32, end_cycle = 167903233 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 167772161 : i64}], path_latency_cycles = 0 : i64, payload_bits = 4194304 : i64, producer = "Task_0", ready_cycle = 167903233 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 131072 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_3", destination_col = 2 : i32, destination_row = 0 : i32, edge_indices = [1 : i32], links = [{col = 2 : i32, end_cycle = 167903233 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 167772161 : i64}], path_latency_cycles = 0 : i64, payload_bits = 4194304 : i64, producer = "Task_1", ready_cycle = 167903233 : i64, source_col = 2 : i32, source_row = 0 : i32, transfer_cycles = 131072 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_4", destination_col = 1 : i32, destination_row = 0 : i32, edge_indices = [2 : i32], links = [{col = 1 : i32, end_cycle = 377880578 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 377618434 : i64}], path_latency_cycles = 0 : i64, payload_bits = 8388608 : i64, producer = "Task_3", ready_cycle = 377880578 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 262144 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_5", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [3 : i32, 4 : i32], links = [{col = 0 : i32, end_cycle = 378962436 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 378699780 : i64}], path_latency_cycles = 0 : i64, payload_bits = 8404992 : i64, producer = "Task_4", ready_cycle = 378962436 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 262656 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_6", destination_col = 0 : i32, destination_row = 2 : i32, edge_indices = [6 : i32], links = [{col = 0 : i32, end_cycle = 379429383 : i64, resource_kind = "local_channel", row = 2 : i32, start_cycle = 379167239 : i64}], path_latency_cycles = 0 : i64, payload_bits = 8388608 : i64, producer = "Task_5", ready_cycle = 379429383 : i64, source_col = 0 : i32, source_row = 2 : i32, transfer_cycles = 262144 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_6", destination_col = 0 : i32, destination_row = 2 : i32, edge_indices = [7 : i32], links = [{end_cycle = 167903234 : i64, link_index = 26 : i32, resource_kind = "network_link", start_cycle = 167772161 : i64}], path_latency_cycles = 1 : i64, payload_bits = 4194304 : i64, producer = "Task_2", ready_cycle = 167903234 : i64, source_col = 0 : i32, source_row = 1 : i32, transfer_cycles = 131073 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_7", destination_col = 1 : i32, destination_row = 2 : i32, edge_indices = [8 : i32], links = [{col = 1 : i32, end_cycle = 380215817 : i64, resource_kind = "local_channel", row = 2 : i32, start_cycle = 380084745 : i64}], path_latency_cycles = 0 : i64, payload_bits = 4194304 : i64, producer = "Task_6", ready_cycle = 380215817 : i64, source_col = 1 : i32, source_row = 2 : i32, transfer_cycles = 131072 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_8", destination_col = 2 : i32, destination_row = 2 : i32, edge_indices = [9 : i32, 10 : i32], links = [{col = 2 : i32, end_cycle = 569221641 : i64, resource_kind = "local_channel", row = 2 : i32, start_cycle = 568959497 : i64}], path_latency_cycles = 0 : i64, payload_bits = 8388608 : i64, producer = "Task_7", ready_cycle = 569221641 : i64, source_col = 2 : i32, source_row = 2 : i32, transfer_cycles = 262144 : i64}], task_schedule = [{cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 1 : i32, row = 0 : i32}], end_cycle = 167772161 : i64, start_cycle = 0 : i64, task = "Task_0"}, {cgra_positions = [{col = 2 : i32, row = 0 : i32}, {col = 3 : i32, row = 0 : i32}], end_cycle = 167772161 : i64, start_cycle = 0 : i64, task = "Task_1"}, {cgra_positions = [{col = 0 : i32, row = 1 : i32}, {col = 1 : i32, row = 1 : i32}], end_cycle = 167772161 : i64, start_cycle = 0 : i64, task = "Task_2"}, {cgra_positions = [{col = 1 : i32, row = 0 : i32}, {col = 2 : i32, row = 0 : i32}], end_cycle = 377618434 : i64, start_cycle = 167903233 : i64, task = "Task_3"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 1 : i32, row = 0 : i32}], end_cycle = 378699780 : i64, start_cycle = 377880578 : i64, task = "Task_4"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 0 : i32, row = 1 : i32}, {col = 0 : i32, row = 2 : i32}], end_cycle = 379167239 : i64, start_cycle = 378962436 : i64, task = "Task_5"}, {cgra_positions = [{col = 0 : i32, row = 2 : i32}, {col = 1 : i32, row = 2 : i32}], end_cycle = 380084745 : i64, start_cycle = 379429383 : i64, task = "Task_6"}, {cgra_positions = [{col = 1 : i32, row = 2 : i32}, {col = 2 : i32, row = 2 : i32}, {col = 3 : i32, row = 2 : i32}], end_cycle = 568959497 : i64, start_cycle = 380215817 : i64, task = "Task_7"}, {cgra_positions = [{col = 2 : i32, row = 1 : i32}, {col = 3 : i32, row = 1 : i32}, {col = 2 : i32, row = 2 : i32}, {col = 3 : i32, row = 2 : i32}], end_cycle = 653107729 : i64, start_cycle = 569221641 : i64, task = "Task_8"}]}, joint_scheduling_candidate_id = "shape-19175518/schedule-0", joint_scheduling_candidate_scope = "static-shape-cartesian-product", joint_scheduling_communication_trace = [{bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_3", destination_col = 1 : i32, destination_row = 0 : i32, edge_indices = [0 : i32], links = [{col = 1 : i32, end_cycle = 167903233 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 167772161 : i64}], path_latency_cycles = 0 : i64, payload_bits = 4194304 : i64, producer = "Task_0", ready_cycle = 167903233 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 131072 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_3", destination_col = 2 : i32, destination_row = 0 : i32, edge_indices = [1 : i32], links = [{col = 2 : i32, end_cycle = 167903233 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 167772161 : i64}], path_latency_cycles = 0 : i64, payload_bits = 4194304 : i64, producer = "Task_1", ready_cycle = 167903233 : i64, source_col = 2 : i32, source_row = 0 : i32, transfer_cycles = 131072 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_4", destination_col = 1 : i32, destination_row = 0 : i32, edge_indices = [2 : i32], links = [{col = 1 : i32, end_cycle = 377880578 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 377618434 : i64}], path_latency_cycles = 0 : i64, payload_bits = 8388608 : i64, producer = "Task_3", ready_cycle = 377880578 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 262144 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_5", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [3 : i32, 4 : i32], links = [{col = 0 : i32, end_cycle = 378962436 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 378699780 : i64}], path_latency_cycles = 0 : i64, payload_bits = 8404992 : i64, producer = "Task_4", ready_cycle = 378962436 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 262656 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_6", destination_col = 0 : i32, destination_row = 2 : i32, edge_indices = [6 : i32], links = [{col = 0 : i32, end_cycle = 379429383 : i64, resource_kind = "local_channel", row = 2 : i32, start_cycle = 379167239 : i64}], path_latency_cycles = 0 : i64, payload_bits = 8388608 : i64, producer = "Task_5", ready_cycle = 379429383 : i64, source_col = 0 : i32, source_row = 2 : i32, transfer_cycles = 262144 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_6", destination_col = 0 : i32, destination_row = 2 : i32, edge_indices = [7 : i32], links = [{end_cycle = 167903234 : i64, link_index = 26 : i32, resource_kind = "network_link", start_cycle = 167772161 : i64}], path_latency_cycles = 1 : i64, payload_bits = 4194304 : i64, producer = "Task_2", ready_cycle = 167903234 : i64, source_col = 0 : i32, source_row = 1 : i32, transfer_cycles = 131073 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_7", destination_col = 1 : i32, destination_row = 2 : i32, edge_indices = [8 : i32], links = [{col = 1 : i32, end_cycle = 380215817 : i64, resource_kind = "local_channel", row = 2 : i32, start_cycle = 380084745 : i64}], path_latency_cycles = 0 : i64, payload_bits = 4194304 : i64, producer = "Task_6", ready_cycle = 380215817 : i64, source_col = 1 : i32, source_row = 2 : i32, transfer_cycles = 131072 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_8", destination_col = 2 : i32, destination_row = 2 : i32, edge_indices = [9 : i32, 10 : i32], links = [{col = 2 : i32, end_cycle = 569221641 : i64, resource_kind = "local_channel", row = 2 : i32, start_cycle = 568959497 : i64}], path_latency_cycles = 0 : i64, payload_bits = 8388608 : i64, producer = "Task_7", ready_cycle = 569221641 : i64, source_col = 2 : i32, source_row = 2 : i32, transfer_cycles = 262144 : i64}], joint_scheduling_dependency_trace = [{consumer = "Task_3", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_0", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_3", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_1", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_4", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 8388608 : i64, producer = "Task_3", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 16384 : i64, producer = "Task_4", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 8388608 : i64, producer = "Task_4", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_4", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 8388608 : i64, producer = "Task_5", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_2", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_7", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_6", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_8", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_7", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_8", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 4194304 : i64, producer = "Task_7", producer_index = 1 : i32, producer_segment = "done_writes"}], joint_scheduling_graph_variant_id = "identity", joint_scheduling_mapper_cache_hits = 9 : i64, joint_scheduling_mapper_cache_misses = 0 : i64, joint_scheduling_mapper_replay_completed, joint_scheduling_prediction_mapper_equal = false, joint_scheduling_production_dispatch_order = ["Task_0", "Task_1", "Task_3", "Task_4", "Task_2", "Task_5", "Task_6", "Task_7", "Task_8"], joint_scheduling_production_dispatch_policy = "critical-path", joint_scheduling_production_schedule = [{cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 1 : i32, row = 0 : i32}], end_cycle = 167772161 : i64, start_cycle = 0 : i64, task = "Task_0"}, {cgra_positions = [{col = 2 : i32, row = 0 : i32}, {col = 3 : i32, row = 0 : i32}], end_cycle = 167772161 : i64, start_cycle = 0 : i64, task = "Task_1"}, {cgra_positions = [{col = 0 : i32, row = 1 : i32}, {col = 1 : i32, row = 1 : i32}], end_cycle = 167772161 : i64, start_cycle = 0 : i64, task = "Task_2"}, {cgra_positions = [{col = 1 : i32, row = 0 : i32}, {col = 2 : i32, row = 0 : i32}], end_cycle = 377618434 : i64, start_cycle = 167903233 : i64, task = "Task_3"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 1 : i32, row = 0 : i32}], end_cycle = 378699780 : i64, start_cycle = 377880578 : i64, task = "Task_4"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 0 : i32, row = 1 : i32}, {col = 0 : i32, row = 2 : i32}], end_cycle = 379167239 : i64, start_cycle = 378962436 : i64, task = "Task_5"}, {cgra_positions = [{col = 0 : i32, row = 2 : i32}, {col = 1 : i32, row = 2 : i32}], end_cycle = 380084745 : i64, start_cycle = 379429383 : i64, task = "Task_6"}, {cgra_positions = [{col = 1 : i32, row = 2 : i32}, {col = 2 : i32, row = 2 : i32}, {col = 3 : i32, row = 2 : i32}], end_cycle = 568959497 : i64, start_cycle = 380215817 : i64, task = "Task_7"}, {cgra_positions = [{col = 2 : i32, row = 1 : i32}, {col = 3 : i32, row = 1 : i32}, {col = 2 : i32, row = 2 : i32}, {col = 3 : i32, row = 2 : i32}], end_cycle = 653107729 : i64, start_cycle = 569221641 : i64, task = "Task_8"}], joint_scheduling_replay_verified, joint_scheduling_scheduler_backend = "orchestrate-tasks-on-accelerators", llvm.linkage = #llvm.linkage<external>} {
    %c320 = arith.constant 320 : index
    %c1024_i32 = arith.constant 1024 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<512x256xi32>
    %alloca_0 = memref.alloca() : memref<512x256xi32>
    %alloca_1 = memref.alloca() : memref<512x256xi32>
    %alloca_2 = memref.alloca() : memref<512xi32>
    %alloca_3 = memref.alloca() : memref<512x512xi32>
    %alloca_4 = memref.alloca() : memref<512x512xi32>
    %alloca_5 = memref.alloca() : memref<512x256xi32>
    %alloca_6 = memref.alloca() : memref<512x256xi32>
    %alloca_7 = memref.alloca() : memref<512x256xi32>
    %c256 = arith.constant 256 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %true = arith.constant true
    %c0_8 = arith.constant 0 : index
    %dim = memref.dim %arg1, %c0_8 : memref<?x256xi32>
    %c0_9 = arith.constant 0 : index
    %dim_10 = memref.dim %arg2, %c0_9 : memref<?x256xi32>
    %c0_11 = arith.constant 0 : index
    %c1_12 = arith.constant 1 : index
    %c0_13 = arith.constant 0 : index
    %c256_14 = arith.constant 256 : index
    %c1_15 = arith.constant 1 : index
    %c0_16 = arith.constant 0 : index
    %c256_17 = arith.constant 256 : index
    %c1_18 = arith.constant 1 : index
    %c0_i32_19 = arith.constant 0 : i32
    %false = arith.constant false
    scf.for %arg9 = %c0_11 to %c320 step %c1_12 {
      scf.for %arg10 = %c0_13 to %c256_14 step %c1_15 {
        %0:4 = scf.for %arg11 = %c0_16 to %c256_17 step %c1_18 iter_args(%arg12 = %c0_i32, %arg13 = %true, %arg14 = %c0_i32_19, %arg15 = %false) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_16 : index
          %2 = arith.andi %true, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_137 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_137 : index
          %6 = arith.andi %true, %true : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_138 = arith.constant true
          %17 = arith.xori %5, %true_138 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_139 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_139 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_140 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_140 : index
          %c256_141 = arith.constant 256 : index
          %34 = arith.cmpi slt, %arg10, %c256_141 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_7[%arg9, %arg10] : memref<512x256xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true, %44 : i1
          %c0_142 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_142 : index
          %47 = arith.cmpi slt, %43, %dim : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_143 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_143 : index
          %c256_144 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_144 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %89 = memref.load %arg1[%43, %41] : memref<?x256xi32>
            scf.yield %89 : i32
          } else {
            %c0_i32_153 = arith.constant 0 : i32
            scf.yield %c0_i32_153 : i32
          }
          %56 = arith.andi %true, %42 : i1
          %c0_145 = arith.constant 0 : index
          %57 = arith.cmpi sge, %41, %c0_145 : index
          %58 = arith.cmpi slt, %41, %dim_10 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %40 : i1
          %c0_146 = arith.constant 0 : index
          %62 = arith.cmpi sge, %39, %c0_146 : index
          %c256_147 = arith.constant 256 : index
          %63 = arith.cmpi slt, %39, %c256_147 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %89 = memref.load %arg2[%41, %39] : memref<?x256xi32>
            scf.yield %89 : i32
          } else {
            %c0_i32_153 = arith.constant 0 : i32
            scf.yield %c0_i32_153 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true : i1
          %72 = arith.andi %71, %44 : i1
          %c0_148 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_148 : index
          %c512_149 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_149 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_150 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_150 : index
          %c256_151 = arith.constant 256 : index
          %79 = arith.cmpi slt, %39, %c256_151 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_7[%43, %39] : memref<512x256xi32>
          }
          %true_152 = arith.constant true
          %82 = arith.xori %true, %true_152 : i1
          %83 = arith.andi %true, %82 : i1
          %84 = arith.andi %4, %83 : i1
          %85 = arith.select %84, %3, %arg14 : i32
          %86 = arith.ori %84, %arg15 : i1
          %87 = arith.select %69, %70, %arg12 : i32
          %88 = arith.ori %69, %arg13 : i1
          scf.yield %87, %88, %85, %86 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_0"}
    %c256_20 = arith.constant 256 : index
    %c0_21 = arith.constant 0 : index
    %c1_22 = arith.constant 1 : index
    %true_23 = arith.constant true
    %c0_24 = arith.constant 0 : index
    %dim_25 = memref.dim %arg1, %c0_24 : memref<?x256xi32>
    %c0_26 = arith.constant 0 : index
    %dim_27 = memref.dim %arg3, %c0_26 : memref<?x256xi32>
    %c0_28 = arith.constant 0 : index
    %c1_29 = arith.constant 1 : index
    %c0_30 = arith.constant 0 : index
    %c256_31 = arith.constant 256 : index
    %c1_32 = arith.constant 1 : index
    %c0_33 = arith.constant 0 : index
    %c256_34 = arith.constant 256 : index
    %c1_35 = arith.constant 1 : index
    %c0_i32_36 = arith.constant 0 : i32
    %false_37 = arith.constant false
    scf.for %arg9 = %c0_28 to %c320 step %c1_29 {
      scf.for %arg10 = %c0_30 to %c256_31 step %c1_32 {
        %0:4 = scf.for %arg11 = %c0_33 to %c256_34 step %c1_35 iter_args(%arg12 = %c0_i32, %arg13 = %true_23, %arg14 = %c0_i32_36, %arg15 = %false_37) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_33 : index
          %2 = arith.andi %true_23, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_137 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_137 : index
          %6 = arith.andi %true_23, %true_23 : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true_23, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true_23, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true_23, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true_23, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_138 = arith.constant true
          %17 = arith.xori %5, %true_138 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true_23, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true_23, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true_23, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true_23, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_139 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_139 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_140 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_140 : index
          %c256_141 = arith.constant 256 : index
          %34 = arith.cmpi slt, %arg10, %c256_141 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_6[%arg9, %arg10] : memref<512x256xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true_23, %44 : i1
          %c0_142 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_142 : index
          %47 = arith.cmpi slt, %43, %dim_25 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_143 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_143 : index
          %c256_144 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_144 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %89 = memref.load %arg1[%43, %41] : memref<?x256xi32>
            scf.yield %89 : i32
          } else {
            %c0_i32_153 = arith.constant 0 : i32
            scf.yield %c0_i32_153 : i32
          }
          %56 = arith.andi %true_23, %42 : i1
          %c0_145 = arith.constant 0 : index
          %57 = arith.cmpi sge, %41, %c0_145 : index
          %58 = arith.cmpi slt, %41, %dim_27 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %40 : i1
          %c0_146 = arith.constant 0 : index
          %62 = arith.cmpi sge, %39, %c0_146 : index
          %c256_147 = arith.constant 256 : index
          %63 = arith.cmpi slt, %39, %c256_147 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %89 = memref.load %arg3[%41, %39] : memref<?x256xi32>
            scf.yield %89 : i32
          } else {
            %c0_i32_153 = arith.constant 0 : i32
            scf.yield %c0_i32_153 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true_23 : i1
          %72 = arith.andi %71, %44 : i1
          %c0_148 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_148 : index
          %c512_149 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_149 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_150 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_150 : index
          %c256_151 = arith.constant 256 : index
          %79 = arith.cmpi slt, %39, %c256_151 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_6[%43, %39] : memref<512x256xi32>
          }
          %true_152 = arith.constant true
          %82 = arith.xori %true_23, %true_152 : i1
          %83 = arith.andi %true_23, %82 : i1
          %84 = arith.andi %4, %83 : i1
          %85 = arith.select %84, %3, %arg14 : i32
          %86 = arith.ori %84, %arg15 : i1
          %87 = arith.select %69, %70, %arg12 : i32
          %88 = arith.ori %69, %arg13 : i1
          scf.yield %87, %88, %85, %86 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_1"}
    %c256_38 = arith.constant 256 : index
    %c0_39 = arith.constant 0 : index
    %c1_40 = arith.constant 1 : index
    %true_41 = arith.constant true
    %c0_42 = arith.constant 0 : index
    %dim_43 = memref.dim %arg1, %c0_42 : memref<?x256xi32>
    %c0_44 = arith.constant 0 : index
    %dim_45 = memref.dim %arg4, %c0_44 : memref<?x256xi32>
    %c0_46 = arith.constant 0 : index
    %c1_47 = arith.constant 1 : index
    %c0_48 = arith.constant 0 : index
    %c256_49 = arith.constant 256 : index
    %c1_50 = arith.constant 1 : index
    %c0_51 = arith.constant 0 : index
    %c256_52 = arith.constant 256 : index
    %c1_53 = arith.constant 1 : index
    %c0_i32_54 = arith.constant 0 : i32
    %false_55 = arith.constant false
    scf.for %arg9 = %c0_46 to %c320 step %c1_47 {
      scf.for %arg10 = %c0_48 to %c256_49 step %c1_50 {
        %0:4 = scf.for %arg11 = %c0_51 to %c256_52 step %c1_53 iter_args(%arg12 = %c0_i32, %arg13 = %true_41, %arg14 = %c0_i32_54, %arg15 = %false_55) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_51 : index
          %2 = arith.andi %true_41, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_137 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_137 : index
          %6 = arith.andi %true_41, %true_41 : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true_41, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true_41, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true_41, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true_41, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_138 = arith.constant true
          %17 = arith.xori %5, %true_138 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true_41, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true_41, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true_41, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true_41, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_139 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_139 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_140 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_140 : index
          %c256_141 = arith.constant 256 : index
          %34 = arith.cmpi slt, %arg10, %c256_141 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_5[%arg9, %arg10] : memref<512x256xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true_41, %44 : i1
          %c0_142 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_142 : index
          %47 = arith.cmpi slt, %43, %dim_43 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_143 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_143 : index
          %c256_144 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_144 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %89 = memref.load %arg1[%43, %41] : memref<?x256xi32>
            scf.yield %89 : i32
          } else {
            %c0_i32_153 = arith.constant 0 : i32
            scf.yield %c0_i32_153 : i32
          }
          %56 = arith.andi %true_41, %42 : i1
          %c0_145 = arith.constant 0 : index
          %57 = arith.cmpi sge, %41, %c0_145 : index
          %58 = arith.cmpi slt, %41, %dim_45 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %40 : i1
          %c0_146 = arith.constant 0 : index
          %62 = arith.cmpi sge, %39, %c0_146 : index
          %c256_147 = arith.constant 256 : index
          %63 = arith.cmpi slt, %39, %c256_147 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %89 = memref.load %arg4[%41, %39] : memref<?x256xi32>
            scf.yield %89 : i32
          } else {
            %c0_i32_153 = arith.constant 0 : i32
            scf.yield %c0_i32_153 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true_41 : i1
          %72 = arith.andi %71, %44 : i1
          %c0_148 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_148 : index
          %c512_149 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_149 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_150 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_150 : index
          %c256_151 = arith.constant 256 : index
          %79 = arith.cmpi slt, %39, %c256_151 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_5[%43, %39] : memref<512x256xi32>
          }
          %true_152 = arith.constant true
          %82 = arith.xori %true_41, %true_152 : i1
          %83 = arith.andi %true_41, %82 : i1
          %84 = arith.andi %4, %83 : i1
          %85 = arith.select %84, %3, %arg14 : i32
          %86 = arith.ori %84, %arg15 : i1
          %87 = arith.select %69, %70, %arg12 : i32
          %88 = arith.ori %69, %arg13 : i1
          scf.yield %87, %88, %85, %86 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_2"}
    %c256_56 = arith.constant 256 : index
    %c0_57 = arith.constant 0 : index
    %c1_58 = arith.constant 1 : index
    %true_59 = arith.constant true
    %c0_60 = arith.constant 0 : index
    %c1_61 = arith.constant 1 : index
    %c0_62 = arith.constant 0 : index
    %c1_63 = arith.constant 1 : index
    %c0_64 = arith.constant 0 : index
    %c256_65 = arith.constant 256 : index
    %c1_66 = arith.constant 1 : index
    %c0_i32_67 = arith.constant 0 : i32
    %false_68 = arith.constant false
    scf.for %arg9 = %c0_60 to %c320 step %c1_61 {
      scf.for %arg10 = %c0_62 to %c320 step %c1_63 {
        %0:4 = scf.for %arg11 = %c0_64 to %c256_65 step %c1_66 iter_args(%arg12 = %c0_i32, %arg13 = %true_59, %arg14 = %c0_i32_67, %arg15 = %false_68) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_64 : index
          %2 = arith.andi %true_59, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_137 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_137 : index
          %6 = arith.andi %true_59, %true_59 : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true_59, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true_59, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true_59, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true_59, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_138 = arith.constant true
          %17 = arith.xori %5, %true_138 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true_59, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true_59, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true_59, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true_59, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_139 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_139 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_140 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_140 : index
          %c512_141 = arith.constant 512 : index
          %34 = arith.cmpi slt, %arg10, %c512_141 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_4[%arg9, %arg10] : memref<512x512xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true_59, %44 : i1
          %c0_142 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_142 : index
          %c512_143 = arith.constant 512 : index
          %47 = arith.cmpi slt, %43, %c512_143 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_144 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_144 : index
          %c256_145 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_145 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %89 = memref.load %alloca_7[%43, %41] : memref<512x256xi32>
            scf.yield %89 : i32
          } else {
            %c0_i32_155 = arith.constant 0 : i32
            scf.yield %c0_i32_155 : i32
          }
          %56 = arith.andi %true_59, %40 : i1
          %c0_146 = arith.constant 0 : index
          %57 = arith.cmpi sge, %39, %c0_146 : index
          %c512_147 = arith.constant 512 : index
          %58 = arith.cmpi slt, %39, %c512_147 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %42 : i1
          %c0_148 = arith.constant 0 : index
          %62 = arith.cmpi sge, %41, %c0_148 : index
          %c256_149 = arith.constant 256 : index
          %63 = arith.cmpi slt, %41, %c256_149 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %89 = memref.load %alloca_6[%39, %41] : memref<512x256xi32>
            scf.yield %89 : i32
          } else {
            %c0_i32_155 = arith.constant 0 : i32
            scf.yield %c0_i32_155 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true_59 : i1
          %72 = arith.andi %71, %44 : i1
          %c0_150 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_150 : index
          %c512_151 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_151 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_152 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_152 : index
          %c512_153 = arith.constant 512 : index
          %79 = arith.cmpi slt, %39, %c512_153 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_4[%43, %39] : memref<512x512xi32>
          }
          %true_154 = arith.constant true
          %82 = arith.xori %true_59, %true_154 : i1
          %83 = arith.andi %true_59, %82 : i1
          %84 = arith.andi %4, %83 : i1
          %85 = arith.select %84, %3, %arg14 : i32
          %86 = arith.ori %84, %arg15 : i1
          %87 = arith.select %69, %70, %arg12 : i32
          %88 = arith.ori %69, %arg13 : i1
          scf.yield %87, %88, %85, %86 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_3"}
    %c0_69 = arith.constant 0 : index
    %c1_70 = arith.constant 1 : index
    %true_71 = arith.constant true
    %c0_72 = arith.constant 0 : index
    %c1_73 = arith.constant 1 : index
    %c0_74 = arith.constant 0 : index
    %c1_75 = arith.constant 1 : index
    %c0_i32_76 = arith.constant 0 : i32
    %false_77 = arith.constant false
    scf.for %arg9 = %c0_72 to %c320 step %c1_73 {
      %0:4 = scf.for %arg10 = %c0_74 to %c320 step %c1_75 iter_args(%arg11 = %c0_i32, %arg12 = %true_71, %arg13 = %c0_i32_76, %arg14 = %false_77) -> (i32, i1, i32, i1) {
        %1 = arith.cmpi eq, %arg10, %c0_74 : index
        %2 = arith.andi %true_71, %1 : i1
        %3 = arith.select %2, %c0_i32, %arg11 : i32
        %4 = arith.ori %2, %arg12 : i1
        %c0_137 = arith.constant 0 : index
        %5 = arith.cmpi eq, %arg10, %c0_137 : index
        %6 = arith.andi %true_71, %true_71 : i1
        %7 = arith.andi %6, %5 : i1
        %8 = arith.andi %true_71, %7 : i1
        %9 = arith.andi %6, %5 : i1
        %10 = arith.andi %true_71, %9 : i1
        %11 = arith.andi %6, %5 : i1
        %12 = arith.andi %true_71, %11 : i1
        %13 = arith.andi %6, %5 : i1
        %14 = arith.andi %4, %13 : i1
        %true_138 = arith.constant true
        %15 = arith.xori %5, %true_138 : i1
        %16 = arith.andi %6, %15 : i1
        %17 = arith.andi %true_71, %16 : i1
        %18 = arith.andi %6, %15 : i1
        %19 = arith.andi %true_71, %18 : i1
        %20 = arith.andi %6, %15 : i1
        %21 = arith.andi %4, %20 : i1
        %22 = arith.andi %true_71, %8 : i1
        %23 = arith.andi %22, %10 : i1
        %c0_139 = arith.constant 0 : index
        %24 = arith.cmpi sge, %arg9, %c0_139 : index
        %c512 = arith.constant 512 : index
        %25 = arith.cmpi slt, %arg9, %c512 : index
        %26 = arith.andi %24, %25 : i1
        %27 = arith.andi %23, %26 : i1
        scf.if %27 {
          memref.store %c0_i32, %alloca_2[%arg9] : memref<512xi32>
        }
        %28 = arith.select %21, %3, %3 : i32
        %29 = arith.ori %21, %14 : i1
        %30 = arith.select %19, %arg10, %arg10 : index
        %31 = arith.ori %19, %12 : i1
        %32 = arith.select %17, %arg9, %arg9 : index
        %33 = arith.ori %17, %10 : i1
        %34 = arith.andi %true_71, %33 : i1
        %c0_140 = arith.constant 0 : index
        %35 = arith.cmpi sge, %32, %c0_140 : index
        %c512_141 = arith.constant 512 : index
        %36 = arith.cmpi slt, %32, %c512_141 : index
        %37 = arith.andi %35, %36 : i1
        %38 = arith.andi %34, %37 : i1
        %39 = arith.andi %38, %31 : i1
        %c0_142 = arith.constant 0 : index
        %40 = arith.cmpi sge, %30, %c0_142 : index
        %c512_143 = arith.constant 512 : index
        %41 = arith.cmpi slt, %30, %c512_143 : index
        %42 = arith.andi %40, %41 : i1
        %43 = arith.andi %39, %42 : i1
        %44 = scf.if %43 -> (i32) {
          %75 = memref.load %alloca_4[%32, %30] : memref<512x512xi32>
          scf.yield %75 : i32
        } else {
          %c0_i32_151 = arith.constant 0 : i32
          scf.yield %c0_i32_151 : i32
        }
        %45 = arith.andi %43, %43 : i1
        %46 = arith.muli %44, %44 : i32
        %47 = arith.andi %45, %true_71 : i1
        %48 = arith.addi %46, %c1_i32 : i32
        %49 = arith.andi %47, %true_71 : i1
        %50 = arith.andi %49, %33 : i1
        %c0_144 = arith.constant 0 : index
        %51 = arith.cmpi sge, %32, %c0_144 : index
        %c512_145 = arith.constant 512 : index
        %52 = arith.cmpi slt, %32, %c512_145 : index
        %53 = arith.andi %51, %52 : i1
        %54 = arith.andi %50, %53 : i1
        %55 = arith.andi %54, %31 : i1
        %c0_146 = arith.constant 0 : index
        %56 = arith.cmpi sge, %30, %c0_146 : index
        %c512_147 = arith.constant 512 : index
        %57 = arith.cmpi slt, %30, %c512_147 : index
        %58 = arith.andi %56, %57 : i1
        %59 = arith.andi %55, %58 : i1
        scf.if %59 {
          memref.store %48, %alloca_3[%32, %30] : memref<512x512xi32>
        }
        %60 = arith.andi %29, %47 : i1
        %61 = arith.addi %28, %48 : i32
        %62 = arith.andi %60, %true_71 : i1
        %63 = arith.andi %62, %33 : i1
        %c0_148 = arith.constant 0 : index
        %64 = arith.cmpi sge, %32, %c0_148 : index
        %c512_149 = arith.constant 512 : index
        %65 = arith.cmpi slt, %32, %c512_149 : index
        %66 = arith.andi %64, %65 : i1
        %67 = arith.andi %63, %66 : i1
        scf.if %67 {
          memref.store %61, %alloca_2[%32] : memref<512xi32>
        }
        %true_150 = arith.constant true
        %68 = arith.xori %true_71, %true_150 : i1
        %69 = arith.andi %true_71, %68 : i1
        %70 = arith.andi %4, %69 : i1
        %71 = arith.select %70, %3, %arg13 : i32
        %72 = arith.ori %70, %arg14 : i1
        %73 = arith.select %60, %61, %arg11 : i32
        %74 = arith.ori %60, %arg12 : i1
        scf.yield %73, %74, %71, %72 : i32, i1, i32, i1
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_4"}
    %c0_78 = arith.constant 0 : index
    %c1_79 = arith.constant 1 : index
    %true_80 = arith.constant true
    %c0_81 = arith.constant 0 : index
    %c1_82 = arith.constant 1 : index
    %c0_83 = arith.constant 0 : index
    %c1_84 = arith.constant 1 : index
    scf.for %arg9 = %c0_81 to %c320 step %c1_82 {
      scf.for %arg10 = %c0_83 to %c320 step %c1_84 {
        %0 = arith.cmpi eq, %arg10, %c0_83 : index
        %1 = arith.andi %true_80, %true_80 : i1
        %c0_137 = arith.constant 0 : index
        %2 = arith.cmpi sge, %arg9, %c0_137 : index
        %c512 = arith.constant 512 : index
        %3 = arith.cmpi slt, %arg9, %c512 : index
        %4 = arith.andi %2, %3 : i1
        %5 = arith.andi %1, %4 : i1
        %6 = scf.if %5 -> (i32) {
          %37 = memref.load %alloca_2[%arg9] : memref<512xi32>
          scf.yield %37 : i32
        } else {
          %c0_i32_147 = arith.constant 0 : i32
          scf.yield %c0_i32_147 : i32
        }
        %7 = arith.andi %5, %true_80 : i1
        %8 = arith.addi %6, %c1_i32 : i32
        %9 = arith.andi %true_80, %true_80 : i1
        %c0_138 = arith.constant 0 : index
        %10 = arith.cmpi sge, %arg9, %c0_138 : index
        %c512_139 = arith.constant 512 : index
        %11 = arith.cmpi slt, %arg9, %c512_139 : index
        %12 = arith.andi %10, %11 : i1
        %13 = arith.andi %9, %12 : i1
        %14 = arith.andi %13, %true_80 : i1
        %c0_140 = arith.constant 0 : index
        %15 = arith.cmpi sge, %arg10, %c0_140 : index
        %c512_141 = arith.constant 512 : index
        %16 = arith.cmpi slt, %arg10, %c512_141 : index
        %17 = arith.andi %15, %16 : i1
        %18 = arith.andi %14, %17 : i1
        %19 = scf.if %18 -> (i32) {
          %37 = memref.load %alloca_3[%arg9, %arg10] : memref<512x512xi32>
          scf.yield %37 : i32
        } else {
          %c0_i32_147 = arith.constant 0 : i32
          scf.yield %c0_i32_147 : i32
        }
        %20 = arith.andi %18, %true_80 : i1
        %21 = arith.muli %19, %c1024_i32 : i32
        %22 = arith.andi %20, %7 : i1
        %c0_i32_142 = arith.constant 0 : i32
        %23 = arith.cmpi ne, %8, %c0_i32_142 : i32
        %24 = arith.andi %22, %23 : i1
        %25 = scf.if %24 -> (i32) {
          %37 = arith.divsi %21, %8 : i32
          scf.yield %37 : i32
        } else {
          %c0_i32_147 = arith.constant 0 : i32
          scf.yield %c0_i32_147 : i32
        }
        %26 = arith.andi %24, %true_80 : i1
        %27 = arith.andi %26, %true_80 : i1
        %c0_143 = arith.constant 0 : index
        %28 = arith.cmpi sge, %arg9, %c0_143 : index
        %c512_144 = arith.constant 512 : index
        %29 = arith.cmpi slt, %arg9, %c512_144 : index
        %30 = arith.andi %28, %29 : i1
        %31 = arith.andi %27, %30 : i1
        %32 = arith.andi %31, %true_80 : i1
        %c0_145 = arith.constant 0 : index
        %33 = arith.cmpi sge, %arg10, %c0_145 : index
        %c512_146 = arith.constant 512 : index
        %34 = arith.cmpi slt, %arg10, %c512_146 : index
        %35 = arith.andi %33, %34 : i1
        %36 = arith.andi %32, %35 : i1
        scf.if %36 {
          memref.store %25, %alloca_3[%arg9, %arg10] : memref<512x512xi32>
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_5"}
    %c256_85 = arith.constant 256 : index
    %c0_86 = arith.constant 0 : index
    %c1_87 = arith.constant 1 : index
    %true_88 = arith.constant true
    %c0_89 = arith.constant 0 : index
    %c1_90 = arith.constant 1 : index
    %c0_91 = arith.constant 0 : index
    %c256_92 = arith.constant 256 : index
    %c1_93 = arith.constant 1 : index
    %c0_94 = arith.constant 0 : index
    %false_95 = arith.constant false
    %c0_96 = arith.constant 0 : index
    %false_97 = arith.constant false
    %c0_i32_98 = arith.constant 0 : i32
    %false_99 = arith.constant false
    %c0_i64 = arith.constant 0 : i64
    %false_100 = arith.constant false
    scf.for %arg9 = %c0_89 to %c320 step %c1_90 {
      scf.for %arg10 = %c0_91 to %c256_92 step %c1_93 {
        %c1_137 = arith.constant 1 : index
        %0 = arith.addi %c320, %c1_137 : index
        %c0_138 = arith.constant 0 : index
        %1:8 = scf.for %arg11 = %c0_138 to %0 step %c1_137 iter_args(%arg12 = %c0_94, %arg13 = %false_95, %arg14 = %c0_96, %arg15 = %false_97, %arg16 = %c0_i32_98, %arg17 = %false_99, %arg18 = %c0_i64, %arg19 = %false_100) -> (index, i1, index, i1, i32, i1, i64, i1) {
          %2 = arith.cmpi eq, %arg11, %c0_138 : index
          %c0_139 = arith.constant 0 : index
          %3 = arith.index_cast %c0_139 : index to i64
          %4 = arith.andi %true_88, %true_88 : i1
          %5 = arith.andi %4, %true_88 : i1
          %c0_140 = arith.constant 0 : index
          %6 = arith.cmpi sge, %arg9, %c0_140 : index
          %c512 = arith.constant 512 : index
          %7 = arith.cmpi slt, %arg9, %c512 : index
          %8 = arith.andi %6, %7 : i1
          %9 = arith.andi %5, %8 : i1
          %10 = arith.andi %9, %true_88 : i1
          %c0_141 = arith.constant 0 : index
          %11 = arith.cmpi sge, %arg10, %c0_141 : index
          %c256_142 = arith.constant 256 : index
          %12 = arith.cmpi slt, %arg10, %c256_142 : index
          %13 = arith.andi %11, %12 : i1
          %14 = arith.andi %10, %13 : i1
          %15 = arith.andi %14, %2 : i1
          scf.if %15 {
            memref.store %c0_i32, %alloca_1[%arg9, %arg10] : memref<512x256xi32>
          }
          %16 = arith.select %arg13, %arg12, %arg10 : index
          %17 = arith.ori %arg13, %true_88 : i1
          %18 = arith.select %arg15, %arg14, %arg9 : index
          %19 = arith.ori %arg15, %true_88 : i1
          %20 = arith.select %arg17, %arg16, %c0_i32 : i32
          %21 = arith.ori %arg17, %true_88 : i1
          %22 = arith.select %arg19, %arg18, %3 : i64
          %23 = arith.ori %arg19, %true_88 : i1
          %24 = arith.index_cast %22 : i64 to index
          %25 = arith.cmpi slt, %24, %c320 : index
          %26 = arith.andi %23, %true_88 : i1
          %27 = arith.andi %26, %25 : i1
          %28 = arith.andi %19, %27 : i1
          %29 = arith.andi %26, %25 : i1
          %30 = arith.andi %23, %29 : i1
          %31 = arith.andi %26, %25 : i1
          %32 = arith.andi %17, %31 : i1
          %33 = arith.andi %26, %25 : i1
          %34 = arith.andi %21, %33 : i1
          %true_143 = arith.constant true
          %35 = arith.xori %25, %true_143 : i1
          %36 = arith.andi %26, %35 : i1
          %37 = arith.andi %19, %36 : i1
          %38 = arith.andi %26, %35 : i1
          %39 = arith.andi %17, %38 : i1
          %40 = arith.andi %true_88, %37 : i1
          %c0_144 = arith.constant 0 : index
          %41 = arith.cmpi sge, %18, %c0_144 : index
          %c512_145 = arith.constant 512 : index
          %42 = arith.cmpi slt, %18, %c512_145 : index
          %43 = arith.andi %41, %42 : i1
          %44 = arith.andi %40, %43 : i1
          %45 = arith.andi %44, %39 : i1
          %c0_146 = arith.constant 0 : index
          %46 = arith.cmpi sge, %16, %c0_146 : index
          %c256_147 = arith.constant 256 : index
          %47 = arith.cmpi slt, %16, %c256_147 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = scf.if %49 -> (i32) {
            %114 = memref.load %alloca_1[%18, %16] : memref<512x256xi32>
            scf.yield %114 : i32
          } else {
            %c0_i32_166 = arith.constant 0 : i32
            scf.yield %c0_i32_166 : i32
          }
          %51 = arith.andi %49, %true_88 : i1
          %c0_i32_148 = arith.constant 0 : i32
          %52 = arith.cmpi ne, %c1024_i32, %c0_i32_148 : i32
          %53 = arith.andi %51, %52 : i1
          %54 = scf.if %53 -> (i32) {
            %114 = arith.divsi %50, %c1024_i32 : i32
            scf.yield %114 : i32
          } else {
            %c0_i32_166 = arith.constant 0 : i32
            scf.yield %c0_i32_166 : i32
          }
          %55 = arith.andi %53, %true_88 : i1
          %56 = arith.andi %55, %37 : i1
          %c0_149 = arith.constant 0 : index
          %57 = arith.cmpi sge, %18, %c0_149 : index
          %c512_150 = arith.constant 512 : index
          %58 = arith.cmpi slt, %18, %c512_150 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %39 : i1
          %c0_151 = arith.constant 0 : index
          %62 = arith.cmpi sge, %16, %c0_151 : index
          %c256_152 = arith.constant 256 : index
          %63 = arith.cmpi slt, %16, %c256_152 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          scf.if %65 {
            memref.store %54, %alloca_1[%18, %16] : memref<512x256xi32>
          }
          %66 = arith.andi %true_88, %28 : i1
          %c0_153 = arith.constant 0 : index
          %67 = arith.cmpi sge, %18, %c0_153 : index
          %c512_154 = arith.constant 512 : index
          %68 = arith.cmpi slt, %18, %c512_154 : index
          %69 = arith.andi %67, %68 : i1
          %70 = arith.andi %66, %69 : i1
          %71 = arith.andi %70, %30 : i1
          %c0_155 = arith.constant 0 : index
          %72 = arith.cmpi sge, %24, %c0_155 : index
          %c512_156 = arith.constant 512 : index
          %73 = arith.cmpi slt, %24, %c512_156 : index
          %74 = arith.andi %72, %73 : i1
          %75 = arith.andi %71, %74 : i1
          %76 = scf.if %75 -> (i32) {
            %114 = memref.load %alloca_3[%18, %24] : memref<512x512xi32>
            scf.yield %114 : i32
          } else {
            %c0_i32_166 = arith.constant 0 : i32
            scf.yield %c0_i32_166 : i32
          }
          %77 = arith.andi %true_88, %30 : i1
          %c0_157 = arith.constant 0 : index
          %78 = arith.cmpi sge, %24, %c0_157 : index
          %c512_158 = arith.constant 512 : index
          %79 = arith.cmpi slt, %24, %c512_158 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          %82 = arith.andi %81, %32 : i1
          %c0_159 = arith.constant 0 : index
          %83 = arith.cmpi sge, %16, %c0_159 : index
          %c256_160 = arith.constant 256 : index
          %84 = arith.cmpi slt, %16, %c256_160 : index
          %85 = arith.andi %83, %84 : i1
          %86 = arith.andi %82, %85 : i1
          %87 = scf.if %86 -> (i32) {
            %114 = memref.load %alloca_5[%24, %16] : memref<512x256xi32>
            scf.yield %114 : i32
          } else {
            %c0_i32_166 = arith.constant 0 : i32
            scf.yield %c0_i32_166 : i32
          }
          %88 = arith.andi %75, %86 : i1
          %89 = arith.muli %76, %87 : i32
          %90 = arith.andi %34, %88 : i1
          %91 = arith.addi %20, %89 : i32
          %92 = arith.andi %90, %true_88 : i1
          %93 = arith.andi %92, %28 : i1
          %c0_161 = arith.constant 0 : index
          %94 = arith.cmpi sge, %18, %c0_161 : index
          %c512_162 = arith.constant 512 : index
          %95 = arith.cmpi slt, %18, %c512_162 : index
          %96 = arith.andi %94, %95 : i1
          %97 = arith.andi %93, %96 : i1
          %98 = arith.andi %97, %32 : i1
          %c0_163 = arith.constant 0 : index
          %99 = arith.cmpi sge, %16, %c0_163 : index
          %c256_164 = arith.constant 256 : index
          %100 = arith.cmpi slt, %16, %c256_164 : index
          %101 = arith.andi %99, %100 : i1
          %102 = arith.andi %98, %101 : i1
          scf.if %102 {
            memref.store %91, %alloca_1[%18, %16] : memref<512x256xi32>
          }
          %c1_165 = arith.constant 1 : index
          %103 = arith.andi %30, %true_88 : i1
          %104 = arith.addi %24, %c1_165 : index
          %105 = arith.index_cast %104 : index to i64
          %106 = arith.select %32, %16, %arg12 : index
          %107 = arith.ori %32, %arg13 : i1
          %108 = arith.select %28, %18, %arg14 : index
          %109 = arith.ori %28, %arg15 : i1
          %110 = arith.select %90, %91, %arg16 : i32
          %111 = arith.ori %90, %arg17 : i1
          %112 = arith.select %103, %105, %arg18 : i64
          %113 = arith.ori %103, %arg19 : i1
          scf.yield %106, %107, %108, %109, %110, %111, %112, %113 : index, i1, index, i1, i32, i1, i64, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_6"}
    %c256_101 = arith.constant 256 : index
    %c0_102 = arith.constant 0 : index
    %c1_103 = arith.constant 1 : index
    %true_104 = arith.constant true
    %c0_105 = arith.constant 0 : index
    %dim_106 = memref.dim %arg5, %c0_105 : memref<?x256xi32>
    %c0_107 = arith.constant 0 : index
    %dim_108 = memref.dim %arg6, %c0_107 : memref<?x256xi32>
    %c0_109 = arith.constant 0 : index
    %c1_110 = arith.constant 1 : index
    %c0_111 = arith.constant 0 : index
    %c256_112 = arith.constant 256 : index
    %c1_113 = arith.constant 1 : index
    %c0_114 = arith.constant 0 : index
    %c256_115 = arith.constant 256 : index
    %c1_116 = arith.constant 1 : index
    %c0_i32_117 = arith.constant 0 : i32
    %false_118 = arith.constant false
    %c0_i32_119 = arith.constant 0 : i32
    %false_120 = arith.constant false
    scf.for %arg9 = %c0_109 to %c320 step %c1_110 {
      scf.for %arg10 = %c0_111 to %c256_112 step %c1_113 {
        %0:8 = scf.for %arg11 = %c0_114 to %c256_115 step %c1_116 iter_args(%arg12 = %c0_i32, %arg13 = %true_104, %arg14 = %c0_i32, %arg15 = %true_104, %arg16 = %c0_i32_117, %arg17 = %false_118, %arg18 = %c0_i32_119, %arg19 = %false_120) -> (i32, i1, i32, i1, i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_114 : index
          %2 = arith.andi %true_104, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %5 = arith.andi %true_104, %1 : i1
          %6 = arith.select %5, %c0_i32, %arg14 : i32
          %7 = arith.ori %5, %arg15 : i1
          %c0_137 = arith.constant 0 : index
          %8 = arith.cmpi eq, %arg11, %c0_137 : index
          %9 = arith.andi %true_104, %true_104 : i1
          %10 = arith.andi %9, %8 : i1
          %11 = arith.andi %true_104, %10 : i1
          %12 = arith.andi %9, %8 : i1
          %13 = arith.andi %true_104, %12 : i1
          %14 = arith.andi %9, %8 : i1
          %15 = arith.andi %true_104, %14 : i1
          %16 = arith.andi %9, %8 : i1
          %17 = arith.andi %true_104, %16 : i1
          %18 = arith.andi %9, %8 : i1
          %19 = arith.andi %true_104, %18 : i1
          %20 = arith.andi %9, %8 : i1
          %21 = arith.andi %7, %20 : i1
          %22 = arith.andi %9, %8 : i1
          %23 = arith.andi %4, %22 : i1
          %true_138 = arith.constant true
          %24 = arith.xori %8, %true_138 : i1
          %25 = arith.andi %9, %24 : i1
          %26 = arith.andi %true_104, %25 : i1
          %27 = arith.andi %9, %24 : i1
          %28 = arith.andi %true_104, %27 : i1
          %29 = arith.andi %9, %24 : i1
          %30 = arith.andi %true_104, %29 : i1
          %31 = arith.andi %9, %24 : i1
          %32 = arith.andi %7, %31 : i1
          %33 = arith.andi %9, %24 : i1
          %34 = arith.andi %4, %33 : i1
          %35 = arith.andi %true_104, %11 : i1
          %36 = arith.andi %35, %13 : i1
          %c0_139 = arith.constant 0 : index
          %37 = arith.cmpi sge, %arg9, %c0_139 : index
          %c512 = arith.constant 512 : index
          %38 = arith.cmpi slt, %arg9, %c512 : index
          %39 = arith.andi %37, %38 : i1
          %40 = arith.andi %36, %39 : i1
          %41 = arith.andi %40, %15 : i1
          %c0_140 = arith.constant 0 : index
          %42 = arith.cmpi sge, %arg10, %c0_140 : index
          %c256_141 = arith.constant 256 : index
          %43 = arith.cmpi slt, %arg10, %c256_141 : index
          %44 = arith.andi %42, %43 : i1
          %45 = arith.andi %41, %44 : i1
          scf.if %45 {
            memref.store %c0_i32, %alloca_0[%arg9, %arg10] : memref<512x256xi32>
          }
          %46 = arith.andi %true_104, %17 : i1
          %47 = arith.andi %46, %13 : i1
          %c0_142 = arith.constant 0 : index
          %48 = arith.cmpi sge, %arg9, %c0_142 : index
          %c512_143 = arith.constant 512 : index
          %49 = arith.cmpi slt, %arg9, %c512_143 : index
          %50 = arith.andi %48, %49 : i1
          %51 = arith.andi %47, %50 : i1
          %52 = arith.andi %51, %15 : i1
          %c0_144 = arith.constant 0 : index
          %53 = arith.cmpi sge, %arg10, %c0_144 : index
          %c256_145 = arith.constant 256 : index
          %54 = arith.cmpi slt, %arg10, %c256_145 : index
          %55 = arith.andi %53, %54 : i1
          %56 = arith.andi %52, %55 : i1
          scf.if %56 {
            memref.store %c0_i32, %alloca[%arg9, %arg10] : memref<512x256xi32>
          }
          %57 = arith.select %34, %3, %3 : i32
          %58 = arith.ori %34, %23 : i1
          %59 = arith.select %32, %6, %6 : i32
          %60 = arith.ori %32, %21 : i1
          %61 = arith.select %30, %arg10, %arg10 : index
          %62 = arith.ori %30, %15 : i1
          %63 = arith.select %28, %arg11, %arg11 : index
          %64 = arith.ori %28, %19 : i1
          %65 = arith.select %26, %arg9, %arg9 : index
          %66 = arith.ori %26, %13 : i1
          %67 = arith.andi %true_104, %66 : i1
          %c0_146 = arith.constant 0 : index
          %68 = arith.cmpi sge, %65, %c0_146 : index
          %c512_147 = arith.constant 512 : index
          %69 = arith.cmpi slt, %65, %c512_147 : index
          %70 = arith.andi %68, %69 : i1
          %71 = arith.andi %67, %70 : i1
          %72 = arith.andi %71, %64 : i1
          %c0_148 = arith.constant 0 : index
          %73 = arith.cmpi sge, %63, %c0_148 : index
          %c256_149 = arith.constant 256 : index
          %74 = arith.cmpi slt, %63, %c256_149 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = scf.if %76 -> (i32) {
            %143 = memref.load %alloca_1[%65, %63] : memref<512x256xi32>
            scf.yield %143 : i32
          } else {
            %c0_i32_165 = arith.constant 0 : i32
            scf.yield %c0_i32_165 : i32
          }
          %78 = arith.andi %true_104, %64 : i1
          %c0_150 = arith.constant 0 : index
          %79 = arith.cmpi sge, %63, %c0_150 : index
          %80 = arith.cmpi slt, %63, %dim_106 : index
          %81 = arith.andi %79, %80 : i1
          %82 = arith.andi %78, %81 : i1
          %83 = arith.andi %82, %62 : i1
          %c0_151 = arith.constant 0 : index
          %84 = arith.cmpi sge, %61, %c0_151 : index
          %c256_152 = arith.constant 256 : index
          %85 = arith.cmpi slt, %61, %c256_152 : index
          %86 = arith.andi %84, %85 : i1
          %87 = arith.andi %83, %86 : i1
          %88 = scf.if %87 -> (i32) {
            %143 = memref.load %arg5[%63, %61] : memref<?x256xi32>
            scf.yield %143 : i32
          } else {
            %c0_i32_165 = arith.constant 0 : i32
            scf.yield %c0_i32_165 : i32
          }
          %89 = arith.andi %76, %87 : i1
          %90 = arith.muli %77, %88 : i32
          %91 = arith.andi %60, %89 : i1
          %92 = arith.addi %59, %90 : i32
          %93 = arith.andi %91, %true_104 : i1
          %94 = arith.andi %93, %66 : i1
          %c0_153 = arith.constant 0 : index
          %95 = arith.cmpi sge, %65, %c0_153 : index
          %c512_154 = arith.constant 512 : index
          %96 = arith.cmpi slt, %65, %c512_154 : index
          %97 = arith.andi %95, %96 : i1
          %98 = arith.andi %94, %97 : i1
          %99 = arith.andi %98, %62 : i1
          %c0_155 = arith.constant 0 : index
          %100 = arith.cmpi sge, %61, %c0_155 : index
          %c256_156 = arith.constant 256 : index
          %101 = arith.cmpi slt, %61, %c256_156 : index
          %102 = arith.andi %100, %101 : i1
          %103 = arith.andi %99, %102 : i1
          scf.if %103 {
            memref.store %92, %alloca_0[%65, %61] : memref<512x256xi32>
          }
          %104 = arith.andi %true_104, %64 : i1
          %c0_157 = arith.constant 0 : index
          %105 = arith.cmpi sge, %63, %c0_157 : index
          %106 = arith.cmpi slt, %63, %dim_108 : index
          %107 = arith.andi %105, %106 : i1
          %108 = arith.andi %104, %107 : i1
          %109 = arith.andi %108, %62 : i1
          %c0_158 = arith.constant 0 : index
          %110 = arith.cmpi sge, %61, %c0_158 : index
          %c256_159 = arith.constant 256 : index
          %111 = arith.cmpi slt, %61, %c256_159 : index
          %112 = arith.andi %110, %111 : i1
          %113 = arith.andi %109, %112 : i1
          %114 = scf.if %113 -> (i32) {
            %143 = memref.load %arg6[%63, %61] : memref<?x256xi32>
            scf.yield %143 : i32
          } else {
            %c0_i32_165 = arith.constant 0 : i32
            scf.yield %c0_i32_165 : i32
          }
          %115 = arith.andi %76, %113 : i1
          %116 = arith.muli %77, %114 : i32
          %117 = arith.andi %58, %115 : i1
          %118 = arith.addi %57, %116 : i32
          %119 = arith.andi %117, %true_104 : i1
          %120 = arith.andi %119, %66 : i1
          %c0_160 = arith.constant 0 : index
          %121 = arith.cmpi sge, %65, %c0_160 : index
          %c512_161 = arith.constant 512 : index
          %122 = arith.cmpi slt, %65, %c512_161 : index
          %123 = arith.andi %121, %122 : i1
          %124 = arith.andi %120, %123 : i1
          %125 = arith.andi %124, %62 : i1
          %c0_162 = arith.constant 0 : index
          %126 = arith.cmpi sge, %61, %c0_162 : index
          %c256_163 = arith.constant 256 : index
          %127 = arith.cmpi slt, %61, %c256_163 : index
          %128 = arith.andi %126, %127 : i1
          %129 = arith.andi %125, %128 : i1
          scf.if %129 {
            memref.store %118, %alloca[%65, %61] : memref<512x256xi32>
          }
          %true_164 = arith.constant true
          %130 = arith.xori %true_104, %true_164 : i1
          %131 = arith.andi %true_104, %130 : i1
          %132 = arith.andi %4, %131 : i1
          %133 = arith.andi %true_104, %130 : i1
          %134 = arith.andi %7, %133 : i1
          %135 = arith.select %132, %3, %arg16 : i32
          %136 = arith.ori %132, %arg17 : i1
          %137 = arith.select %134, %6, %arg18 : i32
          %138 = arith.ori %134, %arg19 : i1
          %139 = arith.select %117, %118, %arg12 : i32
          %140 = arith.ori %117, %arg13 : i1
          %141 = arith.select %91, %92, %arg14 : i32
          %142 = arith.ori %91, %arg15 : i1
          scf.yield %139, %140, %141, %142, %135, %136, %137, %138 : i32, i1, i32, i1, i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_7"}
    %c256_121 = arith.constant 256 : index
    %c0_122 = arith.constant 0 : index
    %c1_123 = arith.constant 1 : index
    %true_124 = arith.constant true
    %c0_125 = arith.constant 0 : index
    %dim_126 = memref.dim %arg8, %c0_125 : memref<?x256xi32>
    %c0_127 = arith.constant 0 : index
    %dim_128 = memref.dim %arg7, %c0_127 : memref<?x256xi32>
    %c0_129 = arith.constant 0 : index
    %c1_130 = arith.constant 1 : index
    %c0_131 = arith.constant 0 : index
    %c256_132 = arith.constant 256 : index
    %c1_133 = arith.constant 1 : index
    %c0_134 = arith.constant 0 : index
    %c256_135 = arith.constant 256 : index
    %c1_136 = arith.constant 1 : index
    scf.for %arg9 = %c0_129 to %c320 step %c1_130 {
      scf.for %arg10 = %c0_131 to %c256_132 step %c1_133 {
        scf.for %arg11 = %c0_134 to %c256_135 step %c1_136 {
          %0 = arith.cmpi eq, %arg11, %c0_134 : index
          %c0_137 = arith.constant 0 : index
          %1 = arith.cmpi eq, %arg11, %c0_137 : index
          %2 = arith.andi %true_124, %true_124 : i1
          %3 = arith.andi %2, %1 : i1
          %4 = arith.andi %true_124, %3 : i1
          %5 = arith.andi %2, %1 : i1
          %6 = arith.andi %true_124, %5 : i1
          %7 = arith.andi %2, %1 : i1
          %8 = arith.andi %true_124, %7 : i1
          %9 = arith.andi %2, %1 : i1
          %10 = arith.andi %true_124, %9 : i1
          %true_138 = arith.constant true
          %11 = arith.xori %1, %true_138 : i1
          %12 = arith.andi %2, %11 : i1
          %13 = arith.andi %true_124, %12 : i1
          %14 = arith.andi %2, %11 : i1
          %15 = arith.andi %true_124, %14 : i1
          %16 = arith.andi %2, %11 : i1
          %17 = arith.andi %true_124, %16 : i1
          %18 = arith.andi %true_124, %4 : i1
          %19 = arith.andi %18, %6 : i1
          %c0_139 = arith.constant 0 : index
          %20 = arith.cmpi sge, %arg9, %c0_139 : index
          %21 = arith.cmpi slt, %arg9, %dim_126 : index
          %22 = arith.andi %20, %21 : i1
          %23 = arith.andi %19, %22 : i1
          %24 = arith.andi %23, %8 : i1
          %c0_140 = arith.constant 0 : index
          %25 = arith.cmpi sge, %arg10, %c0_140 : index
          %c256_141 = arith.constant 256 : index
          %26 = arith.cmpi slt, %arg10, %c256_141 : index
          %27 = arith.andi %25, %26 : i1
          %28 = arith.andi %24, %27 : i1
          scf.if %28 {
            memref.store %c0_i32, %arg8[%arg9, %arg10] : memref<?x256xi32>
          }
          %29 = arith.select %17, %arg10, %arg10 : index
          %30 = arith.ori %17, %8 : i1
          %31 = arith.select %15, %arg11, %arg11 : index
          %32 = arith.ori %15, %10 : i1
          %33 = arith.select %13, %arg9, %arg9 : index
          %34 = arith.ori %13, %6 : i1
          %35 = arith.andi %true_124, %34 : i1
          %c0_142 = arith.constant 0 : index
          %36 = arith.cmpi sge, %33, %c0_142 : index
          %c512 = arith.constant 512 : index
          %37 = arith.cmpi slt, %33, %c512 : index
          %38 = arith.andi %36, %37 : i1
          %39 = arith.andi %35, %38 : i1
          %40 = arith.andi %39, %32 : i1
          %c0_143 = arith.constant 0 : index
          %41 = arith.cmpi sge, %31, %c0_143 : index
          %c256_144 = arith.constant 256 : index
          %42 = arith.cmpi slt, %31, %c256_144 : index
          %43 = arith.andi %41, %42 : i1
          %44 = arith.andi %40, %43 : i1
          %45 = scf.if %44 -> (i32) {
            %100 = memref.load %alloca_0[%33, %31] : memref<512x256xi32>
            scf.yield %100 : i32
          } else {
            %c0_i32_158 = arith.constant 0 : i32
            scf.yield %c0_i32_158 : i32
          }
          %46 = arith.andi %44, %true_124 : i1
          %47 = arith.addi %45, %c1_i32 : i32
          %48 = arith.andi %44, %46 : i1
          %49 = arith.muli %45, %47 : i32
          %50 = arith.andi %true_124, %34 : i1
          %c0_145 = arith.constant 0 : index
          %51 = arith.cmpi sge, %33, %c0_145 : index
          %c512_146 = arith.constant 512 : index
          %52 = arith.cmpi slt, %33, %c512_146 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = arith.andi %54, %32 : i1
          %c0_147 = arith.constant 0 : index
          %56 = arith.cmpi sge, %31, %c0_147 : index
          %c256_148 = arith.constant 256 : index
          %57 = arith.cmpi slt, %31, %c256_148 : index
          %58 = arith.andi %56, %57 : i1
          %59 = arith.andi %55, %58 : i1
          %60 = scf.if %59 -> (i32) {
            %100 = memref.load %alloca[%33, %31] : memref<512x256xi32>
            scf.yield %100 : i32
          } else {
            %c0_i32_158 = arith.constant 0 : i32
            scf.yield %c0_i32_158 : i32
          }
          %61 = arith.andi %48, %59 : i1
          %62 = arith.muli %49, %60 : i32
          %63 = arith.andi %true_124, %32 : i1
          %c0_149 = arith.constant 0 : index
          %64 = arith.cmpi sge, %31, %c0_149 : index
          %65 = arith.cmpi slt, %31, %dim_128 : index
          %66 = arith.andi %64, %65 : i1
          %67 = arith.andi %63, %66 : i1
          %68 = arith.andi %67, %30 : i1
          %c0_150 = arith.constant 0 : index
          %69 = arith.cmpi sge, %29, %c0_150 : index
          %c256_151 = arith.constant 256 : index
          %70 = arith.cmpi slt, %29, %c256_151 : index
          %71 = arith.andi %69, %70 : i1
          %72 = arith.andi %68, %71 : i1
          %73 = scf.if %72 -> (i32) {
            %100 = memref.load %arg7[%31, %29] : memref<?x256xi32>
            scf.yield %100 : i32
          } else {
            %c0_i32_158 = arith.constant 0 : i32
            scf.yield %c0_i32_158 : i32
          }
          %74 = arith.andi %61, %72 : i1
          %75 = arith.muli %62, %73 : i32
          %76 = arith.andi %true_124, %34 : i1
          %c0_152 = arith.constant 0 : index
          %77 = arith.cmpi sge, %33, %c0_152 : index
          %78 = arith.cmpi slt, %33, %dim_126 : index
          %79 = arith.andi %77, %78 : i1
          %80 = arith.andi %76, %79 : i1
          %81 = arith.andi %80, %30 : i1
          %c0_153 = arith.constant 0 : index
          %82 = arith.cmpi sge, %29, %c0_153 : index
          %c256_154 = arith.constant 256 : index
          %83 = arith.cmpi slt, %29, %c256_154 : index
          %84 = arith.andi %82, %83 : i1
          %85 = arith.andi %81, %84 : i1
          %86 = scf.if %85 -> (i32) {
            %100 = memref.load %arg8[%33, %29] : memref<?x256xi32>
            scf.yield %100 : i32
          } else {
            %c0_i32_158 = arith.constant 0 : i32
            scf.yield %c0_i32_158 : i32
          }
          %87 = arith.andi %85, %74 : i1
          %88 = arith.addi %86, %75 : i32
          %89 = arith.andi %87, %true_124 : i1
          %90 = arith.andi %89, %34 : i1
          %c0_155 = arith.constant 0 : index
          %91 = arith.cmpi sge, %33, %c0_155 : index
          %92 = arith.cmpi slt, %33, %dim_126 : index
          %93 = arith.andi %91, %92 : i1
          %94 = arith.andi %90, %93 : i1
          %95 = arith.andi %94, %30 : i1
          %c0_156 = arith.constant 0 : index
          %96 = arith.cmpi sge, %29, %c0_156 : index
          %c256_157 = arith.constant 256 : index
          %97 = arith.cmpi slt, %29, %c256_157 : index
          %98 = arith.andi %96, %97 : i1
          %99 = arith.andi %95, %98 : i1
          scf.if %99 {
            memref.store %88, %arg8[%33, %29] : memref<?x256xi32>
          }
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_8"}
    return
  }
  func.func private @fill_llama_nonuniform(memref<?x256xi32>, i32) attributes {llvm.emit_c_interface}
  func.func private @check_llama_nonuniform(i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> i64 attributes {llvm.emit_c_interface}
  func.func @main() -> i64 {
    %c256 = arith.constant 256 : index
    %c512 = arith.constant 512 : index
    %c320_i32 = arith.constant 320 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c2_i32 = arith.constant 2 : i32
    %c3_i32 = arith.constant 3 : i32
    %c4_i32 = arith.constant 4 : i32
    %c5_i32 = arith.constant 5 : i32
    %c6_i32 = arith.constant 6 : i32
    %c7_i32 = arith.constant 7 : i32
    %alloc = memref.alloc(%c512) : memref<?x256xi32>
    %alloc_0 = memref.alloc(%c256) : memref<?x256xi32>
    %alloc_1 = memref.alloc(%c256) : memref<?x256xi32>
    %alloc_2 = memref.alloc(%c256) : memref<?x256xi32>
    %alloc_3 = memref.alloc(%c256) : memref<?x256xi32>
    %alloc_4 = memref.alloc(%c256) : memref<?x256xi32>
    %alloc_5 = memref.alloc(%c256) : memref<?x256xi32>
    %alloc_6 = memref.alloc(%c512) : memref<?x256xi32>
    call @fill_llama_nonuniform(%alloc, %c0_i32) : (memref<?x256xi32>, i32) -> ()
    call @fill_llama_nonuniform(%alloc_0, %c1_i32) : (memref<?x256xi32>, i32) -> ()
    call @fill_llama_nonuniform(%alloc_1, %c2_i32) : (memref<?x256xi32>, i32) -> ()
    call @fill_llama_nonuniform(%alloc_2, %c3_i32) : (memref<?x256xi32>, i32) -> ()
    call @fill_llama_nonuniform(%alloc_3, %c4_i32) : (memref<?x256xi32>, i32) -> ()
    call @fill_llama_nonuniform(%alloc_4, %c5_i32) : (memref<?x256xi32>, i32) -> ()
    call @fill_llama_nonuniform(%alloc_5, %c6_i32) : (memref<?x256xi32>, i32) -> ()
    call @fill_llama_nonuniform(%alloc_6, %c7_i32) : (memref<?x256xi32>, i32) -> ()
    call @_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i(%c320_i32, %alloc, %alloc_0, %alloc_1, %alloc_2, %alloc_3, %alloc_4, %alloc_5, %alloc_6) : (i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> ()
    %0 = call @check_llama_nonuniform(%c320_i32, %alloc, %alloc_0, %alloc_1, %alloc_2, %alloc_3, %alloc_4, %alloc_5, %alloc_6) : (i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> i64
    return %0 : i64
  }
}

