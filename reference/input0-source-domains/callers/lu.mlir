module attributes {amoeba.lu_affine_repair_input_status = "malformed-determinant-carry", amoeba.lu_affine_repair_pass = "repair-lu-affine-determinant-carry-v1", amoeba.lu_affine_repair_reason = "inserted determinant carry load and rewired product", amoeba.lu_affine_repair_source_file = "Evaluation/LU/lu_func.cpp", amoeba.lu_affine_repair_source_verified = true, amoeba.lu_affine_repair_status = "repaired"} {
  func.func @_Z7lu_funciPA100_KiPS_PA100_iS4_S4_PiS5_S4_S5_(%arg0: i32, %arg1: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>}, %arg2: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>}, %arg3: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>}, %arg4: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>}, %arg5: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>}, %arg6: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>}, %arg7: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>}, %arg8: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>}, %arg9: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1>}) attributes {amoeba.graph_variant_id = "identity", amoeba.static_bound.arg.0 = 8 : i64, joint_scheduling_actual_makespan = 6277 : i64, joint_scheduling_actual_trace = {candidate_id = "shape-1868209/schedule-951", communication_mode = "explicit", dependencies = [{consumer = "Task_2", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_0", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_2", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_0", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_3", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_2", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_3", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_1", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_3", consumer_index = 1 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_1", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_4", consumer_index = 2 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 256 : i64, producer = "Task_4", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 2 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_1", producer_index = 2 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_1", producer_index = 2 : i32, producer_segment = "done_writes"}, {consumer = "Task_7", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_6", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_7", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_7", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_6", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_8", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 1 : i32, producer_segment = "done_writes"}], routes = [{bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_2", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [0 : i32], links = [{col = 0 : i32, end_cycle = 866 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 66 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_0", ready_cycle = 866 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_3", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [2 : i32], links = [{col = 0 : i32, end_cycle = 1781 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 981 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_2", ready_cycle = 1781 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_4", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [5 : i32], links = [{col = 0 : i32, end_cycle = 2903 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 2103 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2903 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_6", destination_col = 1 : i32, destination_row = 1 : i32, edge_indices = [8 : i32], links = [{col = 1 : i32, end_cycle = 994 : i64, resource_kind = "local_channel", row = 1 : i32, start_cycle = 194 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_1", ready_cycle = 994 : i64, source_col = 1 : i32, source_row = 1 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_6", destination_col = 1 : i32, destination_row = 0 : i32, edge_indices = [9 : i32], links = [{col = 1 : i32, end_cycle = 2903 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 2103 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2903 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_5", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [6 : i32], links = [{col = 0 : i32, end_cycle = 3111 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 3103 : i64}], path_latency_cycles = 0 : i64, payload_bits = 256 : i64, producer = "Task_4", ready_cycle = 3111 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 8 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_5", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [7 : i32], links = [{end_cycle = 2904 : i64, link_index = 1 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}], path_latency_cycles = 1 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2904 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 801 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_7", destination_col = 2 : i32, destination_row = 1 : i32, edge_indices = [11 : i32], links = [{col = 2 : i32, end_cycle = 5758 : i64, resource_kind = "local_channel", row = 1 : i32, start_cycle = 4958 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_6", ready_cycle = 5758 : i64, source_col = 2 : i32, source_row = 1 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_7", destination_col = 2 : i32, destination_row = 1 : i32, edge_indices = [12 : i32], links = [{end_cycle = 2905 : i64, link_index = 2 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}, {end_cycle = 2905 : i64, link_index = 36 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}], path_latency_cycles = 2 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2905 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 802 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_8", destination_col = 0 : i32, destination_row = 2 : i32, edge_indices = [14 : i32], links = [{end_cycle = 2905 : i64, link_index = 24 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}, {end_cycle = 2905 : i64, link_index = 26 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}], path_latency_cycles = 2 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2905 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 802 : i64}], task_schedule = [{cgra_positions = [{col = 0 : i32, row = 0 : i32}], end_cycle = 66 : i64, start_cycle = 0 : i64, task = "Task_0"}, {cgra_positions = [{col = 1 : i32, row = 1 : i32}], end_cycle = 194 : i64, start_cycle = 0 : i64, task = "Task_1"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 0 : i32, row = 1 : i32}, {col = 0 : i32, row = 2 : i32}, {col = 0 : i32, row = 3 : i32}], end_cycle = 981 : i64, start_cycle = 866 : i64, task = "Task_2"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 1 : i32, row = 0 : i32}], end_cycle = 2103 : i64, start_cycle = 1781 : i64, task = "Task_3"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}], end_cycle = 3103 : i64, start_cycle = 2903 : i64, task = "Task_4"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}], end_cycle = 3168 : i64, start_cycle = 3111 : i64, task = "Task_5"}, {cgra_positions = [{col = 1 : i32, row = 0 : i32}, {col = 2 : i32, row = 0 : i32}, {col = 1 : i32, row = 1 : i32}, {col = 2 : i32, row = 1 : i32}], end_cycle = 4958 : i64, start_cycle = 2903 : i64, task = "Task_6"}, {cgra_positions = [{col = 2 : i32, row = 1 : i32}, {col = 3 : i32, row = 1 : i32}, {col = 2 : i32, row = 2 : i32}, {col = 3 : i32, row = 2 : i32}], end_cycle = 6277 : i64, start_cycle = 5758 : i64, task = "Task_7"}, {cgra_positions = [{col = 0 : i32, row = 2 : i32}, {col = 1 : i32, row = 2 : i32}], end_cycle = 2924 : i64, start_cycle = 2905 : i64, task = "Task_8"}]}, joint_scheduling_candidate_id = "shape-1868209/schedule-951", joint_scheduling_candidate_scope = "static-shape-cartesian-product", joint_scheduling_communication_trace = [{bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_2", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [0 : i32], links = [{col = 0 : i32, end_cycle = 866 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 66 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_0", ready_cycle = 866 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_3", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [2 : i32], links = [{col = 0 : i32, end_cycle = 1781 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 981 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_2", ready_cycle = 1781 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_4", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [5 : i32], links = [{col = 0 : i32, end_cycle = 2903 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 2103 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2903 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_6", destination_col = 1 : i32, destination_row = 1 : i32, edge_indices = [8 : i32], links = [{col = 1 : i32, end_cycle = 994 : i64, resource_kind = "local_channel", row = 1 : i32, start_cycle = 194 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_1", ready_cycle = 994 : i64, source_col = 1 : i32, source_row = 1 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_6", destination_col = 1 : i32, destination_row = 0 : i32, edge_indices = [9 : i32], links = [{col = 1 : i32, end_cycle = 2903 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 2103 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2903 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_5", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [6 : i32], links = [{col = 0 : i32, end_cycle = 3111 : i64, resource_kind = "local_channel", row = 0 : i32, start_cycle = 3103 : i64}], path_latency_cycles = 0 : i64, payload_bits = 256 : i64, producer = "Task_4", ready_cycle = 3111 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 8 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_5", destination_col = 0 : i32, destination_row = 0 : i32, edge_indices = [7 : i32], links = [{end_cycle = 2904 : i64, link_index = 1 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}], path_latency_cycles = 1 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2904 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 801 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_7", destination_col = 2 : i32, destination_row = 1 : i32, edge_indices = [11 : i32], links = [{col = 2 : i32, end_cycle = 5758 : i64, resource_kind = "local_channel", row = 1 : i32, start_cycle = 4958 : i64}], path_latency_cycles = 0 : i64, payload_bits = 25600 : i64, producer = "Task_6", ready_cycle = 5758 : i64, source_col = 2 : i32, source_row = 1 : i32, transfer_cycles = 800 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_7", destination_col = 2 : i32, destination_row = 1 : i32, edge_indices = [12 : i32], links = [{end_cycle = 2905 : i64, link_index = 2 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}, {end_cycle = 2905 : i64, link_index = 36 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}], path_latency_cycles = 2 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2905 : i64, source_col = 1 : i32, source_row = 0 : i32, transfer_cycles = 802 : i64}, {bottleneck_bandwidth_bits_per_cycle = 32 : i64, consumer = "Task_8", destination_col = 0 : i32, destination_row = 2 : i32, edge_indices = [14 : i32], links = [{end_cycle = 2905 : i64, link_index = 24 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}, {end_cycle = 2905 : i64, link_index = 26 : i32, resource_kind = "network_link", start_cycle = 2103 : i64}], path_latency_cycles = 2 : i64, payload_bits = 25600 : i64, producer = "Task_3", ready_cycle = 2905 : i64, source_col = 0 : i32, source_row = 0 : i32, transfer_cycles = 802 : i64}], joint_scheduling_dependency_trace = [{consumer = "Task_2", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_0", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_2", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_0", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_3", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_2", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_3", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_1", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_3", consumer_index = 1 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_1", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_4", consumer_index = 2 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 256 : i64, producer = "Task_4", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_5", consumer_index = 2 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_1", producer_index = 2 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_6", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_1", producer_index = 2 : i32, producer_segment = "done_writes"}, {consumer = "Task_7", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_6", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_7", consumer_index = 1 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 1 : i32, producer_segment = "done_writes"}, {consumer = "Task_7", consumer_index = 0 : i32, consumer_segment = "will_writes", kind = "waw", producer = "Task_6", producer_index = 0 : i32, producer_segment = "done_writes"}, {consumer = "Task_8", consumer_index = 0 : i32, consumer_segment = "will_reads", kind = "raw", payload_bits = 25600 : i64, producer = "Task_3", producer_index = 1 : i32, producer_segment = "done_writes"}], joint_scheduling_fixed_point_max_iterations = 64 : i64, joint_scheduling_graph_variant_id = "identity", joint_scheduling_mapper_cache_hits = 9 : i64, joint_scheduling_mapper_cache_misses = 0 : i64, joint_scheduling_mapper_replay_completed, joint_scheduling_prediction_mapper_equal = false, joint_scheduling_production_dispatch_order = ["Task_0", "Task_1", "Task_2", "Task_3", "Task_4", "Task_6", "Task_5", "Task_7", "Task_8"], joint_scheduling_production_dispatch_policy = "critical-path", joint_scheduling_production_schedule = [{cgra_positions = [{col = 0 : i32, row = 0 : i32}], end_cycle = 66 : i64, start_cycle = 0 : i64, task = "Task_0"}, {cgra_positions = [{col = 1 : i32, row = 1 : i32}], end_cycle = 194 : i64, start_cycle = 0 : i64, task = "Task_1"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 0 : i32, row = 1 : i32}, {col = 0 : i32, row = 2 : i32}, {col = 0 : i32, row = 3 : i32}], end_cycle = 981 : i64, start_cycle = 866 : i64, task = "Task_2"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}, {col = 1 : i32, row = 0 : i32}], end_cycle = 2103 : i64, start_cycle = 1781 : i64, task = "Task_3"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}], end_cycle = 3103 : i64, start_cycle = 2903 : i64, task = "Task_4"}, {cgra_positions = [{col = 0 : i32, row = 0 : i32}], end_cycle = 3168 : i64, start_cycle = 3111 : i64, task = "Task_5"}, {cgra_positions = [{col = 1 : i32, row = 0 : i32}, {col = 2 : i32, row = 0 : i32}, {col = 1 : i32, row = 1 : i32}, {col = 2 : i32, row = 1 : i32}], end_cycle = 4958 : i64, start_cycle = 2903 : i64, task = "Task_6"}, {cgra_positions = [{col = 2 : i32, row = 1 : i32}, {col = 3 : i32, row = 1 : i32}, {col = 2 : i32, row = 2 : i32}, {col = 3 : i32, row = 2 : i32}], end_cycle = 6277 : i64, start_cycle = 5758 : i64, task = "Task_7"}, {cgra_positions = [{col = 0 : i32, row = 2 : i32}, {col = 1 : i32, row = 2 : i32}], end_cycle = 2924 : i64, start_cycle = 2905 : i64, task = "Task_8"}], joint_scheduling_replay_verified, joint_scheduling_scheduler_backend = "orchestrate-tasks-on-accelerators", llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c7_i32 = arith.constant 7 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c1024_i32 = arith.constant 1024 : i32
    %c-1024_i32 = arith.constant -1024 : i32
    %c8 = arith.constant 8 : index
    %c0_0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %true = arith.constant true
    %c0_1 = arith.constant 0 : index
    %dim = memref.dim %arg1, %c0_1 : memref<?x100xi32>
    %c0_2 = arith.constant 0 : index
    %dim_3 = memref.dim %arg3, %c0_2 : memref<?x100xi32>
    %c0_4 = arith.constant 0 : index
    %c1_5 = arith.constant 1 : index
    %c0_6 = arith.constant 0 : index
    %c1_7 = arith.constant 1 : index
    scf.for %arg10 = %c0_4 to %c8 step %c1_5 {
      scf.for %arg11 = %c0_6 to %c8 step %c1_7 {
        %1 = arith.cmpi eq, %arg11, %c0_6 : index
        %2 = arith.andi %true, %true : i1
        %c0_130 = arith.constant 0 : index
        %3 = arith.cmpi sge, %arg10, %c0_130 : index
        %4 = arith.cmpi slt, %arg10, %dim : index
        %5 = arith.andi %3, %4 : i1
        %6 = arith.andi %2, %5 : i1
        %7 = arith.andi %6, %true : i1
        %c0_131 = arith.constant 0 : index
        %8 = arith.cmpi sge, %arg11, %c0_131 : index
        %c100 = arith.constant 100 : index
        %9 = arith.cmpi slt, %arg11, %c100 : index
        %10 = arith.andi %8, %9 : i1
        %11 = arith.andi %7, %10 : i1
        %12 = scf.if %11 -> (i32) {
          %24 = memref.load %arg1[%arg10, %arg11] : memref<?x100xi32>
          scf.yield %24 : i32
        } else {
          %c0_i32_135 = arith.constant 0 : i32
          scf.yield %c0_i32_135 : i32
        }
        %13 = arith.andi %11, %true : i1
        %14 = arith.andi %13, %true : i1
        %c0_132 = arith.constant 0 : index
        %15 = arith.cmpi sge, %arg10, %c0_132 : index
        %16 = arith.cmpi slt, %arg10, %dim_3 : index
        %17 = arith.andi %15, %16 : i1
        %18 = arith.andi %14, %17 : i1
        %19 = arith.andi %18, %true : i1
        %c0_133 = arith.constant 0 : index
        %20 = arith.cmpi sge, %arg11, %c0_133 : index
        %c100_134 = arith.constant 100 : index
        %21 = arith.cmpi slt, %arg11, %c100_134 : index
        %22 = arith.andi %20, %21 : i1
        %23 = arith.andi %19, %22 : i1
        scf.if %23 {
          memref.store %12, %arg3[%arg10, %arg11] : memref<?x100xi32>
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_0"}
    %c0_8 = arith.constant 0 : index
    %c1_9 = arith.constant 1 : index
    %true_10 = arith.constant true
    %c0_11 = arith.constant 0 : index
    %dim_12 = memref.dim %arg4, %c0_11 : memref<?x100xi32>
    %c0_13 = arith.constant 0 : index
    %dim_14 = memref.dim %arg5, %c0_13 : memref<?x100xi32>
    %c0_15 = arith.constant 0 : index
    %dim_16 = memref.dim %arg8, %c0_15 : memref<?x100xi32>
    %c0_17 = arith.constant 0 : index
    %c1_18 = arith.constant 1 : index
    %c0_19 = arith.constant 0 : index
    %c1_20 = arith.constant 1 : index
    scf.for %arg10 = %c0_17 to %c8 step %c1_18 {
      scf.for %arg11 = %c0_19 to %c8 step %c1_20 {
        %1 = arith.cmpi eq, %arg11, %c0_19 : index
        %2 = arith.index_cast %arg10 : index to i32
        %3 = arith.index_cast %arg11 : index to i32
        %4 = arith.cmpi eq, %2, %3 : i32
        %5 = arith.andi %true_10, %true_10 : i1
        %6 = arith.select %4, %c1024_i32, %c0_i32 : i32
        %7 = arith.select %4, %true_10, %true_10 : i1
        %8 = arith.andi %5, %7 : i1
        %9 = arith.andi %8, %true_10 : i1
        %10 = arith.andi %9, %true_10 : i1
        %c0_130 = arith.constant 0 : index
        %11 = arith.cmpi sge, %arg10, %c0_130 : index
        %12 = arith.cmpi slt, %arg10, %dim_12 : index
        %13 = arith.andi %11, %12 : i1
        %14 = arith.andi %10, %13 : i1
        %15 = arith.andi %14, %true_10 : i1
        %c0_131 = arith.constant 0 : index
        %16 = arith.cmpi sge, %arg11, %c0_131 : index
        %c100 = arith.constant 100 : index
        %17 = arith.cmpi slt, %arg11, %c100 : index
        %18 = arith.andi %16, %17 : i1
        %19 = arith.andi %15, %18 : i1
        scf.if %19 {
          memref.store %6, %arg4[%arg10, %arg11] : memref<?x100xi32>
        }
        %20 = arith.andi %true_10, %true_10 : i1
        %21 = arith.andi %20, %true_10 : i1
        %c0_132 = arith.constant 0 : index
        %22 = arith.cmpi sge, %arg10, %c0_132 : index
        %23 = arith.cmpi slt, %arg10, %dim_14 : index
        %24 = arith.andi %22, %23 : i1
        %25 = arith.andi %21, %24 : i1
        %26 = arith.andi %25, %true_10 : i1
        %c0_133 = arith.constant 0 : index
        %27 = arith.cmpi sge, %arg11, %c0_133 : index
        %c100_134 = arith.constant 100 : index
        %28 = arith.cmpi slt, %arg11, %c100_134 : index
        %29 = arith.andi %27, %28 : i1
        %30 = arith.andi %26, %29 : i1
        scf.if %30 {
          memref.store %c0_i32, %arg5[%arg10, %arg11] : memref<?x100xi32>
        }
        %31 = arith.andi %8, %true_10 : i1
        %32 = arith.andi %31, %true_10 : i1
        %c0_135 = arith.constant 0 : index
        %33 = arith.cmpi sge, %arg10, %c0_135 : index
        %34 = arith.cmpi slt, %arg10, %dim_16 : index
        %35 = arith.andi %33, %34 : i1
        %36 = arith.andi %32, %35 : i1
        %37 = arith.andi %36, %true_10 : i1
        %c0_136 = arith.constant 0 : index
        %38 = arith.cmpi sge, %arg11, %c0_136 : index
        %c100_137 = arith.constant 100 : index
        %39 = arith.cmpi slt, %arg11, %c100_137 : index
        %40 = arith.andi %38, %39 : i1
        %41 = arith.andi %37, %40 : i1
        scf.if %41 {
          memref.store %6, %arg8[%arg10, %arg11] : memref<?x100xi32>
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_1"}
    %c0_21 = arith.constant 0 : index
    %c1_22 = arith.constant 1 : index
    %true_23 = arith.constant true
    %c0_24 = arith.constant 0 : index
    %dim_25 = memref.dim %arg3, %c0_24 : memref<?x100xi32>
    %c0_26 = arith.constant 0 : index
    %c1_27 = arith.constant 1 : index
    %c0_28 = arith.constant 0 : index
    %false = arith.constant false
    %c0_i32_29 = arith.constant 0 : i32
    %false_30 = arith.constant false
    %c0_i64 = arith.constant 0 : i64
    %false_31 = arith.constant false
    %c0_i64_32 = arith.constant 0 : i64
    %false_33 = arith.constant false
    %c0_i64_34 = arith.constant 0 : i64
    %false_35 = arith.constant false
    %c0_36 = arith.constant 0 : index
    %false_37 = arith.constant false
    %c0_38 = arith.constant 0 : index
    %false_39 = arith.constant false
    %c0_i32_40 = arith.constant 0 : i32
    %false_41 = arith.constant false
    %c0_i32_42 = arith.constant 0 : i32
    %false_43 = arith.constant false
    %c0_i64_44 = arith.constant 0 : i64
    %false_45 = arith.constant false
    %0:20 = scf.for %arg10 = %c0_26 to %c8 step %c1_27 iter_args(%arg11 = %c0_28, %arg12 = %false, %arg13 = %c0_i32_29, %arg14 = %false_30, %arg15 = %c0_i64, %arg16 = %false_31, %arg17 = %c0_i64_32, %arg18 = %false_33, %arg19 = %c0_i64_34, %arg20 = %false_35, %arg21 = %c0_36, %arg22 = %false_37, %arg23 = %c0_38, %arg24 = %false_39, %arg25 = %c0_i32_40, %arg26 = %false_41, %arg27 = %c0_i32_42, %arg28 = %false_43, %arg29 = %c0_i64_44, %arg30 = %false_45) -> (index, i1, i32, i1, i64, i1, i64, i1, i64, i1, index, i1, index, i1, i32, i1, i32, i1, i64, i1) {
      %1 = arith.cmpi eq, %arg10, %c0_26 : index
      %c0_130 = arith.constant 0 : index
      %2 = arith.index_cast %c0_130 : index to i64
      %3 = arith.index_cast %arg10 : index to i32
      %4 = arith.select %arg12, %arg11, %arg10 : index
      %5 = arith.ori %arg12, %true_23 : i1
      %6 = arith.select %arg14, %arg13, %3 : i32
      %7 = arith.ori %arg14, %true_23 : i1
      %8 = arith.select %arg16, %arg15, %2 : i64
      %9 = arith.ori %arg16, %true_23 : i1
      %10 = arith.select %arg18, %arg17, %2 : i64
      %11 = arith.ori %arg18, %true_23 : i1
      %12 = arith.index_cast %10 : i64 to index
      %13 = arith.cmpi slt, %12, %c8 : index
      %14 = arith.andi %11, %true_23 : i1
      %15 = arith.andi %14, %13 : i1
      %16 = arith.andi %11, %15 : i1
      %17 = arith.andi %14, %13 : i1
      %18 = arith.andi %9, %17 : i1
      %19 = arith.andi %14, %13 : i1
      %20 = arith.andi %7, %19 : i1
      %21 = arith.andi %14, %13 : i1
      %22 = arith.andi %5, %21 : i1
      %23 = arith.index_cast %12 : index to i32
      %24 = arith.select %arg20, %arg19, %8 : i64
      %25 = arith.ori %arg20, %18 : i1
      %26 = arith.select %arg22, %arg21, %12 : index
      %27 = arith.ori %arg22, %16 : i1
      %28 = arith.select %arg24, %arg23, %4 : index
      %29 = arith.ori %arg24, %22 : i1
      %30 = arith.select %arg26, %arg25, %23 : i32
      %31 = arith.ori %arg26, %16 : i1
      %32 = arith.select %arg28, %arg27, %6 : i32
      %33 = arith.ori %arg28, %20 : i1
      %34 = arith.select %arg30, %arg29, %8 : i64
      %35 = arith.ori %arg30, %18 : i1
      %36 = arith.index_cast %34 : i64 to index
      %37 = arith.cmpi slt, %36, %c8 : index
      %38 = arith.andi %35, %true_23 : i1
      %39 = arith.andi %38, %37 : i1
      %40 = arith.andi %35, %39 : i1
      %41 = arith.andi %38, %37 : i1
      %42 = arith.andi %33, %41 : i1
      %43 = arith.andi %38, %37 : i1
      %44 = arith.andi %31, %43 : i1
      %45 = arith.andi %38, %37 : i1
      %46 = arith.andi %29, %45 : i1
      %47 = arith.andi %38, %37 : i1
      %48 = arith.andi %27, %47 : i1
      %49 = arith.andi %38, %37 : i1
      %50 = arith.andi %25, %49 : i1
      %true_131 = arith.constant true
      %51 = arith.xori %37, %true_131 : i1
      %52 = arith.andi %38, %51 : i1
      %53 = arith.andi %33, %52 : i1
      %54 = arith.andi %38, %51 : i1
      %55 = arith.andi %31, %54 : i1
      %56 = arith.andi %38, %51 : i1
      %57 = arith.andi %27, %56 : i1
      %58 = arith.andi %38, %51 : i1
      %59 = arith.andi %29, %58 : i1
      %60 = arith.andi %38, %51 : i1
      %61 = arith.andi %25, %60 : i1
      %62 = arith.cmpi sgt, %32, %30 : i32
      %63 = arith.andi %53, %55 : i1
      %64 = arith.extui %62 : i1 to i32
      %65 = arith.andi %true_23, %57 : i1
      %c0_132 = arith.constant 0 : index
      %66 = arith.cmpi sge, %26, %c0_132 : index
      %67 = arith.cmpi slt, %26, %dim_25 : index
      %68 = arith.andi %66, %67 : i1
      %69 = arith.andi %65, %68 : i1
      %70 = arith.andi %69, %57 : i1
      %c0_133 = arith.constant 0 : index
      %71 = arith.cmpi sge, %26, %c0_133 : index
      %c100 = arith.constant 100 : index
      %72 = arith.cmpi slt, %26, %c100 : index
      %73 = arith.andi %71, %72 : i1
      %74 = arith.andi %70, %73 : i1
      %75 = scf.if %74 -> (i32) {
        %199 = memref.load %arg3[%26, %26] : memref<?x100xi32>
        scf.yield %199 : i32
      } else {
        %c0_i32_156 = arith.constant 0 : i32
        scf.yield %c0_i32_156 : i32
      }
      %76 = arith.andi %74, %true_23 : i1
      %77 = arith.addi %75, %c-1024_i32 : i32
      %78 = arith.andi %63, %76 : i1
      %79 = arith.muli %64, %77 : i32
      %80 = arith.andi %78, %true_23 : i1
      %81 = arith.addi %79, %c1024_i32 : i32
      %82 = arith.andi %true_23, %59 : i1
      %c0_134 = arith.constant 0 : index
      %83 = arith.cmpi sge, %28, %c0_134 : index
      %84 = arith.cmpi slt, %28, %dim_25 : index
      %85 = arith.andi %83, %84 : i1
      %86 = arith.andi %82, %85 : i1
      %87 = arith.andi %86, %57 : i1
      %c0_135 = arith.constant 0 : index
      %88 = arith.cmpi sge, %26, %c0_135 : index
      %c100_136 = arith.constant 100 : index
      %89 = arith.cmpi slt, %26, %c100_136 : index
      %90 = arith.andi %88, %89 : i1
      %91 = arith.andi %87, %90 : i1
      %92 = scf.if %91 -> (i32) {
        %199 = memref.load %arg3[%28, %26] : memref<?x100xi32>
        scf.yield %199 : i32
      } else {
        %c0_i32_156 = arith.constant 0 : i32
        scf.yield %c0_i32_156 : i32
      }
      %93 = arith.andi %91, %true_23 : i1
      %94 = arith.muli %92, %c1024_i32 : i32
      %95 = arith.andi %93, %80 : i1
      %c0_i32_137 = arith.constant 0 : i32
      %96 = arith.cmpi ne, %81, %c0_i32_137 : i32
      %97 = arith.andi %95, %96 : i1
      %98 = scf.if %97 -> (i32) {
        %199 = arith.divsi %94, %81 : i32
        scf.yield %199 : i32
      } else {
        %c0_i32_156 = arith.constant 0 : i32
        scf.yield %c0_i32_156 : i32
      }
      %99 = arith.andi %97, %true_23 : i1
      %100 = arith.andi %99, %59 : i1
      %c0_138 = arith.constant 0 : index
      %101 = arith.cmpi sge, %28, %c0_138 : index
      %102 = arith.cmpi slt, %28, %dim_25 : index
      %103 = arith.andi %101, %102 : i1
      %104 = arith.andi %100, %103 : i1
      %105 = arith.andi %104, %57 : i1
      %c0_139 = arith.constant 0 : index
      %106 = arith.cmpi sge, %26, %c0_139 : index
      %c100_140 = arith.constant 100 : index
      %107 = arith.cmpi slt, %26, %c100_140 : index
      %108 = arith.andi %106, %107 : i1
      %109 = arith.andi %105, %108 : i1
      scf.if %109 {
        memref.store %98, %arg3[%28, %26] : memref<?x100xi32>
      }
      %c1_141 = arith.constant 1 : index
      %110 = arith.andi %57, %true_23 : i1
      %111 = arith.addi %26, %c1_141 : index
      %112 = arith.index_cast %111 : index to i64
      %113 = arith.index_cast %36 : index to i32
      %114 = arith.cmpi slt, %113, %32 : i32
      %115 = arith.andi %40, %42 : i1
      %116 = arith.extui %114 : i1 to i32
      %117 = arith.cmpi slt, %113, %30 : i32
      %118 = arith.andi %40, %44 : i1
      %119 = arith.extui %117 : i1 to i32
      %120 = arith.andi %115, %118 : i1
      %121 = arith.muli %116, %119 : i32
      %122 = arith.andi %true_23, %46 : i1
      %c0_142 = arith.constant 0 : index
      %123 = arith.cmpi sge, %28, %c0_142 : index
      %124 = arith.cmpi slt, %28, %dim_25 : index
      %125 = arith.andi %123, %124 : i1
      %126 = arith.andi %122, %125 : i1
      %127 = arith.andi %126, %48 : i1
      %c0_143 = arith.constant 0 : index
      %128 = arith.cmpi sge, %26, %c0_143 : index
      %c100_144 = arith.constant 100 : index
      %129 = arith.cmpi slt, %26, %c100_144 : index
      %130 = arith.andi %128, %129 : i1
      %131 = arith.andi %127, %130 : i1
      %132 = scf.if %131 -> (i32) {
        %199 = memref.load %arg3[%28, %26] : memref<?x100xi32>
        scf.yield %199 : i32
      } else {
        %c0_i32_156 = arith.constant 0 : i32
        scf.yield %c0_i32_156 : i32
      }
      %133 = arith.andi %true_23, %46 : i1
      %c0_145 = arith.constant 0 : index
      %134 = arith.cmpi sge, %28, %c0_145 : index
      %135 = arith.cmpi slt, %28, %dim_25 : index
      %136 = arith.andi %134, %135 : i1
      %137 = arith.andi %133, %136 : i1
      %138 = arith.andi %137, %40 : i1
      %c0_146 = arith.constant 0 : index
      %139 = arith.cmpi sge, %36, %c0_146 : index
      %c100_147 = arith.constant 100 : index
      %140 = arith.cmpi slt, %36, %c100_147 : index
      %141 = arith.andi %139, %140 : i1
      %142 = arith.andi %138, %141 : i1
      %143 = scf.if %142 -> (i32) {
        %199 = memref.load %arg3[%28, %36] : memref<?x100xi32>
        scf.yield %199 : i32
      } else {
        %c0_i32_156 = arith.constant 0 : i32
        scf.yield %c0_i32_156 : i32
      }
      %144 = arith.andi %true_23, %40 : i1
      %c0_148 = arith.constant 0 : index
      %145 = arith.cmpi sge, %36, %c0_148 : index
      %146 = arith.cmpi slt, %36, %dim_25 : index
      %147 = arith.andi %145, %146 : i1
      %148 = arith.andi %144, %147 : i1
      %149 = arith.andi %148, %48 : i1
      %c0_149 = arith.constant 0 : index
      %150 = arith.cmpi sge, %26, %c0_149 : index
      %c100_150 = arith.constant 100 : index
      %151 = arith.cmpi slt, %26, %c100_150 : index
      %152 = arith.andi %150, %151 : i1
      %153 = arith.andi %149, %152 : i1
      %154 = scf.if %153 -> (i32) {
        %199 = memref.load %arg3[%36, %26] : memref<?x100xi32>
        scf.yield %199 : i32
      } else {
        %c0_i32_156 = arith.constant 0 : i32
        scf.yield %c0_i32_156 : i32
      }
      %155 = arith.andi %142, %153 : i1
      %156 = arith.muli %143, %154 : i32
      %157 = arith.andi %155, %true_23 : i1
      %c0_i32_151 = arith.constant 0 : i32
      %158 = arith.cmpi ne, %c1024_i32, %c0_i32_151 : i32
      %159 = arith.andi %157, %158 : i1
      %160 = scf.if %159 -> (i32) {
        %199 = arith.divsi %156, %c1024_i32 : i32
        scf.yield %199 : i32
      } else {
        %c0_i32_156 = arith.constant 0 : i32
        scf.yield %c0_i32_156 : i32
      }
      %161 = arith.andi %120, %159 : i1
      %162 = arith.muli %121, %160 : i32
      %163 = arith.andi %131, %161 : i1
      %164 = arith.subi %132, %162 : i32
      %165 = arith.andi %163, %true_23 : i1
      %166 = arith.andi %165, %46 : i1
      %c0_152 = arith.constant 0 : index
      %167 = arith.cmpi sge, %28, %c0_152 : index
      %168 = arith.cmpi slt, %28, %dim_25 : index
      %169 = arith.andi %167, %168 : i1
      %170 = arith.andi %166, %169 : i1
      %171 = arith.andi %170, %48 : i1
      %c0_153 = arith.constant 0 : index
      %172 = arith.cmpi sge, %26, %c0_153 : index
      %c100_154 = arith.constant 100 : index
      %173 = arith.cmpi slt, %26, %c100_154 : index
      %174 = arith.andi %172, %173 : i1
      %175 = arith.andi %171, %174 : i1
      scf.if %175 {
        memref.store %164, %arg3[%28, %26] : memref<?x100xi32>
      }
      %c1_155 = arith.constant 1 : index
      %176 = arith.andi %40, %true_23 : i1
      %177 = arith.addi %36, %c1_155 : index
      %178 = arith.index_cast %177 : index to i64
      %179 = arith.select %59, %28, %arg11 : index
      %180 = arith.ori %59, %arg12 : i1
      %181 = arith.select %53, %32, %arg13 : i32
      %182 = arith.ori %53, %arg14 : i1
      %183 = arith.select %61, %24, %arg15 : i64
      %184 = arith.ori %61, %arg16 : i1
      %185 = arith.select %110, %112, %arg17 : i64
      %186 = arith.ori %110, %arg18 : i1
      %187 = arith.select %50, %24, %arg19 : i64
      %188 = arith.ori %50, %arg20 : i1
      %189 = arith.select %48, %26, %arg21 : index
      %190 = arith.ori %48, %arg22 : i1
      %191 = arith.select %46, %28, %arg23 : index
      %192 = arith.ori %46, %arg24 : i1
      %193 = arith.select %44, %30, %arg25 : i32
      %194 = arith.ori %44, %arg26 : i1
      %195 = arith.select %42, %32, %arg27 : i32
      %196 = arith.ori %42, %arg28 : i1
      %197 = arith.select %176, %178, %arg29 : i64
      %198 = arith.ori %176, %arg30 : i1
      scf.yield %179, %180, %181, %182, %183, %184, %185, %186, %187, %188, %189, %190, %191, %192, %193, %194, %195, %196, %197, %198 : index, i1, i32, i1, i64, i1, i64, i1, i64, i1, index, i1, index, i1, i32, i1, i32, i1, i64, i1
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_2"}
    %c0_46 = arith.constant 0 : index
    %c1_47 = arith.constant 1 : index
    %true_48 = arith.constant true
    %c0_49 = arith.constant 0 : index
    %dim_50 = memref.dim %arg3, %c0_49 : memref<?x100xi32>
    %c0_51 = arith.constant 0 : index
    %dim_52 = memref.dim %arg4, %c0_51 : memref<?x100xi32>
    %c0_53 = arith.constant 0 : index
    %dim_54 = memref.dim %arg5, %c0_53 : memref<?x100xi32>
    %c0_55 = arith.constant 0 : index
    %c1_56 = arith.constant 1 : index
    %c0_57 = arith.constant 0 : index
    %c1_58 = arith.constant 1 : index
    scf.for %arg10 = %c0_55 to %c8 step %c1_56 {
      scf.for %arg11 = %c0_57 to %c8 step %c1_58 {
        %1 = arith.cmpi eq, %arg11, %c0_57 : index
        %2 = arith.index_cast %arg10 : index to i32
        %3 = arith.index_cast %arg11 : index to i32
        %4 = arith.cmpi sgt, %2, %3 : i32
        %5 = arith.andi %true_48, %true_48 : i1
        %6 = arith.extui %4 : i1 to i32
        %7 = arith.cmpi eq, %2, %3 : i32
        %8 = arith.andi %true_48, %true_48 : i1
        %9 = arith.extui %7 : i1 to i32
        %10 = arith.andi %true_48, %5 : i1
        %11 = arith.subi %c1_i32, %6 : i32
        %12 = arith.andi %true_48, %true_48 : i1
        %c0_130 = arith.constant 0 : index
        %13 = arith.cmpi sge, %arg10, %c0_130 : index
        %14 = arith.cmpi slt, %arg10, %dim_50 : index
        %15 = arith.andi %13, %14 : i1
        %16 = arith.andi %12, %15 : i1
        %17 = arith.andi %16, %true_48 : i1
        %c0_131 = arith.constant 0 : index
        %18 = arith.cmpi sge, %arg11, %c0_131 : index
        %c100 = arith.constant 100 : index
        %19 = arith.cmpi slt, %arg11, %c100 : index
        %20 = arith.andi %18, %19 : i1
        %21 = arith.andi %17, %20 : i1
        %22 = scf.if %21 -> (i32) {
          %53 = memref.load %arg3[%arg10, %arg11] : memref<?x100xi32>
          scf.yield %53 : i32
        } else {
          %c0_i32_138 = arith.constant 0 : i32
          scf.yield %c0_i32_138 : i32
        }
        %23 = arith.andi %5, %21 : i1
        %24 = arith.muli %6, %22 : i32
        %25 = arith.andi %8, %true_48 : i1
        %26 = arith.muli %9, %c1024_i32 : i32
        %27 = arith.andi %23, %25 : i1
        %28 = arith.addi %24, %26 : i32
        %29 = arith.andi %27, %true_48 : i1
        %30 = arith.andi %29, %true_48 : i1
        %c0_132 = arith.constant 0 : index
        %31 = arith.cmpi sge, %arg10, %c0_132 : index
        %32 = arith.cmpi slt, %arg10, %dim_52 : index
        %33 = arith.andi %31, %32 : i1
        %34 = arith.andi %30, %33 : i1
        %35 = arith.andi %34, %true_48 : i1
        %c0_133 = arith.constant 0 : index
        %36 = arith.cmpi sge, %arg11, %c0_133 : index
        %c100_134 = arith.constant 100 : index
        %37 = arith.cmpi slt, %arg11, %c100_134 : index
        %38 = arith.andi %36, %37 : i1
        %39 = arith.andi %35, %38 : i1
        scf.if %39 {
          memref.store %28, %arg4[%arg10, %arg11] : memref<?x100xi32>
        }
        %40 = arith.andi %10, %21 : i1
        %41 = arith.muli %11, %22 : i32
        %42 = arith.andi %40, %true_48 : i1
        %43 = arith.andi %42, %true_48 : i1
        %c0_135 = arith.constant 0 : index
        %44 = arith.cmpi sge, %arg10, %c0_135 : index
        %45 = arith.cmpi slt, %arg10, %dim_54 : index
        %46 = arith.andi %44, %45 : i1
        %47 = arith.andi %43, %46 : i1
        %48 = arith.andi %47, %true_48 : i1
        %c0_136 = arith.constant 0 : index
        %49 = arith.cmpi sge, %arg11, %c0_136 : index
        %c100_137 = arith.constant 100 : index
        %50 = arith.cmpi slt, %arg11, %c100_137 : index
        %51 = arith.andi %49, %50 : i1
        %52 = arith.andi %48, %51 : i1
        scf.if %52 {
          memref.store %41, %arg5[%arg10, %arg11] : memref<?x100xi32>
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_3"}
    %c0_59 = arith.constant 0 : index
    %c1_60 = arith.constant 1 : index
    %true_61 = arith.constant true
    %c0_62 = arith.constant 0 : index
    %dim_63 = memref.dim %arg2, %c0_62 : memref<?xi32>
    %c0_64 = arith.constant 0 : index
    %dim_65 = memref.dim %arg6, %c0_64 : memref<?xi32>
    %c0_66 = arith.constant 0 : index
    %dim_67 = memref.dim %arg4, %c0_66 : memref<?x100xi32>
    %c0_68 = arith.constant 0 : index
    %c1_69 = arith.constant 1 : index
    %c0_70 = arith.constant 0 : index
    %c1_71 = arith.constant 1 : index
    scf.for %arg10 = %c0_68 to %c8 step %c1_69 {
      scf.for %arg11 = %c0_70 to %c8 step %c1_71 {
        %1 = arith.cmpi eq, %arg11, %c0_70 : index
        %2 = arith.index_cast %arg10 : index to i32
        %3 = arith.andi %true_61, %true_61 : i1
        %c0_130 = arith.constant 0 : index
        %4 = arith.cmpi sge, %arg10, %c0_130 : index
        %5 = arith.cmpi slt, %arg10, %dim_63 : index
        %6 = arith.andi %4, %5 : i1
        %7 = arith.andi %3, %6 : i1
        %8 = scf.if %7 -> (i32) {
          %81 = memref.load %arg2[%arg10] : memref<?xi32>
          scf.yield %81 : i32
        } else {
          %c0_i32_140 = arith.constant 0 : i32
          scf.yield %c0_i32_140 : i32
        }
        %c0_131 = arith.constant 0 : index
        %9 = arith.cmpi eq, %arg11, %c0_131 : index
        %10 = arith.andi %true_61, %true_61 : i1
        %11 = arith.andi %10, %9 : i1
        %12 = arith.andi %7, %11 : i1
        %13 = arith.andi %10, %9 : i1
        %14 = arith.andi %true_61, %13 : i1
        %15 = arith.andi %10, %9 : i1
        %16 = arith.andi %true_61, %15 : i1
        %17 = arith.andi %10, %9 : i1
        %18 = arith.andi %true_61, %17 : i1
        %true_132 = arith.constant true
        %19 = arith.xori %9, %true_132 : i1
        %20 = arith.andi %10, %19 : i1
        %21 = arith.andi %true_61, %20 : i1
        %22 = arith.andi %10, %19 : i1
        %23 = arith.andi %true_61, %22 : i1
        %24 = arith.andi %10, %19 : i1
        %25 = arith.andi %true_61, %24 : i1
        %26 = arith.andi %12, %true_61 : i1
        %27 = arith.andi %26, %14 : i1
        %c0_133 = arith.constant 0 : index
        %28 = arith.cmpi sge, %arg10, %c0_133 : index
        %29 = arith.cmpi slt, %arg10, %dim_65 : index
        %30 = arith.andi %28, %29 : i1
        %31 = arith.andi %27, %30 : i1
        scf.if %31 {
          memref.store %8, %arg6[%arg10] : memref<?xi32>
        }
        %32 = arith.select %25, %arg10, %arg10 : index
        %33 = arith.ori %25, %14 : i1
        %34 = arith.select %23, %2, %2 : i32
        %35 = arith.ori %23, %18 : i1
        %36 = arith.select %21, %arg11, %arg11 : index
        %37 = arith.ori %21, %16 : i1
        %38 = arith.index_cast %36 : index to i32
        %39 = arith.cmpi slt, %38, %34 : i32
        %40 = arith.andi %37, %35 : i1
        %41 = arith.extui %39 : i1 to i32
        %42 = arith.andi %true_61, %33 : i1
        %c0_134 = arith.constant 0 : index
        %43 = arith.cmpi sge, %32, %c0_134 : index
        %44 = arith.cmpi slt, %32, %dim_65 : index
        %45 = arith.andi %43, %44 : i1
        %46 = arith.andi %42, %45 : i1
        %47 = scf.if %46 -> (i32) {
          %81 = memref.load %arg6[%32] : memref<?xi32>
          scf.yield %81 : i32
        } else {
          %c0_i32_140 = arith.constant 0 : i32
          scf.yield %c0_i32_140 : i32
        }
        %48 = arith.andi %true_61, %33 : i1
        %c0_135 = arith.constant 0 : index
        %49 = arith.cmpi sge, %32, %c0_135 : index
        %50 = arith.cmpi slt, %32, %dim_67 : index
        %51 = arith.andi %49, %50 : i1
        %52 = arith.andi %48, %51 : i1
        %53 = arith.andi %52, %37 : i1
        %c0_136 = arith.constant 0 : index
        %54 = arith.cmpi sge, %36, %c0_136 : index
        %c100 = arith.constant 100 : index
        %55 = arith.cmpi slt, %36, %c100 : index
        %56 = arith.andi %54, %55 : i1
        %57 = arith.andi %53, %56 : i1
        %58 = scf.if %57 -> (i32) {
          %81 = memref.load %arg4[%32, %36] : memref<?x100xi32>
          scf.yield %81 : i32
        } else {
          %c0_i32_140 = arith.constant 0 : i32
          scf.yield %c0_i32_140 : i32
        }
        %59 = arith.andi %true_61, %37 : i1
        %c0_137 = arith.constant 0 : index
        %60 = arith.cmpi sge, %36, %c0_137 : index
        %61 = arith.cmpi slt, %36, %dim_65 : index
        %62 = arith.andi %60, %61 : i1
        %63 = arith.andi %59, %62 : i1
        %64 = scf.if %63 -> (i32) {
          %81 = memref.load %arg6[%36] : memref<?xi32>
          scf.yield %81 : i32
        } else {
          %c0_i32_140 = arith.constant 0 : i32
          scf.yield %c0_i32_140 : i32
        }
        %65 = arith.andi %57, %63 : i1
        %66 = arith.muli %58, %64 : i32
        %67 = arith.andi %65, %true_61 : i1
        %c0_i32_138 = arith.constant 0 : i32
        %68 = arith.cmpi ne, %c1024_i32, %c0_i32_138 : i32
        %69 = arith.andi %67, %68 : i1
        %70 = scf.if %69 -> (i32) {
          %81 = arith.divsi %66, %c1024_i32 : i32
          scf.yield %81 : i32
        } else {
          %c0_i32_140 = arith.constant 0 : i32
          scf.yield %c0_i32_140 : i32
        }
        %71 = arith.andi %40, %69 : i1
        %72 = arith.muli %41, %70 : i32
        %73 = arith.andi %46, %71 : i1
        %74 = arith.subi %47, %72 : i32
        %75 = arith.andi %73, %true_61 : i1
        %76 = arith.andi %75, %33 : i1
        %c0_139 = arith.constant 0 : index
        %77 = arith.cmpi sge, %32, %c0_139 : index
        %78 = arith.cmpi slt, %32, %dim_65 : index
        %79 = arith.andi %77, %78 : i1
        %80 = arith.andi %76, %79 : i1
        scf.if %80 {
          memref.store %74, %arg6[%32] : memref<?xi32>
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_4"}
    %c0_72 = arith.constant 0 : index
    %c1_73 = arith.constant 1 : index
    %true_74 = arith.constant true
    %c0_75 = arith.constant 0 : index
    %dim_76 = memref.dim %arg6, %c0_75 : memref<?xi32>
    %c0_77 = arith.constant 0 : index
    %dim_78 = memref.dim %arg7, %c0_77 : memref<?xi32>
    %c0_79 = arith.constant 0 : index
    %dim_80 = memref.dim %arg5, %c0_79 : memref<?x100xi32>
    %c0_81 = arith.constant 0 : index
    %c1_82 = arith.constant 1 : index
    %c0_83 = arith.constant 0 : index
    %false_84 = arith.constant false
    %c0_i32_85 = arith.constant 0 : i32
    %false_86 = arith.constant false
    %c0_i64_87 = arith.constant 0 : i64
    %false_88 = arith.constant false
    scf.for %arg10 = %c0_81 to %c8 step %c1_82 {
      %c1_130 = arith.constant 1 : index
      %1 = arith.addi %c8, %c1_130 : index
      %c0_131 = arith.constant 0 : index
      %2:6 = scf.for %arg11 = %c0_131 to %1 step %c1_130 iter_args(%arg12 = %c0_83, %arg13 = %false_84, %arg14 = %c0_i32_85, %arg15 = %false_86, %arg16 = %c0_i64_87, %arg17 = %false_88) -> (index, i1, i32, i1, i64, i1) {
        %3 = arith.cmpi eq, %arg11, %c0_131 : index
        %c0_132 = arith.constant 0 : index
        %4 = arith.index_cast %c0_132 : index to i64
        %5 = arith.index_cast %arg10 : index to i32
        %6 = arith.andi %true_74, %true_74 : i1
        %7 = arith.subi %c7_i32, %5 : i32
        %c-1 = arith.constant -1 : index
        %8 = arith.andi %true_74, %true_74 : i1
        %9 = arith.muli %arg10, %c-1 : index
        %10 = arith.andi %8, %true_74 : i1
        %11 = arith.addi %9, %c8 : index
        %c-1_133 = arith.constant -1 : index
        %12 = arith.andi %10, %true_74 : i1
        %13 = arith.addi %11, %c-1_133 : index
        %14 = arith.andi %true_74, %12 : i1
        %c0_134 = arith.constant 0 : index
        %15 = arith.cmpi sge, %13, %c0_134 : index
        %16 = arith.cmpi slt, %13, %dim_76 : index
        %17 = arith.andi %15, %16 : i1
        %18 = arith.andi %14, %17 : i1
        %19 = scf.if %18 -> (i32) {
          %173 = memref.load %arg6[%13] : memref<?xi32>
          scf.yield %173 : i32
        } else {
          %c0_i32_166 = arith.constant 0 : i32
          scf.yield %c0_i32_166 : i32
        }
        %c-1_135 = arith.constant -1 : index
        %20 = arith.andi %true_74, %true_74 : i1
        %21 = arith.muli %arg10, %c-1_135 : index
        %22 = arith.andi %20, %true_74 : i1
        %23 = arith.addi %21, %c8 : index
        %c-1_136 = arith.constant -1 : index
        %24 = arith.andi %22, %true_74 : i1
        %25 = arith.addi %23, %c-1_136 : index
        %26 = arith.andi %18, %true_74 : i1
        %27 = arith.andi %26, %24 : i1
        %c0_137 = arith.constant 0 : index
        %28 = arith.cmpi sge, %25, %c0_137 : index
        %29 = arith.cmpi slt, %25, %dim_78 : index
        %30 = arith.andi %28, %29 : i1
        %31 = arith.andi %27, %30 : i1
        scf.if %31 {
          memref.store %19, %arg7[%25] : memref<?xi32>
        }
        %32 = arith.select %arg13, %arg12, %arg10 : index
        %33 = arith.ori %arg13, %true_74 : i1
        %34 = arith.select %arg15, %arg14, %7 : i32
        %35 = arith.ori %arg15, %6 : i1
        %36 = arith.select %arg17, %arg16, %4 : i64
        %37 = arith.ori %arg17, %true_74 : i1
        %38 = arith.index_cast %36 : i64 to index
        %39 = arith.cmpi slt, %38, %c8 : index
        %40 = arith.andi %37, %true_74 : i1
        %41 = arith.andi %40, %39 : i1
        %42 = arith.andi %37, %41 : i1
        %43 = arith.andi %40, %39 : i1
        %44 = arith.andi %35, %43 : i1
        %45 = arith.andi %40, %39 : i1
        %46 = arith.andi %33, %45 : i1
        %true_138 = arith.constant true
        %47 = arith.xori %39, %true_138 : i1
        %48 = arith.andi %40, %47 : i1
        %49 = arith.andi %33, %48 : i1
        %c-1_139 = arith.constant -1 : index
        %50 = arith.andi %49, %true_74 : i1
        %51 = arith.muli %32, %c-1_139 : index
        %52 = arith.andi %50, %true_74 : i1
        %53 = arith.addi %51, %c8 : index
        %c-1_140 = arith.constant -1 : index
        %54 = arith.andi %52, %true_74 : i1
        %55 = arith.addi %53, %c-1_140 : index
        %56 = arith.andi %true_74, %54 : i1
        %c0_141 = arith.constant 0 : index
        %57 = arith.cmpi sge, %55, %c0_141 : index
        %58 = arith.cmpi slt, %55, %dim_78 : index
        %59 = arith.andi %57, %58 : i1
        %60 = arith.andi %56, %59 : i1
        %61 = scf.if %60 -> (i32) {
          %173 = memref.load %arg7[%55] : memref<?xi32>
          scf.yield %173 : i32
        } else {
          %c0_i32_166 = arith.constant 0 : i32
          scf.yield %c0_i32_166 : i32
        }
        %62 = arith.andi %60, %true_74 : i1
        %63 = arith.muli %61, %c1024_i32 : i32
        %c-1_142 = arith.constant -1 : index
        %64 = arith.andi %49, %true_74 : i1
        %65 = arith.muli %32, %c-1_142 : index
        %66 = arith.andi %64, %true_74 : i1
        %67 = arith.addi %65, %c8 : index
        %c-1_143 = arith.constant -1 : index
        %68 = arith.andi %66, %true_74 : i1
        %69 = arith.addi %67, %c-1_143 : index
        %c-1_144 = arith.constant -1 : index
        %70 = arith.andi %49, %true_74 : i1
        %71 = arith.muli %32, %c-1_144 : index
        %72 = arith.andi %70, %true_74 : i1
        %73 = arith.addi %71, %c8 : index
        %c-1_145 = arith.constant -1 : index
        %74 = arith.andi %72, %true_74 : i1
        %75 = arith.addi %73, %c-1_145 : index
        %76 = arith.andi %true_74, %68 : i1
        %c0_146 = arith.constant 0 : index
        %77 = arith.cmpi sge, %69, %c0_146 : index
        %78 = arith.cmpi slt, %69, %dim_80 : index
        %79 = arith.andi %77, %78 : i1
        %80 = arith.andi %76, %79 : i1
        %81 = arith.andi %80, %74 : i1
        %c0_147 = arith.constant 0 : index
        %82 = arith.cmpi sge, %75, %c0_147 : index
        %c100 = arith.constant 100 : index
        %83 = arith.cmpi slt, %75, %c100 : index
        %84 = arith.andi %82, %83 : i1
        %85 = arith.andi %81, %84 : i1
        %86 = scf.if %85 -> (i32) {
          %173 = memref.load %arg5[%69, %75] : memref<?x100xi32>
          scf.yield %173 : i32
        } else {
          %c0_i32_166 = arith.constant 0 : i32
          scf.yield %c0_i32_166 : i32
        }
        %87 = arith.andi %62, %85 : i1
        %c0_i32_148 = arith.constant 0 : i32
        %88 = arith.cmpi ne, %86, %c0_i32_148 : i32
        %89 = arith.andi %87, %88 : i1
        %90 = scf.if %89 -> (i32) {
          %173 = arith.divsi %63, %86 : i32
          scf.yield %173 : i32
        } else {
          %c0_i32_166 = arith.constant 0 : i32
          scf.yield %c0_i32_166 : i32
        }
        %c-1_149 = arith.constant -1 : index
        %91 = arith.andi %49, %true_74 : i1
        %92 = arith.muli %32, %c-1_149 : index
        %93 = arith.andi %91, %true_74 : i1
        %94 = arith.addi %92, %c8 : index
        %c-1_150 = arith.constant -1 : index
        %95 = arith.andi %93, %true_74 : i1
        %96 = arith.addi %94, %c-1_150 : index
        %97 = arith.andi %89, %true_74 : i1
        %98 = arith.andi %97, %95 : i1
        %c0_151 = arith.constant 0 : index
        %99 = arith.cmpi sge, %96, %c0_151 : index
        %100 = arith.cmpi slt, %96, %dim_78 : index
        %101 = arith.andi %99, %100 : i1
        %102 = arith.andi %98, %101 : i1
        scf.if %102 {
          memref.store %90, %arg7[%96] : memref<?xi32>
        }
        %103 = arith.index_cast %38 : index to i32
        %104 = arith.cmpi sgt, %103, %34 : i32
        %105 = arith.andi %42, %44 : i1
        %106 = arith.extui %104 : i1 to i32
        %c-1_152 = arith.constant -1 : index
        %107 = arith.andi %46, %true_74 : i1
        %108 = arith.muli %32, %c-1_152 : index
        %109 = arith.andi %107, %true_74 : i1
        %110 = arith.addi %108, %c8 : index
        %c-1_153 = arith.constant -1 : index
        %111 = arith.andi %109, %true_74 : i1
        %112 = arith.addi %110, %c-1_153 : index
        %113 = arith.andi %true_74, %111 : i1
        %c0_154 = arith.constant 0 : index
        %114 = arith.cmpi sge, %112, %c0_154 : index
        %115 = arith.cmpi slt, %112, %dim_78 : index
        %116 = arith.andi %114, %115 : i1
        %117 = arith.andi %113, %116 : i1
        %118 = scf.if %117 -> (i32) {
          %173 = memref.load %arg7[%112] : memref<?xi32>
          scf.yield %173 : i32
        } else {
          %c0_i32_166 = arith.constant 0 : i32
          scf.yield %c0_i32_166 : i32
        }
        %c-1_155 = arith.constant -1 : index
        %119 = arith.andi %46, %true_74 : i1
        %120 = arith.muli %32, %c-1_155 : index
        %121 = arith.andi %119, %true_74 : i1
        %122 = arith.addi %120, %c8 : index
        %c-1_156 = arith.constant -1 : index
        %123 = arith.andi %121, %true_74 : i1
        %124 = arith.addi %122, %c-1_156 : index
        %125 = arith.andi %true_74, %123 : i1
        %c0_157 = arith.constant 0 : index
        %126 = arith.cmpi sge, %124, %c0_157 : index
        %127 = arith.cmpi slt, %124, %dim_80 : index
        %128 = arith.andi %126, %127 : i1
        %129 = arith.andi %125, %128 : i1
        %130 = arith.andi %129, %42 : i1
        %c0_158 = arith.constant 0 : index
        %131 = arith.cmpi sge, %38, %c0_158 : index
        %c100_159 = arith.constant 100 : index
        %132 = arith.cmpi slt, %38, %c100_159 : index
        %133 = arith.andi %131, %132 : i1
        %134 = arith.andi %130, %133 : i1
        %135 = scf.if %134 -> (i32) {
          %173 = memref.load %arg5[%124, %38] : memref<?x100xi32>
          scf.yield %173 : i32
        } else {
          %c0_i32_166 = arith.constant 0 : i32
          scf.yield %c0_i32_166 : i32
        }
        %136 = arith.andi %true_74, %42 : i1
        %c0_160 = arith.constant 0 : index
        %137 = arith.cmpi sge, %38, %c0_160 : index
        %138 = arith.cmpi slt, %38, %dim_78 : index
        %139 = arith.andi %137, %138 : i1
        %140 = arith.andi %136, %139 : i1
        %141 = scf.if %140 -> (i32) {
          %173 = memref.load %arg7[%38] : memref<?xi32>
          scf.yield %173 : i32
        } else {
          %c0_i32_166 = arith.constant 0 : i32
          scf.yield %c0_i32_166 : i32
        }
        %142 = arith.andi %134, %140 : i1
        %143 = arith.muli %135, %141 : i32
        %144 = arith.andi %142, %true_74 : i1
        %c0_i32_161 = arith.constant 0 : i32
        %145 = arith.cmpi ne, %c1024_i32, %c0_i32_161 : i32
        %146 = arith.andi %144, %145 : i1
        %147 = scf.if %146 -> (i32) {
          %173 = arith.divsi %143, %c1024_i32 : i32
          scf.yield %173 : i32
        } else {
          %c0_i32_166 = arith.constant 0 : i32
          scf.yield %c0_i32_166 : i32
        }
        %148 = arith.andi %105, %146 : i1
        %149 = arith.muli %106, %147 : i32
        %150 = arith.andi %117, %148 : i1
        %151 = arith.subi %118, %149 : i32
        %c-1_162 = arith.constant -1 : index
        %152 = arith.andi %46, %true_74 : i1
        %153 = arith.muli %32, %c-1_162 : index
        %154 = arith.andi %152, %true_74 : i1
        %155 = arith.addi %153, %c8 : index
        %c-1_163 = arith.constant -1 : index
        %156 = arith.andi %154, %true_74 : i1
        %157 = arith.addi %155, %c-1_163 : index
        %158 = arith.andi %150, %true_74 : i1
        %159 = arith.andi %158, %156 : i1
        %c0_164 = arith.constant 0 : index
        %160 = arith.cmpi sge, %157, %c0_164 : index
        %161 = arith.cmpi slt, %157, %dim_78 : index
        %162 = arith.andi %160, %161 : i1
        %163 = arith.andi %159, %162 : i1
        scf.if %163 {
          memref.store %151, %arg7[%157] : memref<?xi32>
        }
        %c1_165 = arith.constant 1 : index
        %164 = arith.andi %42, %true_74 : i1
        %165 = arith.addi %38, %c1_165 : index
        %166 = arith.index_cast %165 : index to i64
        %167 = arith.select %46, %32, %arg12 : index
        %168 = arith.ori %46, %arg13 : i1
        %169 = arith.select %44, %34, %arg14 : i32
        %170 = arith.ori %44, %arg15 : i1
        %171 = arith.select %164, %166, %arg16 : i64
        %172 = arith.ori %164, %arg17 : i1
        scf.yield %167, %168, %169, %170, %171, %172 : index, i1, i32, i1, i64, i1
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_5"}
    %c0_89 = arith.constant 0 : index
    %c1_90 = arith.constant 1 : index
    %true_91 = arith.constant true
    %c0_92 = arith.constant 0 : index
    %dim_93 = memref.dim %arg8, %c0_92 : memref<?x100xi32>
    %c0_94 = arith.constant 0 : index
    %dim_95 = memref.dim %arg4, %c0_94 : memref<?x100xi32>
    %c0_96 = arith.constant 0 : index
    %c1_97 = arith.constant 1 : index
    %c0_98 = arith.constant 0 : index
    %c1_99 = arith.constant 1 : index
    %c0_100 = arith.constant 0 : index
    %c1_101 = arith.constant 1 : index
    scf.for %arg10 = %c0_96 to %c8 step %c1_97 {
      scf.for %arg11 = %c0_98 to %c8 step %c1_99 {
        scf.for %arg12 = %c0_100 to %c8 step %c1_101 {
          %1 = arith.cmpi eq, %arg12, %c0_100 : index
          %2 = arith.index_cast %arg10 : index to i32
          %3 = arith.index_cast %arg11 : index to i32
          %4 = arith.cmpi eq, %3, %2 : i32
          %5 = arith.andi %true_91, %true_91 : i1
          %6 = arith.select %4, %c1024_i32, %c0_i32 : i32
          %7 = arith.select %4, %true_91, %true_91 : i1
          %8 = arith.andi %5, %7 : i1
          %c0_130 = arith.constant 0 : index
          %9 = arith.cmpi eq, %arg12, %c0_130 : index
          %10 = arith.andi %true_91, %true_91 : i1
          %11 = arith.andi %10, %9 : i1
          %12 = arith.andi %8, %11 : i1
          %13 = arith.andi %10, %9 : i1
          %14 = arith.andi %true_91, %13 : i1
          %15 = arith.andi %10, %9 : i1
          %16 = arith.andi %true_91, %15 : i1
          %17 = arith.andi %10, %9 : i1
          %18 = arith.andi %true_91, %17 : i1
          %19 = arith.andi %10, %9 : i1
          %20 = arith.andi %true_91, %19 : i1
          %true_131 = arith.constant true
          %21 = arith.xori %9, %true_131 : i1
          %22 = arith.andi %10, %21 : i1
          %23 = arith.andi %true_91, %22 : i1
          %24 = arith.andi %10, %21 : i1
          %25 = arith.andi %true_91, %24 : i1
          %26 = arith.andi %10, %21 : i1
          %27 = arith.andi %true_91, %26 : i1
          %28 = arith.andi %10, %21 : i1
          %29 = arith.andi %true_91, %28 : i1
          %30 = arith.andi %12, %true_91 : i1
          %31 = arith.andi %30, %14 : i1
          %c0_132 = arith.constant 0 : index
          %32 = arith.cmpi sge, %arg11, %c0_132 : index
          %33 = arith.cmpi slt, %arg11, %dim_93 : index
          %34 = arith.andi %32, %33 : i1
          %35 = arith.andi %31, %34 : i1
          %36 = arith.andi %35, %16 : i1
          %c0_133 = arith.constant 0 : index
          %37 = arith.cmpi sge, %arg10, %c0_133 : index
          %c100 = arith.constant 100 : index
          %38 = arith.cmpi slt, %arg10, %c100 : index
          %39 = arith.andi %37, %38 : i1
          %40 = arith.andi %36, %39 : i1
          scf.if %40 {
            memref.store %6, %arg8[%arg11, %arg10] : memref<?x100xi32>
          }
          %41 = arith.select %29, %arg10, %arg10 : index
          %42 = arith.ori %29, %16 : i1
          %43 = arith.select %27, %arg11, %arg11 : index
          %44 = arith.ori %27, %14 : i1
          %45 = arith.select %25, %3, %3 : i32
          %46 = arith.ori %25, %20 : i1
          %47 = arith.select %23, %arg12, %arg12 : index
          %48 = arith.ori %23, %18 : i1
          %49 = arith.index_cast %47 : index to i32
          %50 = arith.cmpi slt, %49, %45 : i32
          %51 = arith.andi %48, %46 : i1
          %52 = arith.extui %50 : i1 to i32
          %53 = arith.andi %true_91, %44 : i1
          %c0_134 = arith.constant 0 : index
          %54 = arith.cmpi sge, %43, %c0_134 : index
          %55 = arith.cmpi slt, %43, %dim_93 : index
          %56 = arith.andi %54, %55 : i1
          %57 = arith.andi %53, %56 : i1
          %58 = arith.andi %57, %42 : i1
          %c0_135 = arith.constant 0 : index
          %59 = arith.cmpi sge, %41, %c0_135 : index
          %c100_136 = arith.constant 100 : index
          %60 = arith.cmpi slt, %41, %c100_136 : index
          %61 = arith.andi %59, %60 : i1
          %62 = arith.andi %58, %61 : i1
          %63 = scf.if %62 -> (i32) {
            %107 = memref.load %arg8[%43, %41] : memref<?x100xi32>
            scf.yield %107 : i32
          } else {
            %c0_i32_147 = arith.constant 0 : i32
            scf.yield %c0_i32_147 : i32
          }
          %64 = arith.andi %true_91, %44 : i1
          %c0_137 = arith.constant 0 : index
          %65 = arith.cmpi sge, %43, %c0_137 : index
          %66 = arith.cmpi slt, %43, %dim_95 : index
          %67 = arith.andi %65, %66 : i1
          %68 = arith.andi %64, %67 : i1
          %69 = arith.andi %68, %48 : i1
          %c0_138 = arith.constant 0 : index
          %70 = arith.cmpi sge, %47, %c0_138 : index
          %c100_139 = arith.constant 100 : index
          %71 = arith.cmpi slt, %47, %c100_139 : index
          %72 = arith.andi %70, %71 : i1
          %73 = arith.andi %69, %72 : i1
          %74 = scf.if %73 -> (i32) {
            %107 = memref.load %arg4[%43, %47] : memref<?x100xi32>
            scf.yield %107 : i32
          } else {
            %c0_i32_147 = arith.constant 0 : i32
            scf.yield %c0_i32_147 : i32
          }
          %75 = arith.andi %true_91, %48 : i1
          %c0_140 = arith.constant 0 : index
          %76 = arith.cmpi sge, %47, %c0_140 : index
          %77 = arith.cmpi slt, %47, %dim_93 : index
          %78 = arith.andi %76, %77 : i1
          %79 = arith.andi %75, %78 : i1
          %80 = arith.andi %79, %42 : i1
          %c0_141 = arith.constant 0 : index
          %81 = arith.cmpi sge, %41, %c0_141 : index
          %c100_142 = arith.constant 100 : index
          %82 = arith.cmpi slt, %41, %c100_142 : index
          %83 = arith.andi %81, %82 : i1
          %84 = arith.andi %80, %83 : i1
          %85 = scf.if %84 -> (i32) {
            %107 = memref.load %arg8[%47, %41] : memref<?x100xi32>
            scf.yield %107 : i32
          } else {
            %c0_i32_147 = arith.constant 0 : i32
            scf.yield %c0_i32_147 : i32
          }
          %86 = arith.andi %73, %84 : i1
          %87 = arith.muli %74, %85 : i32
          %88 = arith.andi %86, %true_91 : i1
          %c0_i32_143 = arith.constant 0 : i32
          %89 = arith.cmpi ne, %c1024_i32, %c0_i32_143 : i32
          %90 = arith.andi %88, %89 : i1
          %91 = scf.if %90 -> (i32) {
            %107 = arith.divsi %87, %c1024_i32 : i32
            scf.yield %107 : i32
          } else {
            %c0_i32_147 = arith.constant 0 : i32
            scf.yield %c0_i32_147 : i32
          }
          %92 = arith.andi %51, %90 : i1
          %93 = arith.muli %52, %91 : i32
          %94 = arith.andi %62, %92 : i1
          %95 = arith.subi %63, %93 : i32
          %96 = arith.andi %94, %true_91 : i1
          %97 = arith.andi %96, %44 : i1
          %c0_144 = arith.constant 0 : index
          %98 = arith.cmpi sge, %43, %c0_144 : index
          %99 = arith.cmpi slt, %43, %dim_93 : index
          %100 = arith.andi %98, %99 : i1
          %101 = arith.andi %97, %100 : i1
          %102 = arith.andi %101, %42 : i1
          %c0_145 = arith.constant 0 : index
          %103 = arith.cmpi sge, %41, %c0_145 : index
          %c100_146 = arith.constant 100 : index
          %104 = arith.cmpi slt, %41, %c100_146 : index
          %105 = arith.andi %103, %104 : i1
          %106 = arith.andi %102, %105 : i1
          scf.if %106 {
            memref.store %95, %arg8[%43, %41] : memref<?x100xi32>
          }
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_6"}
    %c0_102 = arith.constant 0 : index
    %c1_103 = arith.constant 1 : index
    %true_104 = arith.constant true
    %c0_105 = arith.constant 0 : index
    %dim_106 = memref.dim %arg8, %c0_105 : memref<?x100xi32>
    %c0_107 = arith.constant 0 : index
    %dim_108 = memref.dim %arg5, %c0_107 : memref<?x100xi32>
    %c0_109 = arith.constant 0 : index
    %c1_110 = arith.constant 1 : index
    %c0_111 = arith.constant 0 : index
    %c1_112 = arith.constant 1 : index
    %c0_113 = arith.constant 0 : index
    %false_114 = arith.constant false
    %c0_115 = arith.constant 0 : index
    %false_116 = arith.constant false
    %c0_i32_117 = arith.constant 0 : i32
    %false_118 = arith.constant false
    %c0_i64_119 = arith.constant 0 : i64
    %false_120 = arith.constant false
    scf.for %arg10 = %c0_109 to %c8 step %c1_110 {
      scf.for %arg11 = %c0_111 to %c8 step %c1_112 {
        %c1_130 = arith.constant 1 : index
        %1 = arith.addi %c8, %c1_130 : index
        %c0_131 = arith.constant 0 : index
        %2:8 = scf.for %arg12 = %c0_131 to %1 step %c1_130 iter_args(%arg13 = %c0_113, %arg14 = %false_114, %arg15 = %c0_115, %arg16 = %false_116, %arg17 = %c0_i32_117, %arg18 = %false_118, %arg19 = %c0_i64_119, %arg20 = %false_120) -> (index, i1, index, i1, i32, i1, i64, i1) {
          %3 = arith.cmpi eq, %arg12, %c0_131 : index
          %c0_132 = arith.constant 0 : index
          %4 = arith.index_cast %c0_132 : index to i64
          %5 = arith.index_cast %arg11 : index to i32
          %6 = arith.andi %true_104, %true_104 : i1
          %7 = arith.subi %c7_i32, %5 : i32
          %8 = arith.select %arg14, %arg13, %arg10 : index
          %9 = arith.ori %arg14, %true_104 : i1
          %10 = arith.select %arg16, %arg15, %arg11 : index
          %11 = arith.ori %arg16, %true_104 : i1
          %12 = arith.select %arg18, %arg17, %7 : i32
          %13 = arith.ori %arg18, %6 : i1
          %14 = arith.select %arg20, %arg19, %4 : i64
          %15 = arith.ori %arg20, %true_104 : i1
          %16 = arith.index_cast %14 : i64 to index
          %17 = arith.cmpi slt, %16, %c8 : index
          %18 = arith.andi %15, %true_104 : i1
          %19 = arith.andi %18, %17 : i1
          %20 = arith.andi %15, %19 : i1
          %21 = arith.andi %18, %17 : i1
          %22 = arith.andi %13, %21 : i1
          %23 = arith.andi %18, %17 : i1
          %24 = arith.andi %11, %23 : i1
          %25 = arith.andi %18, %17 : i1
          %26 = arith.andi %9, %25 : i1
          %true_133 = arith.constant true
          %27 = arith.xori %17, %true_133 : i1
          %28 = arith.andi %18, %27 : i1
          %29 = arith.andi %11, %28 : i1
          %30 = arith.andi %18, %27 : i1
          %31 = arith.andi %9, %30 : i1
          %c-1 = arith.constant -1 : index
          %32 = arith.andi %29, %true_104 : i1
          %33 = arith.muli %10, %c-1 : index
          %34 = arith.andi %32, %true_104 : i1
          %35 = arith.addi %33, %c8 : index
          %c-1_134 = arith.constant -1 : index
          %36 = arith.andi %34, %true_104 : i1
          %37 = arith.addi %35, %c-1_134 : index
          %38 = arith.andi %true_104, %36 : i1
          %c0_135 = arith.constant 0 : index
          %39 = arith.cmpi sge, %37, %c0_135 : index
          %40 = arith.cmpi slt, %37, %dim_106 : index
          %41 = arith.andi %39, %40 : i1
          %42 = arith.andi %38, %41 : i1
          %43 = arith.andi %42, %31 : i1
          %c0_136 = arith.constant 0 : index
          %44 = arith.cmpi sge, %8, %c0_136 : index
          %c100 = arith.constant 100 : index
          %45 = arith.cmpi slt, %8, %c100 : index
          %46 = arith.andi %44, %45 : i1
          %47 = arith.andi %43, %46 : i1
          %48 = scf.if %47 -> (i32) {
            %182 = memref.load %arg8[%37, %8] : memref<?x100xi32>
            scf.yield %182 : i32
          } else {
            %c0_i32_170 = arith.constant 0 : i32
            scf.yield %c0_i32_170 : i32
          }
          %49 = arith.andi %47, %true_104 : i1
          %50 = arith.muli %48, %c1024_i32 : i32
          %c-1_137 = arith.constant -1 : index
          %51 = arith.andi %29, %true_104 : i1
          %52 = arith.muli %10, %c-1_137 : index
          %53 = arith.andi %51, %true_104 : i1
          %54 = arith.addi %52, %c8 : index
          %c-1_138 = arith.constant -1 : index
          %55 = arith.andi %53, %true_104 : i1
          %56 = arith.addi %54, %c-1_138 : index
          %c-1_139 = arith.constant -1 : index
          %57 = arith.andi %29, %true_104 : i1
          %58 = arith.muli %10, %c-1_139 : index
          %59 = arith.andi %57, %true_104 : i1
          %60 = arith.addi %58, %c8 : index
          %c-1_140 = arith.constant -1 : index
          %61 = arith.andi %59, %true_104 : i1
          %62 = arith.addi %60, %c-1_140 : index
          %63 = arith.andi %true_104, %55 : i1
          %c0_141 = arith.constant 0 : index
          %64 = arith.cmpi sge, %56, %c0_141 : index
          %65 = arith.cmpi slt, %56, %dim_108 : index
          %66 = arith.andi %64, %65 : i1
          %67 = arith.andi %63, %66 : i1
          %68 = arith.andi %67, %61 : i1
          %c0_142 = arith.constant 0 : index
          %69 = arith.cmpi sge, %62, %c0_142 : index
          %c100_143 = arith.constant 100 : index
          %70 = arith.cmpi slt, %62, %c100_143 : index
          %71 = arith.andi %69, %70 : i1
          %72 = arith.andi %68, %71 : i1
          %73 = scf.if %72 -> (i32) {
            %182 = memref.load %arg5[%56, %62] : memref<?x100xi32>
            scf.yield %182 : i32
          } else {
            %c0_i32_170 = arith.constant 0 : i32
            scf.yield %c0_i32_170 : i32
          }
          %74 = arith.andi %49, %72 : i1
          %c0_i32_144 = arith.constant 0 : i32
          %75 = arith.cmpi ne, %73, %c0_i32_144 : i32
          %76 = arith.andi %74, %75 : i1
          %77 = scf.if %76 -> (i32) {
            %182 = arith.divsi %50, %73 : i32
            scf.yield %182 : i32
          } else {
            %c0_i32_170 = arith.constant 0 : i32
            scf.yield %c0_i32_170 : i32
          }
          %c-1_145 = arith.constant -1 : index
          %78 = arith.andi %29, %true_104 : i1
          %79 = arith.muli %10, %c-1_145 : index
          %80 = arith.andi %78, %true_104 : i1
          %81 = arith.addi %79, %c8 : index
          %c-1_146 = arith.constant -1 : index
          %82 = arith.andi %80, %true_104 : i1
          %83 = arith.addi %81, %c-1_146 : index
          %84 = arith.andi %76, %true_104 : i1
          %85 = arith.andi %84, %82 : i1
          %c0_147 = arith.constant 0 : index
          %86 = arith.cmpi sge, %83, %c0_147 : index
          %87 = arith.cmpi slt, %83, %dim_106 : index
          %88 = arith.andi %86, %87 : i1
          %89 = arith.andi %85, %88 : i1
          %90 = arith.andi %89, %31 : i1
          %c0_148 = arith.constant 0 : index
          %91 = arith.cmpi sge, %8, %c0_148 : index
          %c100_149 = arith.constant 100 : index
          %92 = arith.cmpi slt, %8, %c100_149 : index
          %93 = arith.andi %91, %92 : i1
          %94 = arith.andi %90, %93 : i1
          scf.if %94 {
            memref.store %77, %arg8[%83, %8] : memref<?x100xi32>
          }
          %95 = arith.index_cast %16 : index to i32
          %96 = arith.cmpi sgt, %95, %12 : i32
          %97 = arith.andi %20, %22 : i1
          %98 = arith.extui %96 : i1 to i32
          %c-1_150 = arith.constant -1 : index
          %99 = arith.andi %24, %true_104 : i1
          %100 = arith.muli %10, %c-1_150 : index
          %101 = arith.andi %99, %true_104 : i1
          %102 = arith.addi %100, %c8 : index
          %c-1_151 = arith.constant -1 : index
          %103 = arith.andi %101, %true_104 : i1
          %104 = arith.addi %102, %c-1_151 : index
          %105 = arith.andi %true_104, %103 : i1
          %c0_152 = arith.constant 0 : index
          %106 = arith.cmpi sge, %104, %c0_152 : index
          %107 = arith.cmpi slt, %104, %dim_106 : index
          %108 = arith.andi %106, %107 : i1
          %109 = arith.andi %105, %108 : i1
          %110 = arith.andi %109, %26 : i1
          %c0_153 = arith.constant 0 : index
          %111 = arith.cmpi sge, %8, %c0_153 : index
          %c100_154 = arith.constant 100 : index
          %112 = arith.cmpi slt, %8, %c100_154 : index
          %113 = arith.andi %111, %112 : i1
          %114 = arith.andi %110, %113 : i1
          %115 = scf.if %114 -> (i32) {
            %182 = memref.load %arg8[%104, %8] : memref<?x100xi32>
            scf.yield %182 : i32
          } else {
            %c0_i32_170 = arith.constant 0 : i32
            scf.yield %c0_i32_170 : i32
          }
          %c-1_155 = arith.constant -1 : index
          %116 = arith.andi %24, %true_104 : i1
          %117 = arith.muli %10, %c-1_155 : index
          %118 = arith.andi %116, %true_104 : i1
          %119 = arith.addi %117, %c8 : index
          %c-1_156 = arith.constant -1 : index
          %120 = arith.andi %118, %true_104 : i1
          %121 = arith.addi %119, %c-1_156 : index
          %122 = arith.andi %true_104, %120 : i1
          %c0_157 = arith.constant 0 : index
          %123 = arith.cmpi sge, %121, %c0_157 : index
          %124 = arith.cmpi slt, %121, %dim_108 : index
          %125 = arith.andi %123, %124 : i1
          %126 = arith.andi %122, %125 : i1
          %127 = arith.andi %126, %20 : i1
          %c0_158 = arith.constant 0 : index
          %128 = arith.cmpi sge, %16, %c0_158 : index
          %c100_159 = arith.constant 100 : index
          %129 = arith.cmpi slt, %16, %c100_159 : index
          %130 = arith.andi %128, %129 : i1
          %131 = arith.andi %127, %130 : i1
          %132 = scf.if %131 -> (i32) {
            %182 = memref.load %arg5[%121, %16] : memref<?x100xi32>
            scf.yield %182 : i32
          } else {
            %c0_i32_170 = arith.constant 0 : i32
            scf.yield %c0_i32_170 : i32
          }
          %133 = arith.andi %true_104, %20 : i1
          %c0_160 = arith.constant 0 : index
          %134 = arith.cmpi sge, %16, %c0_160 : index
          %135 = arith.cmpi slt, %16, %dim_106 : index
          %136 = arith.andi %134, %135 : i1
          %137 = arith.andi %133, %136 : i1
          %138 = arith.andi %137, %26 : i1
          %c0_161 = arith.constant 0 : index
          %139 = arith.cmpi sge, %8, %c0_161 : index
          %c100_162 = arith.constant 100 : index
          %140 = arith.cmpi slt, %8, %c100_162 : index
          %141 = arith.andi %139, %140 : i1
          %142 = arith.andi %138, %141 : i1
          %143 = scf.if %142 -> (i32) {
            %182 = memref.load %arg8[%16, %8] : memref<?x100xi32>
            scf.yield %182 : i32
          } else {
            %c0_i32_170 = arith.constant 0 : i32
            scf.yield %c0_i32_170 : i32
          }
          %144 = arith.andi %131, %142 : i1
          %145 = arith.muli %132, %143 : i32
          %146 = arith.andi %144, %true_104 : i1
          %c0_i32_163 = arith.constant 0 : i32
          %147 = arith.cmpi ne, %c1024_i32, %c0_i32_163 : i32
          %148 = arith.andi %146, %147 : i1
          %149 = scf.if %148 -> (i32) {
            %182 = arith.divsi %145, %c1024_i32 : i32
            scf.yield %182 : i32
          } else {
            %c0_i32_170 = arith.constant 0 : i32
            scf.yield %c0_i32_170 : i32
          }
          %150 = arith.andi %97, %148 : i1
          %151 = arith.muli %98, %149 : i32
          %152 = arith.andi %114, %150 : i1
          %153 = arith.subi %115, %151 : i32
          %c-1_164 = arith.constant -1 : index
          %154 = arith.andi %24, %true_104 : i1
          %155 = arith.muli %10, %c-1_164 : index
          %156 = arith.andi %154, %true_104 : i1
          %157 = arith.addi %155, %c8 : index
          %c-1_165 = arith.constant -1 : index
          %158 = arith.andi %156, %true_104 : i1
          %159 = arith.addi %157, %c-1_165 : index
          %160 = arith.andi %152, %true_104 : i1
          %161 = arith.andi %160, %158 : i1
          %c0_166 = arith.constant 0 : index
          %162 = arith.cmpi sge, %159, %c0_166 : index
          %163 = arith.cmpi slt, %159, %dim_106 : index
          %164 = arith.andi %162, %163 : i1
          %165 = arith.andi %161, %164 : i1
          %166 = arith.andi %165, %26 : i1
          %c0_167 = arith.constant 0 : index
          %167 = arith.cmpi sge, %8, %c0_167 : index
          %c100_168 = arith.constant 100 : index
          %168 = arith.cmpi slt, %8, %c100_168 : index
          %169 = arith.andi %167, %168 : i1
          %170 = arith.andi %166, %169 : i1
          scf.if %170 {
            memref.store %153, %arg8[%159, %8] : memref<?x100xi32>
          }
          %c1_169 = arith.constant 1 : index
          %171 = arith.andi %20, %true_104 : i1
          %172 = arith.addi %16, %c1_169 : index
          %173 = arith.index_cast %172 : index to i64
          %174 = arith.select %26, %8, %arg13 : index
          %175 = arith.ori %26, %arg14 : i1
          %176 = arith.select %24, %10, %arg15 : index
          %177 = arith.ori %24, %arg16 : i1
          %178 = arith.select %22, %12, %arg17 : i32
          %179 = arith.ori %22, %arg18 : i1
          %180 = arith.select %171, %173, %arg19 : i64
          %181 = arith.ori %171, %arg20 : i1
          scf.yield %174, %175, %176, %177, %178, %179, %180, %181 : index, i1, index, i1, i32, i1, i64, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_7"}
    memref.store %c1024_i32, %arg9[%c0] : memref<?xi32>
    %c0_121 = arith.constant 0 : index
    %c1_122 = arith.constant 1 : index
    %true_123 = arith.constant true
    %c0_124 = arith.constant 0 : index
    %dim_125 = memref.dim %arg5, %c0_124 : memref<?x100xi32>
    %c0_126 = arith.constant 0 : index
    %dim_127 = memref.dim %arg9, %c0_126 : memref<?xi32>
    %c0_128 = arith.constant 0 : index
    %c1_129 = arith.constant 1 : index
    scf.for %arg10 = %c0_128 to %c8 step %c1_129 {
      %1 = arith.cmpi eq, %arg10, %c0_128 : index
      %c0_130 = arith.constant 0 : index
      %2 = arith.andi %true_123, %true_123 : i1
      %c0_131 = arith.constant 0 : index
      %3 = arith.cmpi sge, %arg10, %c0_131 : index
      %4 = arith.cmpi slt, %arg10, %dim_125 : index
      %5 = arith.andi %3, %4 : i1
      %6 = arith.andi %2, %5 : i1
      %7 = arith.andi %6, %true_123 : i1
      %c0_132 = arith.constant 0 : index
      %8 = arith.cmpi sge, %arg10, %c0_132 : index
      %c100 = arith.constant 100 : index
      %9 = arith.cmpi slt, %arg10, %c100 : index
      %10 = arith.andi %8, %9 : i1
      %11 = arith.andi %7, %10 : i1
      %12 = scf.if %11 -> (i32) {
        %31 = memref.load %arg5[%arg10, %arg10] : memref<?x100xi32>
        scf.yield %31 : i32
      } else {
        %c0_i32_136 = arith.constant 0 : i32
        scf.yield %c0_i32_136 : i32
      }
      %13 = arith.andi %true_123, %true_123 : i1
      %c0_133 = arith.constant 0 : index
      %14 = arith.cmpi sge, %c0_130, %c0_133 : index
      %15 = arith.cmpi slt, %c0_130, %dim_127 : index
      %16 = arith.andi %14, %15 : i1
      %17 = arith.andi %13, %16 : i1
      %18 = scf.if %17 -> (i32) {
        %31 = memref.load %arg9[%c0_130] : memref<?xi32>
        scf.yield %31 : i32
      } else {
        %c0_i32_136 = arith.constant 0 : i32
        scf.yield %c0_i32_136 : i32
      }
      %19 = arith.andi %17, %11 : i1
      %20 = arith.muli %18, %12 : i32
      %21 = arith.andi %19, %true_123 : i1
      %c0_i32_134 = arith.constant 0 : i32
      %22 = arith.cmpi ne, %c1024_i32, %c0_i32_134 : i32
      %23 = arith.andi %21, %22 : i1
      %24 = scf.if %23 -> (i32) {
        %31 = arith.divsi %20, %c1024_i32 : i32
        scf.yield %31 : i32
      } else {
        %c0_i32_136 = arith.constant 0 : i32
        scf.yield %c0_i32_136 : i32
      }
      %25 = arith.andi %23, %true_123 : i1
      %26 = arith.andi %25, %true_123 : i1
      %c0_135 = arith.constant 0 : index
      %27 = arith.cmpi sge, %c0_130, %c0_135 : index
      %28 = arith.cmpi slt, %c0_130, %dim_127 : index
      %29 = arith.andi %27, %28 : i1
      %30 = arith.andi %26, %29 : i1
      scf.if %30 {
        memref.store %24, %arg9[%c0_130] : memref<?xi32>
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_8"}
    return
  }
  func.func private @orbit_numeric_initialize(i64, i64, memref<*xi32>) attributes {llvm.emit_c_interface}
  func.func private @orbit_numeric_snapshot(i64, i64) attributes {llvm.emit_c_interface}
  func.func private @orbit_numeric_check(i64) -> i64 attributes {llvm.emit_c_interface}
  func.func @main() -> i64 {
    %c4_i64 = arith.constant 4 : i64
    %c8_i32 = arith.constant 8 : i32
    %c8 = arith.constant 8 : index
    %alloc = memref.alloc(%c8) : memref<?x100xi32>
    %cast = memref.cast %alloc : memref<?x100xi32> to memref<*xi32>
    %c1_i64 = arith.constant 1 : i64
    call @orbit_numeric_initialize(%c4_i64, %c1_i64, %cast) : (i64, i64, memref<*xi32>) -> ()
    %c8_0 = arith.constant 8 : index
    %alloc_1 = memref.alloc(%c8_0) : memref<?xi32>
    %cast_2 = memref.cast %alloc_1 : memref<?xi32> to memref<*xi32>
    %c2_i64 = arith.constant 2 : i64
    call @orbit_numeric_initialize(%c4_i64, %c2_i64, %cast_2) : (i64, i64, memref<*xi32>) -> ()
    %c8_3 = arith.constant 8 : index
    %alloc_4 = memref.alloc(%c8_3) : memref<?x100xi32>
    %cast_5 = memref.cast %alloc_4 : memref<?x100xi32> to memref<*xi32>
    %c3_i64 = arith.constant 3 : i64
    call @orbit_numeric_initialize(%c4_i64, %c3_i64, %cast_5) : (i64, i64, memref<*xi32>) -> ()
    %c8_6 = arith.constant 8 : index
    %alloc_7 = memref.alloc(%c8_6) : memref<?x100xi32>
    %cast_8 = memref.cast %alloc_7 : memref<?x100xi32> to memref<*xi32>
    %c4_i64_9 = arith.constant 4 : i64
    call @orbit_numeric_initialize(%c4_i64, %c4_i64_9, %cast_8) : (i64, i64, memref<*xi32>) -> ()
    %c8_10 = arith.constant 8 : index
    %alloc_11 = memref.alloc(%c8_10) : memref<?x100xi32>
    %cast_12 = memref.cast %alloc_11 : memref<?x100xi32> to memref<*xi32>
    %c5_i64 = arith.constant 5 : i64
    call @orbit_numeric_initialize(%c4_i64, %c5_i64, %cast_12) : (i64, i64, memref<*xi32>) -> ()
    %c8_13 = arith.constant 8 : index
    %alloc_14 = memref.alloc(%c8_13) : memref<?xi32>
    %cast_15 = memref.cast %alloc_14 : memref<?xi32> to memref<*xi32>
    %c6_i64 = arith.constant 6 : i64
    call @orbit_numeric_initialize(%c4_i64, %c6_i64, %cast_15) : (i64, i64, memref<*xi32>) -> ()
    %c8_16 = arith.constant 8 : index
    %alloc_17 = memref.alloc(%c8_16) : memref<?xi32>
    %cast_18 = memref.cast %alloc_17 : memref<?xi32> to memref<*xi32>
    %c7_i64 = arith.constant 7 : i64
    call @orbit_numeric_initialize(%c4_i64, %c7_i64, %cast_18) : (i64, i64, memref<*xi32>) -> ()
    %c8_19 = arith.constant 8 : index
    %alloc_20 = memref.alloc(%c8_19) : memref<?x100xi32>
    %cast_21 = memref.cast %alloc_20 : memref<?x100xi32> to memref<*xi32>
    %c8_i64 = arith.constant 8 : i64
    call @orbit_numeric_initialize(%c4_i64, %c8_i64, %cast_21) : (i64, i64, memref<*xi32>) -> ()
    %c1 = arith.constant 1 : index
    %alloc_22 = memref.alloc(%c1) : memref<?xi32>
    %cast_23 = memref.cast %alloc_22 : memref<?xi32> to memref<*xi32>
    %c9_i64 = arith.constant 9 : i64
    call @orbit_numeric_initialize(%c4_i64, %c9_i64, %cast_23) : (i64, i64, memref<*xi32>) -> ()
    %0 = arith.extsi %c8_i32 : i32 to i64
    call @orbit_numeric_snapshot(%c4_i64, %0) : (i64, i64) -> ()
    call @_Z7lu_funciPA100_KiPS_PA100_iS4_S4_PiS5_S4_S5_(%c8_i32, %alloc, %alloc_1, %alloc_4, %alloc_7, %alloc_11, %alloc_14, %alloc_17, %alloc_20, %alloc_22) : (i32, memref<?x100xi32>, memref<?xi32>, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>) -> ()
    %1 = call @orbit_numeric_check(%c4_i64) : (i64) -> i64
    memref.dealloc %alloc : memref<?x100xi32>
    memref.dealloc %alloc_1 : memref<?xi32>
    memref.dealloc %alloc_4 : memref<?x100xi32>
    memref.dealloc %alloc_7 : memref<?x100xi32>
    memref.dealloc %alloc_11 : memref<?x100xi32>
    memref.dealloc %alloc_14 : memref<?xi32>
    memref.dealloc %alloc_17 : memref<?xi32>
    memref.dealloc %alloc_20 : memref<?x100xi32>
    memref.dealloc %alloc_22 : memref<?xi32>
    return %1 : i64
  }
}

