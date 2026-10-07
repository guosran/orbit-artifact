from __future__ import annotations

import json
import csv
import shutil
import sys
import tempfile
import unittest
from pathlib import Path
from typing import Any

WORK_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(WORK_ROOT / "scripts"))

from export_neighborhood_final_results import ExportError, STAGES, export  # noqa: E402
from render_neighborhood_table import LEGACY_STAGES, main as render_stage_table  # noqa: E402


WORKLOADS = ["llama", "lu", "harris", "radar", "gcn", "raytracing"]
PROTOCOL_SCHEMA = "orbit-amoeba-input0-neighborhood-v3"
COMMIT_TOKEN = "fixture-source-revision"
DIRECT_MODEL_NAMESPACE = "orbit-per-cgra-2x2-direct-4member-v1"
OPTIMIZER = ".work/post-publication/mlir-amoeba-opt-v19-corrected-neighborhood"
CONTRACT = ".work/post-publication/source-model-contract-v19.json"
MODEL = ".work/models/ensemble.json"
ARCH = "config/architectures/amoeba_4x4_full_mesh_context12.yaml"


def write_json(path: Path, value: Any) -> str:
    path.parent.mkdir(parents=True, exist_ok=True)
    content = json.dumps(value, indent=2, sort_keys=True) + "\n"
    path.write_text(content)
    return content


def make_fixture(root: Path, stages: tuple[str, ...] = STAGES) -> tuple[Path, Path, Path]:
    """Build a complete tiny cohort with exact checkpoint payloads."""
    repo = root / "artifact"
    repo.mkdir(parents=True)
    protocol_path = repo / ".work/post-publication/protocol-v19-corrected-neighborhood.json"
    protocol = {
        "schema": PROTOCOL_SCHEMA,
        "active": True,
        "scope": "six complete-program fixed input-0 cumulative ablation",
        "workloads_in_delivery_order": ["LLaMA", "LU", "Harris", "Radar", "GCN", "Raytracing"],
        "canonical_program_pattern": ".work/post-publication/canonical-v19/<workload>/canonical.mlir",
        "source_commit": COMMIT_TOKEN,
        "source_binding": "exact compiler source and optimizer bytes; no SHA",
        "architecture": "${ARTIFACT_ROOT}/" + ARCH,
        "model_namespace": "fixture-model-namespace",
        "model_ensemble": MODEL,
        "stages": [{"stage": index, "name": name} for index, name in enumerate(stages, start=1)],
        "search": {
            "max_rounds": 4,
            "max_unique_complete_candidates_scored": 4096,
            "beam_width": 16,
            "diversity_min_slots": 4,
            "native_shortlist": 5,
            "max_partition_factor": 8,
            "cost_selected_max_slots": 12,
        },
        "optimizer_pin": "${ARTIFACT_ROOT}/.work/post-publication/mlir-amoeba-opt-v17-source-domain-final",
        "source_contract_file": "${ARTIFACT_ROOT}/.work/post-publication/source-model-contract-v17-source-domain.json",
        "source_variant": "correct-complete-source-iteration-domains-v17-generic-lossless",
        "budget_profile": "uniform-expanded-4-rounds-4096-unique",
        "publication_variant": "minimum portable observations",
        "input_policy": "fixed input-0; compile-time-proven static bounds",
    }
    protocol_text = write_json(protocol_path, protocol)
    contract_path = repo / CONTRACT
    contract = {
        "schema": "orbit-neighborhood-exact-source-model-contract-v1",
        "source_commit": COMMIT_TOKEN,
        "model_namespace": "fixture-model-namespace",
        "source_dirty": True,
        "search_contract": "orbit-neighborhood-search-v1",
        "rewrite_contract": "orbit-joint-graph-rewrite-contract-v8",
        "immutable_optimizer_pin": "${ARTIFACT_ROOT}/" + OPTIMIZER,
        "source_file_list": ".work/post-publication/source-files-v19.json",
        "sources": [{"path": "lib/fixture.cpp"}, {"path": "include/fixture.h"}],
        "model_payloads": [{"path": "ensemble.json"}, {"path": "baseline.json"}],
        "replay_payloads": [{"path": "scripts/replay_fixture.py"},
                             {"path": "config/fixture.yaml"}],
    }
    contract_text = write_json(contract_path, contract)
    arch_path = repo / ARCH
    arch_path.parent.mkdir(parents=True, exist_ok=True)
    arch_text = "architecture: fixture-4x4\nrows: 4\ncolumns: 4\n"
    arch_path.write_text(arch_text)
    model_path = repo / MODEL
    model_text = write_json(model_path, {"schema": "fixture-ensemble-v1", "members": [1, 2]})

    for workload in WORKLOADS:
        canonical_rel = f".work/post-publication/canonical-v19/{workload}/canonical.mlir"
        canonical_path = repo / canonical_rel
        canonical_path.parent.mkdir(parents=True, exist_ok=True)
        canonical_text = f"module {{ // canonical {workload}\n}}\n"
        canonical_path.write_text(canonical_text)
        cost_cache = f".work/post-publication/canonical-v19/{workload}/ml-cache.json"
        parent_cost_path = repo / f".work/post-publication/canonical-v19/{workload}/cost-catalog.json"
        parent_cost_text = write_json(parent_cost_path, {"schema": "fixture-cost-v1", "workload": workload})
        binding = {
            "schema": "orbit-neighborhood-source-binding-v1",
            "protocol_schema": PROTOCOL_SCHEMA,
            "source_commit": COMMIT_TOKEN,
            "identity_policy": "exact source/byte/path binding; no SHA",
            "architecture": str(arch_path.resolve()),
            "optimizer": str((repo / OPTIMIZER).resolve()),
            "model_cache": str(model_path.resolve()),
            "source_contract_file": str(contract_path.resolve()),
            "canonical_program": str(canonical_path.resolve()),
            "cost_cache": str((repo / cost_cache).resolve()),
            "parent_cost_file": str(parent_cost_path.resolve()),
        }
        binding_path = repo / "results/input0-neighborhood-v19-corrected" / workload / "binding.json"
        binding_text = write_json(binding_path, binding)
        _ = binding_text

        for stage_index, stage in enumerate(stages):
            stage_dir = repo / "results/input0-neighborhood-v19-corrected" / workload / stage
            stage_dir.mkdir(parents=True, exist_ok=True)
            source_binding_path = stage_dir / "source-binding.json"
            source_binding_path.write_text(json.dumps(binding, indent=2, sort_keys=True) + "\n")
            checkpoint_path = stage_dir / "checkpoint.json"
            checkpoint_path.write_text("{}\n")
            exact_files = {
                "architecture": {"path": str(arch_path.resolve()), "exact_bytes": arch_text},
                "ensemble": {"path": str(model_path.resolve()), "exact_bytes": model_text},
                "protocol": {"path": str(protocol_path.resolve()), "exact_bytes": protocol_text},
                "source_and_model_contract": {"path": str(contract_path.resolve()), "exact_bytes": contract_text},
                "parent_costs": {"path": str(parent_cost_path.resolve()), "exact_bytes": parent_cost_text},
            }
            checkpoint_binding = {
                "schema": "orbit-neighborhood-exact-binding-v1",
                "checkpoint_contract": "orbit-neighborhood-search-checkpoint-v2",
                "architecture_contract": "neura-architecture-v1:fixture-4x4",
                "stage": stage,
                "function": f"fixture_{workload}",
                "source_commit": COMMIT_TOKEN,
                "model_namespace": "fixture-model-namespace",
                "max_rounds": 4,
                "max_candidates": 4096,
                "beam_width": 16,
                "diversity_slots": 4,
                "search_contract": "orbit-neighborhood-search-v1",
                "canonical_ir": canonical_text,
                "files": exact_files,
            }
            write_json(checkpoint_path.with_name("checkpoint.json.binding.json"), checkpoint_binding)

            top5 = []
            native_records = []
            for rank in range(5):
                cid = f"cand-{workload}-{stage}-{rank}"
                gid = f"graph-{rank}"
                actions = [f"shape:shape:T{rank}:1x1:T{rank}:1x1:reset=0"]
                if workload == "llama" and stage == "full-joint" and rank == 2:
                    actions = [
                        "shape:shape:T2:2x1:T2:2x1:reset=0",
                        "replica:replica:T2:axis=0:factor=2::0x0:reset=0",
                        "tiling:tile:T2:axis=1:factor=2::0x0:reset=0",
                        "fusion:fuse:T2:T3:mode=producer-consumer::0x0:reset=0",
                    ]
                candidate = {
                    "rank": rank,
                    "candidate_id": cid,
                    "graph_variant_id": gid,
                    "predicted_whole_program_cycles": 10 + rank,
                    "valid": True,
                    "certified": True,
                    "best_found": True,
                    "transformations": {
                        "action_path": actions,
                        "lineage_source": "/home/testuser/private/candidate.mlir",
                        "shape": [{"task": "T0", "rows": 2 if rank == 2 else 1,
                                   "cols": 1, "mapper_tile_rows": 8 if rank == 2 else 4,
                                   "mapper_tile_cols": 4, "trip_count": 64}],
                    },
                    "task_choices": [{"task": "T0", "rows": 2 if rank == 2 else 1,
                                      "cols": 1, "mapper_tile_rows": 8 if rank == 2 else 4,
                                      "mapper_tile_cols": 4, "trip_count": 64}],
                    "communication_trace_known": True,
                    "dispatch_order": ["T0", "T1"],
                    "task_schedule": [{"task": "T0"}, {"task": "T1"}],
                    "replayed_communication_edges": [],
                }
                top5.append(candidate)
                failed = workload == "llama" and stage == "full-joint" and rank == 4
                native_records.append({
                    "rank": rank,
                    "candidate_id": cid,
                    "graph_variant_id": gid,
                    "status": "mapper_failed" if failed else "native_replayed",
                    "native_cycles": None if failed else (100 - 10 * stage_index
                                                           if rank == 2 else
                                                           120 - 10 * stage_index + rank),
                    "mapper_equality": "fail" if failed else "pass",
                    "prediction_mapper_equal": False,
                    "prediction_start_equality": True,
                    "independent_trace": "not_run" if failed else "pass",
                    "numeric": "not_run" if failed else "pass",
                    "numeric_element_comparisons": None if failed else 16,
                    "numeric_command_exit_code": None if failed else 0,
                    "numeric_evidence": None,
                    "sram_gate": "pending",
                    "sram_blocker": "conservative check pending",
                    "sram_evidence": None,
                    "mapper_command": {"status": "failed" if failed else "completed",
                                        "exit_code": 1 if failed else 0,
                                        "started_utc": "2026-10-04T00:00:00Z",
                                        "ended_utc": "2026-10-04T00:00:01Z",
                                        "argv": ["hidden"]},
                    "native_command": {"status": "failed" if failed else "completed",
                                        "exit_code": 1 if failed else 0,
                                        "stdout_log": "/home/testuser/private/raw.log"},
                    "mapper_error": "/home/testuser/private/mapper-failed.log" if failed else None,
                    "production_ready": False,
                })
            control_id = f"identity-{workload}-{stage}"
            control_config = {
                "rank": 5,
                "candidate_id": control_id,
                "graph_variant_id": "graph-identity",
                "control_role": "canonical-identity",
                "predicted_whole_program_cycles": 120,
                "transformations": {"action_path": [], "shape": [
                    {"task": "T0", "rows": 1, "cols": 1, "mapper_tile_rows": 4,
                     "mapper_tile_cols": 4, "trip_count": 64}]},
                "task_choices": [{"task": "T0", "rows": 1, "cols": 1,
                                  "mapper_tile_rows": 4, "mapper_tile_cols": 4,
                                  "trip_count": 64}],
                "dispatch_order": ["T0"], "task_schedule": [{"task": "T0"}],
                "replayed_communication_edges": [], "communication_trace_known": True,
            }
            native_control = {
                "rank": 5, "control_role": "canonical-identity", "candidate_id": control_id,
                "graph_variant_id": "graph-identity", "status": "native_replayed",
                "native_cycles": 140 - 10 * stage_index, "mapper_equality": "pass", "independent_trace": "pass",
                "numeric": "pass", "numeric_element_comparisons": 16,
                "numeric_command_exit_code": 0, "sram_gate": "pending", "sram_blocker": "pending",
                "production_ready": False,
            }
            footer = {
                "max_rounds": 4, "max_candidates": 4096, "beam_width": 16,
                "diversity_slots": 4, "max_partition_factor": 8,
                "native_shortlist_count": 5, "unique_complete_candidates_scored": 2,
                "unique_scored_candidates": 2, "unique_valid_candidates": 2,
                "cache_hits": 11, "cache_misses": 3, "rounds": 2, "rounds_completed": 2,
                "elapsed_seconds": 4.25, "stop_reason": "no-new-legal-candidates",
                "production_scheduler_calls": 2, "rejected_or_duplicate_candidates": 1,
                "reject_reasons": {"fixture-reject": 1,
                                   "diagnostic": "/home/testuser/private/reject.log"},
            }
            stage_result = {
                "schema": "orbit-neighborhood-stage-result-v1",
                "workload": workload, "stage": stage, "status": "native_replayed",
                "result_label": "best-found", "best_found": True, "exhaustive": False,
                "global_optimality_claim": False, "production_ready": False,
                "function": f"fixture_{workload}", "protocol": str(protocol_path.resolve()),
                "source_binding": str(source_binding_path.resolve()),
                "checkpoint": str(checkpoint_path.resolve()),
                "actual_stage_cycles": 100 - 10 * stage_index,
                "actual_stage_cycle_source": "minimum whole-program native cycles across measured top5 and controls",
                "top5": top5, "controls": [control_config],
                "native_top5_status": "native_replayed",
                "native_top5": {"schema": "fixture-native-v1", "status": "native_replayed",
                                "numeric": "pass", "sram_gate": "pending", "production_ready": False,
                                "records": native_records},
                "native_controls": {"schema": "fixture-native-v1", "status": "native_replayed",
                                    "numeric": "pass", "sram_gate": "pending", "production_ready": False,
                                    "records": [native_control]},
                "numeric": "pass", "trace": "pass", "sram": "pending",
                "search_header": footer, "search_footer": footer,
                "stop_reason": "no-new-legal-candidates",
            }
            write_json(stage_dir / "result.json", stage_result)
    return repo, protocol_path, repo / "results/input0-neighborhood-v19-corrected"


def bind_v4_network(repo: Path, protocol_path: Path, results: Path) -> Path:
    protocol = json.loads(protocol_path.read_text())
    network_path = repo / "config/networks/fixture.yaml"
    network_path.parent.mkdir(parents=True, exist_ok=True)
    network_text = "inter_task_network:\n  fixture_latency: 1\n"
    network_path.write_text(network_text)
    protocol["inter_task_network_spec"] = "${ARTIFACT_ROOT}/config/networks/fixture.yaml"
    protocol_text = write_json(protocol_path, protocol)
    for result_path in results.glob("*/*/result.json"):
        result = json.loads(result_path.read_text())
        source_path = Path(result["source_binding"])
        source_binding = json.loads(source_path.read_text())
        source_binding["inter_task_network"] = str(network_path.resolve())
        source_binding["inter_task_network_text"] = network_text
        write_json(source_path, source_binding)
        checkpoint_path = Path(result["checkpoint"])
        binding_path = checkpoint_path.with_name(checkpoint_path.name + ".binding.json")
        checkpoint = json.loads(binding_path.read_text())
        checkpoint["checkpoint_contract"] = "orbit-neighborhood-search-checkpoint-v4"
        checkpoint["inter_task_network_spec_override"] = {"exact_bytes": network_text}
        checkpoint["files"]["protocol"] = {
            "path": str(protocol_path.resolve()), "exact_bytes": protocol_text}
        write_json(binding_path, checkpoint)
    return network_path


def make_domain_exception_fixture(root: Path) -> tuple[Path, Path, Path, Path]:
    repo, protocol_path, results = make_fixture(root)
    protocol = json.loads(protocol_path.read_text())
    protocol["model_namespace"] = DIRECT_MODEL_NAMESPACE
    protocol["model_domain_exclusions"] = {
        "raytracing": {"status": "unsupported_model_domain", "task": "Task_13",
                       "model_interval_max_ii": 20}
    }
    protocol["fabric"] = {"per_cgra_pe_rows": 2, "per_cgra_pe_columns": 2}
    protocol["search"]["later_shapes"] = [
        [1, 1], [1, 2], [2, 1], [1, 3], [3, 1], [1, 4], [2, 2], [4, 1]
    ]
    write_json(protocol_path, protocol)
    contract_path = repo / CONTRACT
    contract = json.loads(contract_path.read_text())
    contract["model_namespace"] = DIRECT_MODEL_NAMESPACE
    contract_text = write_json(contract_path, contract)
    for result_path in results.glob("*/*/result.json"):
        result = json.loads(result_path.read_text())
        checkpoint_path = Path(result["checkpoint"])
        binding_path = checkpoint_path.with_name(checkpoint_path.name + ".binding.json")
        checkpoint = json.loads(binding_path.read_text())
        checkpoint["model_namespace"] = DIRECT_MODEL_NAMESPACE
        checkpoint["files"]["source_and_model_contract"]["exact_bytes"] = contract_text
        write_json(binding_path, checkpoint)
    network_path = bind_v4_network(repo, protocol_path, results)
    shutil.rmtree(results / "raytracing")

    canonical = repo / ".work/post-publication/canonical-v19/raytracing/canonical.mlir"
    catalog_path = repo / ".work/domain-evidence/raytracing/cost-catalog.json"
    shapes = {(rows * 2, cols * 2) for rows, cols in protocol["search"]["later_shapes"]}
    lower_bounds = {(2, 2): 83, (2, 4): 42, (2, 6): 28, (2, 8): 21,
                    (4, 2): 42, (4, 4): 21, (6, 2): 28, (8, 2): 21}
    entries = [
        {"task": "Task_13", "mapper_tile_rows": rows, "mapper_tile_cols": cols,
         "analytical_lower_bound": lower_bounds[rows, cols], "model_interval_max_ii": 20,
         "status": "unsupported-model-domain", "support_status": "unsupported",
         "unsupported_reason": "analytical-lower-bound-exceeds-model-ceiling"}
        for rows, cols in sorted(shapes)
    ]
    witness = '"builtin.module"() ({ "func.func"() <{fixture = "canonical-ray"}> })'
    catalog = {"schema": "amoeba-task-shape-cost", "namespace": DIRECT_MODEL_NAMESPACE,
               "predictor_metadata": {"model_interval_max_ii": 20,
                                      "canonical_module_witness": witness},
               "entries": entries}
    write_json(catalog_path, catalog)
    architecture = repo / ARCH
    ensemble = repo / MODEL
    contract = repo / CONTRACT
    paths = {
        "canonical_program": canonical, "cost_catalog": catalog_path,
        "source_contract_file": contract, "architecture": architecture,
        "ensemble": ensemble, "inter_task_network": network_path,
        "protocol": protocol_path,
    }
    source_binding_path = results / "gcn" / STAGES[0] / "source-binding.json"
    source_binding = json.loads(source_binding_path.read_text())
    source_binding["canonical_program"] = str(canonical.resolve())
    source_binding["parent_cost_file"] = str(catalog_path.resolve())
    source_binding["cost_cache"] = str((repo / ".work/domain-evidence/raytracing/ml-cache.json").resolve())
    network_text = network_path.read_text()
    source_binding["inter_task_network_text"] = network_text
    argv = [
        str((repo / OPTIMIZER).resolve()), str(canonical.resolve()),
        "--architecture-spec=" + str(architecture.resolve()),
        "--search-joint-neighborhood=protocol=" + str(protocol_path.resolve()) +
        " source-contract-file=" + str(contract.resolve()) +
        " parent-cost-file=" + str(catalog_path.resolve()) +
        " model=" + str(ensemble.resolve()) + " model-namespace=" + DIRECT_MODEL_NAMESPACE,
        "--joint-inter-task-network-spec=" + str(network_path.resolve()),
    ]
    evidence = {
        "schema": "orbit-model-domain-exclusion-evidence-v1",
        "status": "proved_outside_model_interval", "workload": "raytracing",
        "task": "Task_13", "model_namespace": DIRECT_MODEL_NAMESPACE,
        "model_interval_max_ii": 20,
        "canonical_module_witness": witness, "canonical_task_witness": witness,
        "source_binding": source_binding,
        **{key: str(path.resolve()) for key, path in paths.items()},
        "exact_payloads": {
            key: {"path": str(path.resolve()), "exact_bytes": path.read_text()}
            for key, path in paths.items()
        },
        "queries": entries, "preflight_command": argv, "exit_code": 1,
        "failure_diagnostic": str(canonical.resolve()) +
        ":1:1: error: task has no supported model shape for canonical identity: Task_13",
        "native_cycles": None, "formal_go": False,
    }
    evidence_path = repo / ".work/domain-evidence/model-domain-evidence.json"
    write_json(evidence_path, evidence)
    return repo, protocol_path, results, evidence_path


class FinalResultsExporterTest(unittest.TestCase):
    def setUp(self) -> None:
        self.case = Path(tempfile.mkdtemp(prefix="orbit-neighborhood-export-fixture-"))
        self.addCleanup(shutil.rmtree, self.case)
        self.repo, self.protocol, self.results = make_fixture(self.case)

    def test_full_export_preserves_configuration_failure_and_is_portable(self) -> None:
        output_dir = self.case / "published"
        result = export(self.results, self.protocol, self.repo, output_dir)
        self.assertEqual(result["cell_count"], 24)
        self.assertEqual(result["publication_readiness"], "diagnostic_only")
        self.assertFalse(result["formal_go"])
        discrepancies = result["provenance"]["protocol_metadata_discrepancy"]
        self.assertEqual({item["field"] for item in discrepancies},
                         {"optimizer_pin", "source_contract_file", "source_variant"})
        self.assertEqual(result["stage_order"], list(STAGES))
        self.assertEqual(result["stage_scheme"], "merged-spatial-temporal")
        self.assertEqual(len(result["rows"]), 24)
        self.assertTrue(all(row["actual_winner_configuration"] is not None for row in result["rows"]))
        self.assertTrue(all(row["actual_winner"]["candidate_id"] ==
                            row["actual_winner_configuration"]["candidate_id"]
                            for row in result["rows"]))

        target = next(row for row in result["rows"]
                      if row["workload"] == "llama" and row["stage"] == "full-joint")
        self.assertEqual([item["candidate_id"] for item in target["predicted_top5_order"]],
                         [item["candidate_id"] for item in target["predicted_top5_configuration"]])
        self.assertEqual(target["actual_winner"]["candidate_id"],
                         "cand-llama-full-joint-2")
        self.assertEqual(target["relative_to_s1_cycles"], -30)
        families = set(target["actual_winner_configuration"]["action_families"])
        self.assertTrue({"shape", "replica", "tiling", "fusion"}.issubset(families))
        self.assertTrue(target["actual_winner_configuration"]["shape_configuration"])
        failed = target["measured_native_top5"]["records"][4]
        self.assertEqual(failed["status"], "mapper_failed")
        self.assertIn("<local-path>", failed["errors"]["mapper_error"])
        self.assertEqual(target["sram"], "pending")

        final_text = (output_dir / "neighborhood-final-results.json").read_text()
        self.assertNotIn("/home/", final_text)
        self.assertNotIn("/tmp/", final_text)
        self.assertNotIn("candidate_key", final_text)
        self.assertNotIn("canonical_ir", final_text)
        self.assertNotIn("argv", final_text)
        self.assertNotRegex(final_text, r"(?i)\b[0-9a-f]{40,64}\b")
        table = json.loads((output_dir / "neighborhood-stage-table.json").read_text())
        self.assertEqual(table["stage_order"], list(STAGES))
        self.assertEqual(len(table["rows"]), 24)
        self.assertTrue((output_dir / "neighborhood-stage-table.md").is_file())

        rendered_dir = self.case / "four-stage-rendered"
        render_stage_table(["--results-root", str(self.results), "--workloads", "llama",
                            "--output-dir", str(rendered_dir)])
        rendered = json.loads((rendered_dir / "neighborhood-stage-table.json").read_text())
        self.assertEqual(rendered["stage_order"], list(STAGES))
        rendered_rows = rendered["rows"]
        self.assertEqual(rendered_rows[0]["stage"], "shape-temporal")
        self.assertEqual(rendered_rows[0]["native_stage_cycles"], 100)
        self.assertEqual(rendered_rows[1]["relative_to_s1_cycles"], -10)

    def test_historical_five_stage_export_and_renderer_keep_original_s1_s5(self) -> None:
        repo, protocol, results = make_fixture(self.case / "historical-five-stage",
                                                stages=LEGACY_STAGES)
        output_dir = self.case / "historical-five-stage-export"
        result = export(results, protocol, repo, output_dir, render_plots=True,
                        plot_script=WORK_ROOT / "scripts/plot_input0_neighborhood_ablation.py")
        self.assertEqual(result["stage_order"], list(LEGACY_STAGES))
        self.assertEqual(result["stage_scheme"], "historical-five-stage")
        target = next(row for row in result["rows"]
                      if row["workload"] == "llama" and row["stage"] == "full-joint")
        self.assertEqual(target["relative_to_s1_cycles"], -40)
        table = json.loads((output_dir / "neighborhood-stage-table.json").read_text())
        self.assertEqual(table["stage_order"], list(LEGACY_STAGES))
        plot_svg = (output_dir / "plots/input0-ablation-normalized.svg").read_text()
        self.assertIn("Historical five-stage", plot_svg)
        with (output_dir / "plots/input0-ablation-values.csv").open(newline="") as source:
            rows = list(csv.DictReader(source))
        self.assertEqual(rows[0]["S1"], "100")
        self.assertEqual(rows[0]["S5"], "60")

        rendered_dir = repo / "historical-table-rendered"
        render_stage_table(["--results-root", str(results), "--workloads", "llama",
                            "--output-dir", str(rendered_dir)])
        rendered = json.loads((rendered_dir / "neighborhood-stage-table.json").read_text())
        self.assertEqual(rendered["stage_order"], list(LEGACY_STAGES))
        rendered_rows = rendered["rows"]
        self.assertEqual(rendered_rows[0]["stage"], "shape-only")
        self.assertEqual(rendered_rows[0]["native_stage_cycles"], 100)
        self.assertEqual(rendered_rows[1]["relative_to_s1_cycles"], -10)

    def test_missing_stage_refuses_without_writing_output(self) -> None:
        missing = self.results / "gcn" / "full-joint" / "result.json"
        saved = missing.read_text()
        missing.unlink()
        target = self.case / "missing-output"
        try:
            with self.assertRaisesRegex(ExportError, "incomplete six-by-4 cohort"):
                export(self.results, self.protocol, self.repo, target)
            self.assertFalse(target.exists())
        finally:
            missing.write_text(saved)

    def test_mixed_runtime_binding_refuses(self) -> None:
        binding_path = self.results / "harris" / "full-joint" / "source-binding.json"
        binding = json.loads(binding_path.read_text())
        binding["model_cache"] = str((self.repo / ".work/models/other-ensemble.json").resolve())
        binding_path.write_text(json.dumps(binding, indent=2, sort_keys=True) + "\n")
        with self.assertRaisesRegex(ExportError, "runtime source/model/architecture binding differs"):
            export(self.results, self.protocol, self.repo, self.case / "mixed-output")
        self.assertFalse((self.case / "mixed-output").exists())

    def test_v4_ray_exclusion_requires_exact_cpp_catalog_and_exports_na(self) -> None:
        repo, protocol, results, evidence = make_domain_exception_fixture(self.case / "exception")
        output = self.case / "exception-output"
        result = export(results, protocol, repo, output, model_domain_evidence=evidence)
        self.assertEqual(result["cell_count"], 24)
        self.assertEqual(sum(row["status"] == "native_replayed" for row in result["rows"]), 20)
        ray_rows = [row for row in result["rows"] if row["workload"] == "raytracing"]
        self.assertEqual(len(ray_rows), 4)
        self.assertTrue(all(row["status"] == "unsupported_model_domain" and
                            row["actual_stage_cycles"] is None and
                            row["native_top5_status"] == "not_run" for row in ray_rows))
        summary = result["provenance"]["model_domain_exclusion"]
        self.assertEqual(summary["unsupported_shape_count"], 8)
        self.assertTrue(summary["canonical_module_witness_verified"])
        table = json.loads((output / "neighborhood-stage-table.json").read_text())
        self.assertTrue(all(row["native_stage_cycles"] is None
                            for row in table["rows"] if row["workload"] == "raytracing"))

    def test_bad_cpp_exclusion_evidence_rejects_and_missing_measured_cell_rejects(self) -> None:
        repo, protocol, results, evidence = make_domain_exception_fixture(self.case / "bad-evidence")
        evidence_data = json.loads(evidence.read_text())
        evidence_data["queries"][0]["analytical_lower_bound"] = 20
        write_json(evidence, evidence_data)
        with self.assertRaisesRegex(ExportError, "query evidence differs"):
            export(results, protocol, repo, self.case / "bad-evidence-output",
                   model_domain_evidence=evidence)
        self.assertFalse((self.case / "bad-evidence-output").exists())

        repo, protocol, results, evidence = make_domain_exception_fixture(self.case / "missing-measured")
        (results / "gcn" / "full-joint" / "result.json").unlink()
        with self.assertRaisesRegex(ExportError, "incomplete measured cohort"):
            export(results, protocol, repo, self.case / "missing-measured-output",
                   model_domain_evidence=evidence)
        self.assertFalse((self.case / "missing-measured-output").exists())

    def test_malformed_exclusion_and_mixed_v4_network_reject(self) -> None:
        repo, protocol, results, evidence = make_domain_exception_fixture(self.case / "bad-protocol")
        data = json.loads(protocol.read_text())
        data["model_domain_exclusions"]["raytracing"]["task"] = "Task_12"
        write_json(protocol, data)
        with self.assertRaisesRegex(ExportError, "Raytracing exclusion must name Task_13"):
            export(results, protocol, repo, self.case / "bad-protocol-output",
                   model_domain_evidence=evidence)

        repo, protocol, results, evidence = make_domain_exception_fixture(self.case / "legacy-namespace")
        data = json.loads(protocol.read_text())
        data["model_namespace"] = "fixture-model-namespace"
        write_json(protocol, data)
        with self.assertRaisesRegex(ExportError, "requires the direct 2x2 model namespace"):
            export(results, protocol, repo, self.case / "legacy-namespace-output",
                   model_domain_evidence=evidence)

        repo, protocol, results, evidence = make_domain_exception_fixture(self.case / "incomplete-shapes")
        data = json.loads(protocol.read_text())
        data["search"]["later_shapes"] = data["search"]["later_shapes"][:-1]
        write_json(protocol, data)
        with self.assertRaisesRegex(ExportError, "exactly eight supported mapper shapes"):
            export(results, protocol, repo, self.case / "incomplete-shapes-output",
                   model_domain_evidence=evidence)

        repo, protocol, results, evidence = make_domain_exception_fixture(self.case / "mixed-network")
        binding_path = results / "harris" / "full-joint" / "source-binding.json"
        binding = json.loads(binding_path.read_text())
        binding["inter_task_network_text"] += "tampered: true\n"
        write_json(binding_path, binding)
        with self.assertRaisesRegex(ExportError, "source binding network bytes mismatch"):
            export(results, protocol, repo, self.case / "mixed-network-output",
                   model_domain_evidence=evidence)

        repo, protocol, results, evidence = make_domain_exception_fixture(self.case / "mixed-schema")
        result = json.loads((results / "gcn" / "full-joint" / "result.json").read_text())
        checkpoint = Path(result["checkpoint"])
        binding_path = checkpoint.with_name(checkpoint.name + ".binding.json")
        binding = json.loads(binding_path.read_text())
        binding["checkpoint_contract"] = "orbit-neighborhood-search-checkpoint-v2"
        write_json(binding_path, binding)
        with self.assertRaisesRegex(ExportError, "checkpoint schema differs across cohort"):
            export(results, protocol, repo, self.case / "mixed-schema-output",
                   model_domain_evidence=evidence)

    def test_main_na_plot_and_fission_supplement_plot_are_separate(self) -> None:
        repo, protocol, results, evidence = make_domain_exception_fixture(self.case / "plot-main")
        main_output = self.case / "plot-main-output"
        export(results, protocol, repo, main_output, render_plots=True,
               plot_script=WORK_ROOT / "scripts/plot_input0_neighborhood_ablation.py",
               model_domain_evidence=evidence)
        main_csv = main_output / "plots/input0-ablation-values.csv"
        with main_csv.open(newline="") as source:
            main_rows = {row["workload"]: row for row in csv.DictReader(source)}
        self.assertEqual([main_rows["Raytracing"][f"S{i}"] for i in range(1, 5)],
                         ["", "", "", ""])
        self.assertTrue((main_output / "plots/input0-ablation-normalized.png").is_file())
        main_svg = (main_output / "plots/input0-ablation-normalized.svg").read_text()
        self.assertIn("Raytracing", main_svg)
        self.assertIn("N/A", main_svg)

        repo, protocol, results = make_fixture(self.case / "plot-fission")
        data = json.loads(protocol.read_text())
        data["experiment_kind"] = "ray-fission-supplement"
        data["workloads_in_delivery_order"] = ["Raytracing"]
        data["model_domain_exclusions"] = {}
        write_json(protocol, data)
        bind_v4_network(repo, protocol, results)
        for workload in ("llama", "lu", "harris", "radar", "gcn"):
            shutil.rmtree(results / workload)
        fission_output = self.case / "plot-fission-output"
        fission_result = export(results, protocol, repo, fission_output, render_plots=True,
                                plot_script=WORK_ROOT / "scripts/plot_input0_neighborhood_ablation.py")
        self.assertEqual(fission_result["cell_count"], 4)
        fission_plot = fission_output / "plots/input0-ray-fission-supplement-normalized.svg"
        self.assertTrue(fission_plot.is_file())
        self.assertIn("fission", fission_plot.read_text().lower())
        fission_csv = fission_output / "plots/input0-ray-fission-supplement-values.csv"
        with fission_csv.open(newline="") as source:
            fission_rows = list(csv.DictReader(source))
        self.assertEqual(len(fission_rows), 1)
        self.assertEqual(fission_rows[0]["workload"], "Raytracing · fission")
        self.assertTrue(all(fission_rows[0][f"S{i}"] for i in range(1, 5)))


if __name__ == "__main__":
    unittest.main()
