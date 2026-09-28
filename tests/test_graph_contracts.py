from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from modules.graph_contracts import validate_edge_payload, validate_schedule_trace


class GraphContractTests(unittest.TestCase):
    def edge(self, **changes):
        row = {"source": "canonical_TaskEdgeGraph", "kind": "data", "scope": "tile_local",
               "payload_bits": 128, "transferred_region": [0, 2, 0, 2],
               "producer_region": [0, 2, 0, 2], "region_elements": 4,
               "tensor_elements": 64, "bits_per_element": 32}
        row.update(changes); return row

    def test_tile_local_and_tensor_wide_payload(self):
        self.assertTrue(validate_edge_payload(self.edge()))
        with self.assertRaisesRegex(ValueError, "corresponding region"):
            validate_edge_payload(self.edge(transferred_region=[0, 8, 0, 8]))
        self.assertTrue(validate_edge_payload(self.edge(scope="tensor_wide", payload_bits=2048)))
        with self.assertRaisesRegex(ValueError, "whole-result"):
            validate_edge_payload(self.edge(scope="tensor_wide"))

    def test_halo_duplicate_traffic_and_alias_fallback(self):
        self.assertTrue(validate_edge_payload(self.edge(scope="halo", payload_bits=256)))
        with self.assertRaisesRegex(ValueError, "tensor-wide fallback"):
            validate_edge_payload(self.edge(unknown_access=True))
        self.assertTrue(validate_edge_payload(self.edge(unknown_access=True, scope="tensor_wide", payload_bits=2048)))

    def test_completion_is_sync_only(self):
        self.assertTrue(validate_edge_payload(self.edge(kind="completion", payload_bits=0)))
        with self.assertRaisesRegex(ValueError, "synchronization only"):
            validate_edge_payload(self.edge(kind="completion", payload_bits=32))

    def test_dynamic_ready_set_choice(self):
        trace = {"policy": "beam", "beam_width": 2, "makespan": 3,
                 "steps": [
                     {"ready_set": ["A", "B"], "chosen_activity": "B", "placement": [0],
                      "incoming_routes": [], "communication_ready_time": 0, "start": 0, "end": 1,
                      "resource_occupancy": [0]},
                     {"ready_set": ["A"], "chosen_activity": "A", "placement": [0],
                      "incoming_routes": [], "communication_ready_time": 1, "start": 1, "end": 3,
                      "resource_occupancy": [0]}]}
        self.assertTrue(validate_schedule_trace(trace))
        trace["steps"][0]["chosen_activity"] = "A"
        trace["steps"][1]["ready_set"] = ["B"]
        trace["steps"][1]["chosen_activity"] = "B"
        with self.assertRaisesRegex(ValueError, "dynamic ready-set"):
            validate_schedule_trace(trace)

    def test_exact_scope_and_routes_required(self):
        trace = {"policy": "exact", "makespan": 9,
                 "steps": [{"ready_set": [str(i)], "chosen_activity": str(i), "placement": [0],
                            "incoming_routes": [], "communication_ready_time": i,
                            "start": i, "end": i + 1, "resource_occupancy": [0]}
                           for i in range(9)]}
        with self.assertRaisesRegex(ValueError, "small graphs"):
            validate_schedule_trace(trace)
