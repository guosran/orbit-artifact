from __future__ import annotations

import json
import importlib.util
from pathlib import Path
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

HERE = Path(__file__).resolve().parents[1]
PREPARE = HERE / "scripts/prepare_input0_neighborhood_reproduction.py"
NUMERIC = HERE / "scripts/run_input0_numeric.py"
CONTRACT = HERE / "scripts/write_neighborhood_source_contract.py"
COMMAND = HERE / "scripts/write_neighborhood_publication_command.py"


def run_script(script: Path, *args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(script), *args],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )


def write_executable(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)
    path.chmod(0o755)


class Input0NeighborhoodPortabilityTests(unittest.TestCase):
    def test_source_contract_discovers_affine_to_taskflow_conversion_scope(self) -> None:
        spec = importlib.util.spec_from_file_location("source_contract_fixture", CONTRACT)
        self.assertIsNotNone(spec)
        self.assertIsNotNone(spec.loader)
        contract = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(contract)
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "source"
            relative = "lib/Conversion/AffineToTaskflow/RepairLuAffineDeterminantCarryPass.cpp"
            source = root / relative
            source.parent.mkdir(parents=True)
            source.write_text("// exact LU carry-repair source\n")
            discovered = contract._source_paths(root, Path(temporary) / "source-list.json")
            self.assertIn("lib/Conversion/AffineToTaskflow", contract.SCOPES)
            self.assertIn(relative, discovered)

    def test_prepare_regenerates_source_domains_without_legacy_templates(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "artifact"
            shutil.copytree(HERE / "reference/input0-source-domains",
                            root / "reference/input0-source-domains")
            shutil.copytree(HERE / "reference/input0-neighborhood/numeric",
                            root / "reference/input0-neighborhood/numeric")
            shutil.copytree(HERE / "reference/input0-neighborhood/reference-source",
                            root / "reference/input0-neighborhood/reference-source")
            (root / "scripts").mkdir(parents=True)
            (root / "config/architectures").mkdir(parents=True)
            shutil.copy(HERE / "config/architectures/amoeba_4x4_full_mesh_context12.yaml",
                        root / "config/architectures/amoeba_4x4_full_mesh_context12.yaml")
            shutil.copy(HERE / "scripts/prepare_input0_source_domains.py", root / "scripts/prepare_input0_source_domains.py")
            template = root / "reference/input0-neighborhood/templates"
            template.mkdir(parents=True)
            (template / "old-v11-seed.jsonl").write_text("must not be read\n")
            model_dir = root / "reference/input0-neighborhood/models"
            model_dir.mkdir(parents=True)
            (model_dir / "ensemble.json").write_text(json.dumps({"checkpoints": {
                "baseline": {"path": "baseline.json"},
                "large-operation": {"path": "large-operation.json"},
                "ranking": {"path": "ranking.json"},
            }}))
            for name in ("baseline.json", "large-operation.json", "ranking.json"):
                (model_dir / name).write_text("fixture model payload\n")
            optimizer = Path(temporary) / "optimizer"
            write_executable(optimizer, "#!/bin/sh\nexit 0\n")
            output = root / ".work/source-domain-dry-run"
            result = run_script(
                PREPARE,
                "--artifact-root", str(root),
                "--optimizer", str(optimizer),
                "--model-root", str(model_dir),
                "--output-root", str(output),
                "--workloads", "llama",
                "--dry-run",
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            preparation = json.loads((output / "preparation.json").read_text())
            self.assertEqual(preparation["status"], "dry-run")
            self.assertTrue(preparation["allow_unsupported_model_shapes"])
            self.assertTrue(preparation["cost_catalog_generation_planned"])
            self.assertFalse(preparation["cost_catalogs_regenerated"])
            self.assertFalse(preparation["numeric_reference_libraries_built"])
            self.assertFalse(preparation["llama_harness_installed"])
            self.assertEqual(preparation["workloads"], ["llama"])
            config = json.loads((output / "input0-chain.json").read_text())
            self.assertEqual(config["schema"], "orbit-amoeba-input0-neighborhood-chain-config-v1")
            self.assertEqual(set(config["workloads"]), {"llama"})
            self.assertEqual(config["workloads"]["llama"]["canonical"], "llama/canonical.mlir")
            self.assertNotIn("seed_manifest", config["workloads"]["llama"])
            plan = json.loads((output / "llama/plan.json").read_text())
            cost_command = next(
                arg for arg in plan["steps"]["predict-cost-catalog"]
                if arg.startswith("--predict-analytical-task-cost-catalog=")
            )
            self.assertIn("allow-unsupported-above-model-ceiling=true", cost_command)
            self.assertTrue((template / "old-v11-seed.jsonl").is_file())
            self.assertFalse((root / ".work/cpp-gate-continuation-agent").exists())

    def test_prepare_does_not_fall_back_to_models_in_legacy_template(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "artifact"
            legacy = root / "reference/input0-neighborhood/templates/.work/formal-model-nohash-v2-trained-rerun"
            legacy.mkdir(parents=True)
            for name in ("ensemble.json", "baseline.json", "large-operation.json", "ranking.json"):
                (legacy / name).write_text("legacy only\n")
            result = run_script(PREPARE, "--artifact-root", str(root), "--dry-run")
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("portable model bundle", result.stderr)
            self.assertFalse((root / ".work/input0-neighborhood-v19/source-domain-prep").exists())

    def test_command_writer_binds_fresh_source_metadata_and_keeps_paths_portable(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            base = Path(temporary)
            artifact = base / "artifact"
            source = base / "orbit-source"
            source.mkdir()
            subprocess.run(["git", "init", "-q", str(source)], check=True)
            subprocess.run(["git", "-C", str(source), "config", "user.email", "fixture@example.invalid"], check=True)
            subprocess.run(["git", "-C", str(source), "config", "user.name", "Fixture"], check=True)
            source_file = source / "src.cpp"
            source_file.write_text("// source base\n")
            subprocess.run(["git", "-C", str(source), "add", "src.cpp"], check=True)
            subprocess.run(["git", "-C", str(source), "commit", "-q", "-m", "base"], check=True)
            source_base = subprocess.check_output(["git", "-C", str(source), "rev-parse", "HEAD"], text=True).strip()
            source_file.write_text("// current source\n")
            subprocess.run(["git", "-C", str(source), "add", "src.cpp"], check=True)
            subprocess.run(["git", "-C", str(source), "commit", "-q", "-m", "current"], check=True)
            source_head = subprocess.check_output(["git", "-C", str(source), "rev-parse", "HEAD"], text=True).strip()

            build = artifact / ".work/build"
            build.mkdir(parents=True)
            optimizer = build / "mlir-amoeba-opt"
            write_executable(optimizer, "#!/bin/sh\nexit 0\n")
            architecture = artifact / "config/architectures/amoeba_4x4_full_mesh_context12.yaml"
            architecture.parent.mkdir(parents=True)
            architecture.write_text("fixture architecture\n")
            model = artifact / "reference/input0-neighborhood/models"
            model.mkdir(parents=True)
            (model / "ensemble.json").write_text(json.dumps({"checkpoints": {
                "baseline": {"path": "baseline.json"},
                "large-operation": {"path": "large-operation.json"},
                "ranking": {"path": "ranking.json"},
            }}) + "\n")
            for name in ("baseline.json", "large-operation.json", "ranking.json"):
                (model / name).write_text("fixture model payload\n")
            config = artifact / ".work/source-domain/input0-chain.json"
            config.parent.mkdir(parents=True)
            config.write_text(json.dumps({
                "schema": "orbit-amoeba-input0-neighborhood-chain-config-v1",
                "defaults": {"model_cache": os.path.relpath(model / "ensemble.json", config.parent)},
                "workloads": {
                    workload: {
                        "canonical": f"{workload}/canonical.mlir",
                        "parent_cost_file": f"{workload}/cost-catalog.json",
                        "cost_cache": f"{workload}/ml-cache.json",
                    }
                    for workload in ("llama", "lu", "gcn", "harris", "radar", "raytracing")
                },
            }))
            protocol_template = artifact / "reference/input0-neighborhood/protocol-template.json"
            protocol_template.parent.mkdir(parents=True, exist_ok=True)
            protocol = {
                "schema": "orbit-amoeba-input0-neighborhood-v3",
                "source_commit": "a57376e7043b1681e64e7169c5a8cb02eb192331",
                "source_variant": "historical-v17-label",
                "optimizer_pin": "old local path",
                "source_contract_file": "old local path",
                "model_ensemble": "old model location",
                "search": {
                    "max_rounds": 4,
                    "max_unique_complete_candidates_scored": 4096,
                    "beam_width": 16,
                    "diversity_min_slots": 4,
                    "native_shortlist": 5,
                    "supported_shape_bootstrap_policy": "minimum-area-supported-model-shape-v1",
                },
                "source_iteration_domain": {"required": True},
                "execution": {"workload_lanes": 3, "cpus_per_lane": 4, "max_host_cores": 12},
            }
            protocol_template.write_text(json.dumps(protocol, indent=2) + "\n")
            original_template = protocol_template.read_text()
            source_contract = artifact / ".work/source-domain/source-model-contract.json"
            source_contract.parent.mkdir(parents=True, exist_ok=True)
            source_contract.write_text(json.dumps({
                "published_source_commit": source_head,
                "source_commit": protocol["source_commit"],
            }) + "\n")
            (architecture.parent / "amoeba_4x4_vectorcgra_sram.json").write_text("{}\n")
            output_root = artifact / "results/input0-neighborhood-v19-replay"
            bound_protocol = artifact / ".work/source-domain/protocol-bound.json"
            command_file = artifact / ".work/source-domain/chain-command.json"
            result = run_script(
                COMMAND,
                "--artifact-root", str(artifact),
                "--source-root", str(source),
                "--build-root", str(build),
                "--source-base", source_base,
                "--source-variant", "corrected-source-domains-v19",
                "--config", str(config),
                "--protocol-template", str(protocol_template),
                "--protocol-output", str(bound_protocol),
                "--source-contract-file", str(source_contract),
                "--optimizer", str(optimizer),
                "--architecture", str(architecture),
                "--model-root", str(model),
                "--output-root", str(output_root),
                "--output", str(command_file),
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(protocol_template.read_text(), original_template)
            bound = json.loads(bound_protocol.read_text())
            self.assertEqual(bound["stage_scheme"], "merged-spatial-temporal")
            self.assertEqual(bound["stage_order"], ["shape-temporal", "shape-temporal-replica",
                             "shape-temporal-replica-tiling", "full-joint"])
            self.assertEqual([stage["stage"] for stage in bound["stages"]], [1, 2, 3, 4])
            self.assertTrue(all(stage["dispatch"] == "critical-path" and
                                stage["scheduling_mode"] == "spatial-temporal"
                                for stage in bound["stages"]))
            self.assertEqual(bound["source_commit"], "a57376e7043b1681e64e7169c5a8cb02eb192331")
            self.assertEqual(bound["project_source_commit"], source_head)
            self.assertEqual(bound["project_source_base"], source_base)
            self.assertEqual(bound["source_variant"], "corrected-source-domains-v19")
            self.assertNotIn("/home/", bound_protocol.read_text())
            argv = json.loads(command_file.read_text())
            self.assertEqual(argv[1], "scripts/run_neighborhood_stage_chain.py")
            self.assertEqual(argv[argv.index("--config") + 1], ".work/source-domain/input0-chain.json")
            self.assertEqual(argv[argv.index("--output-root") + 1], "results/input0-neighborhood-v19-replay")
            self.assertEqual(argv[argv.index("--max-candidates") + 1], "4096")
            self.assertEqual(argv[argv.index("--workloads") + 1:argv.index("--jobs")],
                             ["llama", "lu", "gcn", "harris", "radar", "raytracing"])
            self.assertNotIn("/home/", command_file.read_text())

    def test_command_writer_rejects_historical_seed_inputs(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            # The validator is intentionally exercised without Git or a build:
            # a v19 config cannot silently carry an old seed manifest.
            spec = importlib.util.spec_from_file_location("publication_command_fixture", COMMAND)
            self.assertIsNotNone(spec)
            self.assertIsNotNone(spec.loader)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            config = {
                "schema": "orbit-amoeba-input0-neighborhood-chain-config-v1",
                "workloads": {
                    workload: {
                        "canonical": f"{workload}/canonical.mlir",
                        "parent_cost_file": f"{workload}/cost-catalog.json",
                        "cost_cache": f"{workload}/ml-cache.json",
                    }
                    for workload in ("llama", "lu", "gcn", "harris", "radar", "raytracing")
                },
            }
            config["workloads"]["llama"]["seed_manifest"] = "historical-seeds.jsonl"
            with self.assertRaisesRegex(module.CommandError, "cannot import historical seed inputs"):
                module.validate_chain_config(config)

    def test_ray_domain_exclusion_preserves_main_scope_and_separate_fission(self) -> None:
        spec = importlib.util.spec_from_file_location("publication_domain_fixture", COMMAND)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        protocol = json.loads((HERE / "reference/input0-neighborhood/protocol-2x2-direct-model-template.json").read_text())
        reported, measured = module.protocol_workloads(protocol)
        self.assertEqual(set(reported), set(module.WORKLOADS))
        self.assertEqual(set(measured), set(module.WORKLOADS) - {"raytracing"})
        protocol["model_domain_exclusions"]["llama"] = protocol["model_domain_exclusions"]["raytracing"]
        with self.assertRaisesRegex(module.CommandError, "only the declared Ray"):
            module.protocol_workloads(protocol)
        supplement = json.loads((HERE / "reference/input0-neighborhood/protocol-2x2-ray-fission-template.json").read_text())
        self.assertEqual(module.protocol_workloads(supplement), (["raytracing"], ["raytracing"]))
        supplement["model_domain_exclusions"] = {"raytracing": {"status": "unsupported_model_domain"}}
        with self.assertRaisesRegex(module.CommandError, "native-source direct 2x2"):
            module.protocol_workloads(supplement)

    def test_numeric_errors_fail_but_expected_negative_control_passes(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "artifact"
            llvm = root / "llvm"
            (llvm / "bin").mkdir(parents=True)
            (llvm / "lib").mkdir()
            (llvm / "lib/libmlir_runner_utils.so").write_bytes(b"fixture")
            libs = root / ".work/selected-native-numeric-gate"
            libs.mkdir(parents=True)
            (libs / "liblu_reference.so").write_bytes(b"fixture")
            native = root / "native/rank-0"
            native.mkdir(parents=True)
            (native / "native.mlir").write_text("module {}\n")
            failing = Path(temporary) / "failing-optimizer"
            write_executable(failing, "#!/usr/bin/env python3\nraise SystemExit(7)\n")
            failed = run_script(
                NUMERIC,
                "--artifact-root",
                str(root),
                "--llvm-build",
                str(llvm),
                "--reference-root",
                str(libs),
                "--optimizer",
                str(failing),
                "--native-root",
                str(root / "native"),
                "--workloads",
                "lu",
                "--stage",
                "failure",
                "--jobs",
                "1",
            )
            self.assertNotEqual(failed.returncode, 0)
            failure_record = json.loads((root / "results/input0-cpp-numeric-gates/lu/failure-rank-0/result.json").read_text())
            self.assertEqual(failure_record["status"], "incomplete")

            optimizer = Path(temporary) / "optimizer"
            mlir_opt = llvm / "bin/mlir-opt"
            mlir_runner = llvm / "bin/mlir-runner"
            copy_output = """#!/usr/bin/env python3
import pathlib, sys
out = pathlib.Path(sys.argv[sys.argv.index('-o') + 1])
out.write_text('module {}\\n')
"""
            write_executable(optimizer, copy_output)
            write_executable(mlir_opt, copy_output)
            write_executable(
                mlir_runner,
                "#!/usr/bin/env python3\nimport sys\nsys.stderr.write('ORBIT_NUMERIC_RESULT mismatches=1 comparisons=4 actual_nonzero=2 expected_nonzero=2\\n')\n",
            )
            negative = run_script(
                NUMERIC,
                "--artifact-root",
                str(root),
                "--llvm-build",
                str(llvm),
                "--reference-root",
                str(libs),
                "--optimizer",
                str(optimizer),
                "--native-root",
                str(root / "native"),
                "--workloads",
                "lu",
                "--stage",
                "negative",
                "--negative-control",
                "--jobs",
                "1",
            )
            self.assertEqual(negative.returncode, 0)
            negative_record = json.loads((root / "results/input0-cpp-numeric-gates/lu/negative-rank-0-negative-control/result.json").read_text())
            self.assertEqual(negative_record["status"], "pass")
            self.assertEqual(negative_record["mismatches"], 1)

            regular_mismatch = run_script(
                NUMERIC,
                "--artifact-root",
                str(root),
                "--llvm-build",
                str(llvm),
                "--reference-root",
                str(libs),
                "--optimizer",
                str(optimizer),
                "--native-root",
                str(root / "native"),
                "--workloads",
                "lu",
                "--stage",
                "regular-mismatch",
                "--jobs",
                "1",
            )
            self.assertNotEqual(regular_mismatch.returncode, 0)
            mismatch_record = json.loads((root / "results/input0-cpp-numeric-gates/lu/regular-mismatch-rank-0/result.json").read_text())
            self.assertEqual(mismatch_record["status"], "fail")
            self.assertEqual(mismatch_record["mismatches"], 1)

            write_executable(
                mlir_runner,
                "#!/usr/bin/env python3\nimport sys\nsys.stderr.write('ORBIT_NUMERIC_RESULT mismatches=0 comparisons=4 actual_nonzero=2 expected_nonzero=2\\n')\nraise SystemExit(9)\n",
            )
            crashed = run_script(
                NUMERIC, "--artifact-root", str(root), "--llvm-build", str(llvm),
                "--reference-root", str(libs), "--optimizer", str(optimizer),
                "--native-root", str(root / "native"), "--workloads", "lu",
                "--stage", "failed-after-marker", "--jobs", "1",
            )
            self.assertNotEqual(crashed.returncode, 0)
            crashed_record = json.loads((root / "results/input0-cpp-numeric-gates/lu/failed-after-marker-rank-0/result.json").read_text())
            self.assertEqual(crashed_record["status"], "incomplete")

    def test_contract_embeds_fixture_source_and_model_bytes(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            base = Path(temporary)
            artifact = base / "artifact"
            source = base / "source"
            model = base / "model"
            source_file = source / "lib/Backend/Neura/Orchestration/Fixture.cpp"
            source_file.parent.mkdir(parents=True)
            source_text = "// exact fixture payload\n"
            source_file.write_text(source_text)
            source_list = artifact / "reference/input0-neighborhood/source-file-list.json"
            source_list.parent.mkdir(parents=True)
            source_list.write_text(json.dumps({"files": ["lib/Backend/Neura/Orchestration/Fixture.cpp"]}) + "\n")
            model.mkdir(parents=True)
            model_files = {
                "ensemble.json": json.dumps({"checkpoints": {"baseline": {"path": "baseline.json"}, "large-operation": {"path": "large-operation.json"}, "ranking": {"path": "ranking.json"}}}) + "\n",
                "baseline.json": "baseline exact\n",
                "large-operation.json": "large exact\n",
                "ranking.json": "ranking exact\n",
            }
            for name, text in model_files.items():
                (model / name).write_text(text)
            for relative in (
                "scripts/neighborhood_replay.py",
                "scripts/run_neighborhood_stage_chain.py",
                "scripts/render_neighborhood_table.py",
                "scripts/replay_cpp_global_top5.py",
                "scripts/validate_embedded_native_trace.py",
                "scripts/run_input0_numeric.py",
                "scripts/run_input0_all_unit_baselines.py",
                "scripts/run_input0_original_amoeba_baselines.py",
                "scripts/validate_original_amoeba_fixed_retiming.py",
                "config/architectures/amoeba_4x4_vectorcgra_sram.json",
            ):
                path = artifact / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(f"fixture:{relative}\n")
            optimizer = artifact / ".work/mainline-tools/mlir-amoeba-opt-v9-neighborhood"
            optimizer.parent.mkdir(parents=True)
            optimizer.write_text("optimizer\n")
            output = artifact / "contract.json"
            result = run_script(
                CONTRACT,
                "--artifact-root",
                str(artifact),
                "--source-root",
                str(source),
                "--model-root",
                str(model),
                "--optimizer",
                str(optimizer),
                "--output",
                str(output),
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            contract = json.loads(output.read_text())
            self.assertEqual(contract["source_commit"], "a57376e7043b1681e64e7169c5a8cb02eb192331")
            self.assertIn("published_source_commit", contract)
            self.assertEqual(contract["sources"], [{"path": "lib/Backend/Neura/Orchestration/Fixture.cpp", "text": source_text}])
            self.assertEqual({item["path"] for item in contract["model_payloads"]}, set(model_files))
            replay = {item["path"]: item["text"] for item in contract["replay_payloads"]}
            self.assertEqual(replay["scripts/run_input0_numeric.py"], "fixture:scripts/run_input0_numeric.py\n")
            self.assertNotIn("sha256", contract)
            self.assertNotIn("hash", contract)


if __name__ == "__main__":
    unittest.main()
