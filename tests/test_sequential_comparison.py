import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import neighborhood_replay as replay
import run_sequential_comparison as comparison
import summarize_sequential_comparison as summary


class SequentialComparisonTests(unittest.TestCase):
    def command(self, **overrides):
        values = dict(optimizer=Path("/opt/opt"), canonical=Path("/tmp/input.mlir"),
            output_dir=Path("/tmp/search"), function="kernel", stage="full-joint",
            architecture=Path("/tmp/arch"), protocol={}, checkpoint=Path("/tmp/checkpoint"),
            seed_manifest=None, previous_winner=None, parent_cost_file=None,
            model_cache=None, cost_cache=None, max_rounds=4, max_candidates=4096,
            beam_width=16, diversity_slots=4, resume=None, decision_flow="sequential")
        values.update(overrides)
        return replay.build_search_command(**values)

    def test_standalone_flow_rejects_inherited_stage_winners(self):
        for flag in ("seed_manifest", "previous_winner", "historical_native_winner"):
            with self.subTest(flag=flag), self.assertRaises(replay.ContractError):
                self.command(**{flag: Path("/tmp/prior")})
        with self.assertRaises(replay.ContractError):
            self.command(stage="shape-temporal-replica")

    def test_one_total_budget_in_each_split(self):
        for split in (25, 50, 75):
            command = self.command(graph_budget_percent=split)
            option = next(x for x in command if x.startswith("--search-joint-neighborhood="))
            self.assertIn("max-candidates=4096", option)
            self.assertIn(f"graph-budget-percent={split}", option)
            self.assertIn("decision-flow=sequential", option)
            self.assertEqual(option.count("max-candidates="), 1)

    def test_fission_shared_cap_and_prepared_source_for_both_flows(self):
        with tempfile.TemporaryDirectory() as temp:
            prepared = Path(temp) / 'prepared.mlir'
            prepared.write_text('module {}')
            protocol = {'search': {'max_fission_actions_per_task': 64}}
            for flow in ('joint', 'sequential'):
                command = self.command(stage='full-joint-fission', decision_flow=flow,
                    protocol=protocol, prepared_source_file=prepared, stage_initialization='independent')
                option = next(x for x in command if x.startswith('--search-joint-neighborhood='))
                self.assertIn('max-fission-actions-per-task=64', option)
                self.assertIn('prepared-source-file=' + str(prepared), option)
                self.assertIn('decision-flow=' + flow, option)
            with self.assertRaises(replay.ContractError):
                self.command(stage='full-joint-fission', protocol=protocol)

    def test_transfer_option_requires_sequential_and_has_single_total_cap(self):
        protocol = {'decision_flow_comparison': {'sequential_budget_policy': 'transfer-unused'}}
        command = self.command(protocol=protocol)
        option = next(x for x in command if x.startswith('--search-joint-neighborhood='))
        self.assertIn('sequential-budget-policy=transfer-unused', option)
        self.assertEqual(option.count('max-candidates=4096'), 1)
        with self.assertRaises(replay.ContractError):
            self.command(protocol=protocol, decision_flow='joint')

    def test_common_replay_cache_policy_forwarded_for_both_flows(self):
        protocol = {'decision_flow_comparison': {'runtime_replay_cache': False}}
        for flow in ('joint', 'sequential'):
            option = next(x for x in self.command(protocol=protocol, decision_flow=flow)
                          if x.startswith('--search-joint-neighborhood='))
            self.assertIn('runtime-replay-cache=false', option)
        protocol['decision_flow_comparison']['runtime_replay_cache'] = 'false'
        with self.assertRaises(replay.ContractError):
            self.command(protocol=protocol)

    def test_fission_protocol_retains_shared_ranges_and_primary_allocation(self):
        template = comparison.ROOT / 'reference/input0-neighborhood/protocol-2x2-direct-model-template.json'
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / 'template.json'
            value = comparison.read(template)
            value['search']['max_fission_actions_per_task'] = 64
            path.write_text(json.dumps(value))
            common = comparison.make_protocol(path, 4096, 8192, 4, 512, 'full-joint-fission')
            self.assertEqual(common['stages'][-1]['name'], 'full-joint-fission')
            self.assertEqual(common['search']['later_replica_factors'], value['search']['later_replica_factors'])
            self.assertEqual(common['decision_flow_comparison']['primary_graph_budget_percent'], 50)
            self.assertTrue(common['decision_flow_comparison']['graph_actions_include_fission'])

    def test_completed_cell_requires_all_numeric_trace_and_mapper_gates(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp)
            rows = [dict(status="native_replayed", numeric="pass",
                         mapper_equality="pass", independent_trace="pass") for _ in range(7)]
            value = {"top5": [{}] * 5, "controls": [{}] * 2,
                "native_top5": {"records": rows[:5]}, "native_controls": {"records": rows[5:]}}
            for field in ("numeric", "mapper_equality", "independent_trace"):
                rows[0][field] = "pending"
                (directory / "result.json").write_text(json.dumps(value))
                self.assertFalse(comparison.complete(directory))
                rows[0][field] = "pass"
            (directory / "result.json").write_text(json.dumps(value))
            self.assertTrue(comparison.complete(directory))

    def test_binding_detects_same_path_content_change(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "optimizer"
            path.write_bytes(b"first build")
            original = comparison.file_binding(path)
            path.write_bytes(b"other build")
            current = comparison.file_binding(path)
            self.assertEqual(original["path"], current["path"])
            self.assertNotEqual(original["sha256"], current["sha256"])
            binding = Path(temp) / "binding.json"
            comparison.write_exact(binding, original)
            with self.assertRaises(ValueError):
                comparison.write_exact(binding, current)

    def test_same_nonbinding_round_cap_and_fixed_quota(self):
        template = comparison.ROOT / "reference/input0-neighborhood/protocol-2x2-direct-model-template.json"
        common = comparison.make_protocol(template, 4096, 8192, 4)
        joint = comparison.method_protocol(common, "joint")
        seq = comparison.method_protocol(common, "sequential")
        self.assertEqual(joint["search"]["max_rounds"], 8192)
        self.assertEqual(seq["search"]["max_rounds"], 8192)
        self.assertEqual(joint["search"]["round_score_quota"], 512)
        self.assertEqual(seq["search"]["round_score_quota"], 512)
        self.assertFalse(common["decision_flow_comparison"]["rounds_are_search_budget"])
        for proto in (joint, seq):
            command = self.command(protocol=proto)
            option = next(x for x in command if x.startswith("--search-joint-neighborhood="))
            self.assertIn("round-score-quota=512", option)
        for key in ("beam_width", "diversity_min_slots", "max_unique_complete_candidates_scored"):
            self.assertEqual(joint["search"][key], seq["search"][key])

    def test_archived_catalogs_require_predictor_audit(self):
        with tempfile.TemporaryDirectory() as temp:
            cell = Path(temp)
            (cell / "search").mkdir()
            (cell / "search.stderr.log").write_text("")
            (cell / "raw-auxiliary-manifest.json").write_text(json.dumps({"files": [
                {"path": "search/costs-graph-catalogue-0.json", "sha256": "a", "size": 10}]}))
            with self.assertRaisesRegex(ValueError, "missing predictor"):
                summary.prediction_accounting(cell)

    def test_mapper_counts_require_complete_precall_audits(self):
        with tempfile.TemporaryDirectory() as temp:
            cell = Path(temp)
            result = {"top5": [], "controls": [], "native_top5": {"records": []}, "native_controls": {"records": []}}
            paths = []
            for rank in range(7):
                directory = "native-top5" if rank < 5 else "native-controls"
                block = "native_top5" if rank < 5 else "native_controls"
                selection = "top5" if rank < 5 else "controls"
                candidate = f"candidate-{rank}"
                result[selection].append({"rank": rank, "candidate_id": candidate, "shape_candidate_id": f"shape-{candidate}"})
                result[block]["records"].append({"rank": rank, "candidate_id": candidate,
                    "actual_mapper_calls": 1, "numeric_element_comparisons": 2})
                path = cell / directory / f"rank-{rank}" / "mapper-call-audit.json"
                path.parent.mkdir(parents=True)
                path.write_text(json.dumps([{"candidate_id": f"shape-{candidate}"}]))
                paths.append(path)
            self.assertEqual(summary.final_mapper_accounting(cell, result)["actual_task_mapper_calls"], 7)
            paths[-1].write_text("[]")
            with self.assertRaisesRegex(ValueError, "differs"):
                summary.final_mapper_accounting(cell, result)
            paths[-1].unlink()
            with self.assertRaisesRegex(ValueError, "coverage"):
                summary.final_mapper_accounting(cell, result)

    def test_primary_ratio_is_not_the_sensitivity_envelope(self):
        template = comparison.ROOT / "reference/input0-neighborhood/protocol-2x2-direct-model-template.json"
        protocol = comparison.make_protocol(template, 4096, 8192, 4)
        self.assertEqual(protocol["decision_flow_comparison"]["primary_graph_budget_percent"], 50)
        self.assertEqual(protocol["decision_flow_comparison"]["sensitivity_graph_budget_percent"], [25, 75])
        self.assertNotIn("historical_native_winners", protocol)


if __name__ == "__main__":
    unittest.main()

class SequentialValidationAuditTests(unittest.TestCase):
    def fixture(self):
        import copy
        records = [dict(rank=i, candidate_id=f'candidate-{i}', status='native_replayed',
                        numeric='pass', mapper_equality='pass', independent_trace='pass') for i in range(7)]
        records[5].update(candidate_id='canonical',control_role='identity')
        records[6].update(candidate_id='canonical',control_role='search_anchor')
        return dict(numeric='pass',top5=copy.deepcopy(records[:5]),controls=copy.deepcopy(records[5:]),
                    native_top5=dict(status='native_replayed',numeric='pass',records=records[:5]),
                    native_controls=dict(status='native_replayed',numeric='pass',records=records[5:]),
                    numeric_top5_command=dict(exit_code=0),numeric_controls_command=dict(exit_code=0))

    def test_shared_control_candidate_has_distinct_valid_roles(self):
        from sequential_validation_audit import require_complete_validation
        self.assertTrue(require_complete_validation(self.fixture()))

    def test_passing_rows_cannot_hide_failed_aggregate_command(self):
        from sequential_validation_audit import require_complete_validation
        for field in ('numeric_top5_command','numeric_controls_command'):
            value=self.fixture();value[field]['exit_code']=1
            with self.assertRaisesRegex(ValueError,'aggregate'):
                require_complete_validation(value)
        value=self.fixture();value['numeric']='incomplete'
        with self.assertRaisesRegex(ValueError,'aggregate'):
            require_complete_validation(value)

    def test_duplicate_ranks_or_control_roles_fail_closed(self):
        from sequential_validation_audit import require_complete_validation
        value=self.fixture();value['native_top5']['records'][0]['rank']=1
        with self.assertRaisesRegex(ValueError,'ranks'):
            require_complete_validation(value)
        value=self.fixture();value['controls'][0]['control_role']='search_anchor'
        with self.assertRaisesRegex(ValueError,'roles'):
            require_complete_validation(value)
