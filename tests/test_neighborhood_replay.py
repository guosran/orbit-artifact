#!/usr/bin/env python3
import importlib.util
import json
import os
from pathlib import Path
import tempfile
import unittest
import sys
from unittest.mock import patch
from types import SimpleNamespace


HERE = Path(__file__).resolve().parents[1] / "scripts"
sys.path.insert(0, str(HERE))


def load(name, filename):
    spec = importlib.util.spec_from_file_location(name, HERE / filename)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


replay = load("neighborhood_replay", "neighborhood_replay.py")
table = load("render_neighborhood_table", "render_neighborhood_table.py")


def row(rank, candidate=None, record_type="selection", role=None):
    candidate = candidate or f"candidate-{rank}"
    value = {
        "record_type": record_type,
        "rank": rank,
        "candidate_id": candidate,
        "graph_variant_id": "identity",
        "mapper_replay_path": "/tmp/prepared.mlir",
        "score_file_path": "/tmp/scores.jsonl",
        "shape_manifest_file": "/tmp/shapes.jsonl",
        "shape_candidate_id": f"shape-{rank}",
        "predicted_whole_program_cycles": 100 + rank,
        "certified": True,
        "score_record": {"predicted_whole_program_cycles": 100 + rank},
    }
    if role:
        value["control_role"] = role
    return value


class NeighborhoodReplayContractTests(unittest.TestCase):
    def test_generic_prepared_function_with_argument_dictionaries(self):
        with tempfile.TemporaryDirectory() as directory:
            canonical = Path(directory) / "canonical.mlir"
            canonical.write_text('"builtin.module"() ({ "func.func"() <{'
                'arg_attrs = [{}, {amoeba.noalias}], function_type = () -> (), '
                'sym_name = "kernel"}> ({ "func.return"() : () -> () }) : () -> () }) : () -> ()')
            self.assertEqual(replay.infer_function(canonical, None), "kernel")
            canonical.write_text(canonical.read_text() + '\n"func.func"() <{sym_name = "other"}> ({}) : () -> ()')
            with self.assertRaises(replay.ContractError):
                replay.infer_function(canonical, None)

    def test_shortlist_order_is_preserved_and_not_sorted(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "global-top5.jsonl"
            rows = [row(rank, candidate=f"candidate-{rank}") for rank in (2, 0, 4, 1, 3)]
            path.write_text("\n".join(json.dumps(value) for value in rows) + "\n")
            selected, _, _ = replay.load_cpp_selections(path)
            self.assertEqual([value["rank"] for value in selected], [2, 0, 4, 1, 3])

    def test_shortlist_requires_exactly_five(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "global-top5.jsonl"
            path.write_text("\n".join(json.dumps(row(rank)) for rank in range(4)) + "\n")
            with self.assertRaises(replay.ContractError):
                replay.load_cpp_selections(path)

    def test_missing_cpp_replay_tuple_is_rejected(self):
        value = row(0)
        value.pop("shape_manifest_file")
        with self.assertRaises(replay.ContractError):
            replay.normalize_selection(value)

    def test_controls_require_identity_and_previous_after_stage_one(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "controls.jsonl"
            path.write_text(json.dumps(row(5, "identity-control", "control", "identity")) + "\n")
            with self.assertRaises(replay.ContractError):
                replay.load_cpp_controls(path, require_previous=True)
            path.write_text("\n".join([
                json.dumps(row(5, "identity-control", "control", "identity")),
                json.dumps(row(6, "previous-control", "control", "previous_stage_measured_winner")),
            ]) + "\n")
            values = replay.load_cpp_controls(path, require_previous=True)
            self.assertEqual([value["control_role"] for value in values],
                             ["identity", "previous_stage_measured_winner"])

    def test_search_command_contains_uniform_budget_and_no_closure_flag(self):
        protocol = {"source_commit": "commit", "source_git_repository": "git@github.com:guosran/amoeba.git"}
        command = replay.build_search_command(
            optimizer=Path("/opt/mlir-amoeba-opt"), canonical=Path("/tmp/input.mlir"),
            output_dir=Path("/tmp/search"), function="kernel", stage="full-joint",
            architecture=Path("/tmp/arch.yaml"), protocol=protocol,
            checkpoint=Path("/tmp/checkpoint.json"), seed_manifest=None,
            previous_winner=None, parent_cost_file=Path("/tmp/parent-costs.json"),
            model_cache=None, cost_cache=None,
            max_rounds=20, max_candidates=20000, beam_width=16,
            diversity_slots=4, resume=None)
        option = next(value for value in command if value.startswith("--search-joint-neighborhood="))
        self.assertIn("--architecture-spec=/tmp/arch.yaml", command)
        self.assertIn("max-rounds=20", option)
        self.assertIn("max-candidates=20000", option)
        self.assertIn("beam-width=16", option)
        self.assertIn("parent-cost-file=/tmp/parent-costs.json", option)
        self.assertNotIn("enumerate-joint-graph-closure", option)
        self.assertNotIn("complete-cartesian", option)
        resumed = replay.build_search_command(
            optimizer=Path("/opt/mlir-amoeba-opt"), canonical=Path("/tmp/input.mlir"),
            output_dir=Path("/tmp/search"), function="kernel", stage="full-joint",
            architecture=Path("/tmp/arch.yaml"), protocol=protocol,
            checkpoint=Path("/tmp/checkpoint.json"), seed_manifest=None,
            previous_winner=None, parent_cost_file=None, model_cache=None,
            cost_cache=None, max_rounds=20, max_candidates=20000,
            beam_width=16, diversity_slots=4, resume=Path("/tmp/checkpoint.json"))
        resumed_option = next(value for value in resumed if value.startswith("--search-joint-neighborhood="))
        self.assertIn("resume=true", resumed_option)
        self.assertNotIn("resume=/tmp/checkpoint.json", resumed_option)


    def test_numeric_summary_refreshes_durable_rank_records(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            replay.atomic_write(base / "summary.json", {"records": [
                {"rank": 2, "numeric": "pending"}, {"rank": 0, "numeric": "pending"}]})
            for rank in (2, 0):
                replay.atomic_write(base / f"rank-{rank}" / "result.json",
                                    {"rank": rank, "numeric": "pass", "sram_gate": "pending"})
            summary = replay.refresh_native_summary(base)
            self.assertEqual([r["rank"] for r in summary["records"]], [2, 0])
            self.assertEqual(summary["numeric"], "pass")
            self.assertEqual(summary["sram_gate"], "pending")

    def test_numeric_gate_uses_tracked_runner_and_stage_local_separate_outputs(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            stage_output = base / "protocol-vnext" / "llama" / "shape-only"
            llvm = base / "llvm-build"
            top5_root = base / "native-top5"
            controls_root = base / "native-controls"
            calls = []

            def prepare_native(root, rank):
                (root / f"rank-{rank}").mkdir(parents=True)
                (root / f"rank-{rank}" / "native.mlir").write_text("module {}\n")
                replay.atomic_write(root / f"rank-{rank}" / "result.json", {
                    "rank": rank, "status": "native_replayed", "numeric": "pending",
                    "native_cycles": 100, "sram_gate": "pending",
                })
                replay.atomic_write(root / "summary.json", {
                    "records": [{"rank": rank, "numeric": "pending", "sram_gate": "pending"}],
                })

            prepare_native(top5_root, 0)
            prepare_native(controls_root, 5)

            def fake_run(argv, output_dir, label, *, env=None):
                calls.append((list(argv), output_dir, label))
                output_root = Path(argv[argv.index("--output-root") + 1])
                workload = argv[argv.index("--workloads") + 1]
                stage = argv[argv.index("--stage") + 1]
                rank = int(argv[argv.index("--ranks") + 1])
                evidence = output_root / workload / f"{stage}-rank-{rank}" / "result.json"
                replay.atomic_write(evidence, {
                    "status": "pass", "element_comparisons": 8,
                })
                return {"status": "finished", "exit_code": 0, "argv": list(argv)}

            with patch.dict(os.environ, {"ORBIT_LLVM_BUILD": str(llvm)}):
                with patch.object(replay, "_run_logged", side_effect=fake_run):
                    top5 = replay.run_numeric_gate(
                        workload="llama", stage="shape-only", native_root=top5_root,
                        ranks=range(5), optimizer=Path("/opt/orbit-opt"), jobs=4,
                        label_suffix="top5", output_dir=stage_output,
                    )
                    controls = replay.run_numeric_gate(
                        workload="llama", stage="shape-only", native_root=controls_root,
                        ranks=(5,), optimizer=Path("/opt/orbit-opt"), jobs=4,
                        label_suffix="controls", output_dir=stage_output,
                    )

            self.assertEqual(len(calls), 2)
            top_args, control_args = calls[0][0], calls[1][0]
            self.assertEqual(top_args[0], sys.executable)
            self.assertEqual(Path(top_args[1]), replay.ROOT / "scripts/run_input0_numeric.py")
            for argv in (top_args, control_args):
                self.assertEqual(argv[argv.index("--artifact-root") + 1], str(replay.ROOT))
                self.assertEqual(argv[argv.index("--reference-root") + 1],
                                 str(replay.DEFAULT_NUMERIC_REFERENCE_ROOT))
                self.assertEqual(argv[argv.index("--llama-harness") + 1],
                                 str(replay.DEFAULT_LLAMA_HARNESS))
                self.assertEqual(argv[argv.index("--llvm-build") + 1], str(llvm))
            top_output = Path(top_args[top_args.index("--output-root") + 1])
            control_output = Path(control_args[control_args.index("--output-root") + 1])
            self.assertEqual(top_output.parent, stage_output / "numeric" / "top5")
            self.assertEqual(control_output.parent, stage_output / "numeric" / "controls")
            self.assertNotEqual(top_output, control_output)
            self.assertNotIn("results/input0-cpp-numeric-gates", str(top_output))
            self.assertEqual(top5["numeric_output_root"], str(top_output))
            self.assertEqual(controls["numeric_output_root"], str(control_output))
            top_record = json.loads((top5_root / "rank-0/result.json").read_text())
            control_record = json.loads((controls_root / "rank-5/result.json").read_text())
            self.assertEqual(top_record["numeric"], "pass")
            self.assertEqual(control_record["numeric"], "pass")
            self.assertIn(top_output, Path(top_record["numeric_evidence"]).parents)
            self.assertIn(control_output, Path(control_record["numeric_evidence"]).parents)

    def test_numeric_gate_missing_result_propagates_incomplete_status(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            native_root = base / "native-top5"
            (native_root / "rank-0").mkdir(parents=True)
            (native_root / "rank-0/native.mlir").write_text("module {}\n")
            replay.atomic_write(native_root / "rank-0/result.json", {
                "rank": 0, "status": "native_replayed", "numeric": "pending",
                "native_cycles": 100, "sram_gate": "pending",
            })
            replay.atomic_write(native_root / "summary.json", {
                "records": [{"rank": 0, "numeric": "pending", "sram_gate": "pending"}],
            })
            with patch.object(replay, "_run_logged", return_value={
                "status": "finished", "exit_code": 7, "argv": ["fixture"],
            }):
                command = replay.run_numeric_gate(
                    workload="lu", stage="shape-only", native_root=native_root,
                    ranks=(0,), optimizer=Path("/opt/orbit-opt"), jobs=1,
                    label_suffix="top5", output_dir=base / "stage",
                )
            record = json.loads((native_root / "rank-0/result.json").read_text())
            summary = json.loads((native_root / "summary.json").read_text())
            self.assertEqual(command["exit_code"], 7)
            self.assertEqual(record["numeric"], "incomplete")
            self.assertEqual(record["numeric_command_exit_code"], 7)
            self.assertEqual(record["numeric_error"], "numeric_gate_result_missing")
            self.assertEqual(summary["numeric"], "incomplete")
            self.assertEqual(replay.numeric_gate_status(summary, command), "incomplete")

    def test_numeric_process_failure_overrides_pass_rows_but_mismatch_remains_fail(self):
        passed_rows = {"numeric": "pass", "records": [{"numeric": "pass"}]}
        self.assertEqual(replay.numeric_gate_status(passed_rows, {"exit_code": 0}), "pass")
        self.assertEqual(replay.numeric_gate_status(passed_rows, {"exit_code": 7}), "incomplete")
        failed_rows = {"numeric": "fail", "records": [{"numeric": "fail"}]}
        self.assertEqual(replay.numeric_gate_status(failed_rows, {"exit_code": 7}), "fail")

    def test_mapper_failure_is_saved_and_other_records_continue(self):
        class BrokenReplay:
            def replay(self, selection, args):
                if selection["rank"] == 0:
                    raise RuntimeError("mapper fixture error")
                return {"rank": selection["rank"], "candidate_id": selection["candidate_id"],
                        "status": "native_replayed", "native_cycles": 80,
                        "independent_trace": "pass", "mapper_equality": "pass"}
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            with patch.object(replay, "_load_replay_module", return_value=BrokenReplay()):
                summary = replay.replay_records([row(0), row(1)], output_dir=base,
                    optimizer=Path("/opt/opt"), architecture=Path("/tmp/arch"),
                    mapping_cache=Path("/tmp/cache"), manifest=Path("/tmp/manifest"),
                    graph_manifests=None, sram_config=Path("/tmp/sram"), jobs=1)
            self.assertEqual(summary["status"], "incomplete")
            self.assertIn("mapper fixture error", summary["records"][0]["blocker"])
            self.assertEqual(summary["records"][1]["status"], "native_replayed")
            self.assertTrue((base / "rank-0/result.json").is_file())

    def test_selection_replay_skips_cartesian_enumerator(self):
        helper = load("global_replay_fixture", "replay_cpp_global_top5.py")
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            manifest = base / "selection.json"
            manifest.write_text(json.dumps({"schema": "orbit-neighborhood-shape-selection-v1",
                "record_type": "selection", "candidate_id": "shape-0", "graph_variant_id": "identity"}) + "\n")
            score = base / "scores.jsonl"
            score.write_text(json.dumps({"schedule_space": "production-scheduler", "dispatch_policy": "fixed"}) + "\n")
            selected = row(0)
            selected["score_record"]["shape_candidate_id"] = "shape-0"
            selected["score_file_path"] = str(score)
            selected["candidate_manifest"] = str(manifest)
            args = SimpleNamespace(manifest=manifest, graph_manifests=None, output_dir=base,
                optimizer=Path("/opt/opt"), architecture=Path("/tmp/arch"),
                mapping_cache=Path("/tmp/cache"), reuse_mapped_root=None,
                inter_task_network=None)
            with patch.object(helper, "invoke", return_value={"exit_code": 1}) as invoke:
                result = helper.replay(selected, args)
            command = invoke.call_args.args[0]
            self.assertFalse(any("enumerate-analytical" in value for value in command))
            self.assertTrue(any("materialize-analytical" in value for value in command))
            self.assertEqual(result["blocker"], "mapper_process_failed")


class NeighborhoodTableTests(unittest.TestCase):
    def test_actual_value_uses_measured_controls_and_keeps_pending_gates(self):
        value = {
            "schema": "orbit-neighborhood-stage-result-v1",
            "workload": "fixture", "stage": "shape-only", "status": "native_replayed",
            "top5": [row(rank) for rank in range(5)],
            "native_top5": {"records": [
                {"rank": 0, "candidate_id": "candidate-0", "status": "native_replayed",
                 "native_cycles": 120, "independent_trace": "pass", "mapper_equality": "pass", "numeric": "pass", "sram_gate": "pending"},
            ]},
            "native_controls": {"records": [
                {"rank": 5, "candidate_id": "identity-control", "control_role": "identity",
                 "status": "native_replayed", "native_cycles": 110,
                 "independent_trace": "pass", "mapper_equality": "pass", "numeric": "pass", "sram_gate": "pending"},
            ]},
            "numeric": "pass", "trace": "pass", "sram": "pending",
            "search_footer": {"unique_complete_candidates_scored": 7,
                               "rounds": 2, "cache_hits": 4, "cache_misses": 3},
            "stop_reason": "max-rounds", "best_found": True,
        }
        row_value = table.stage_row(value, s1=130, previous=None)
        self.assertEqual(row_value["native_stage_cycles"], 110)
        self.assertEqual(row_value["relative_to_s1_cycles"], -20)
        self.assertEqual(row_value["sram"], "pending")
        self.assertEqual(row_value["unique_complete_candidates_scored"], 7)
        self.assertEqual(row_value["measured_native_order"][0]["candidate_id"], "identity-control")


if __name__ == "__main__":
    unittest.main()
