from __future__ import annotations

import json
from pathlib import Path
import os
import subprocess
import sys
import tempfile
import unittest

HERE = Path(__file__).resolve().parents[1]
PREPARE = HERE / "scripts/prepare_input0_neighborhood_reproduction.py"
NUMERIC = HERE / "scripts/run_input0_numeric.py"
CONTRACT = HERE / "scripts/write_neighborhood_source_contract.py"


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
    def test_prepare_substitutes_tokens_preserves_model_cache_and_rejects_mismatch(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "artifact"
            template = root / "reference/input0-neighborhood/templates"
            model_dir = template / ".work/formal-model-nohash-v2-trained-rerun"
            for directory in (
                template / "config",
                model_dir,
                template / "reference/input0-neighborhood/numeric",
            ):
                directory.mkdir(parents=True)
            ensemble = '{"checkpoints":{"baseline":{"path":"baseline.json"},"large-operation":{"path":"large-operation.json"},"ranking":{"path":"ranking.json"}},"root":"${ARTIFACT_ROOT}"}\n'
            checkpoints = {
                "baseline.json": '{"kind":"baseline","source":"${ORBIT_SRC}"}\n',
                "large-operation.json": '{"kind":"large","build":"${ORBIT_BUILD}"}\n',
                "ranking.json": '{"kind":"ranking","llvm":"${LLVM_BUILD}"}\n',
            }
            (model_dir / "ensemble.json").write_text(ensemble)
            for name, text in checkpoints.items():
                (model_dir / name).write_text(text)
            cache = {
                "schema": "orbit-cgra-ii-ml-cache-v2",
                "model_schema": "m",
                "feature_contract_id": "f",
                "architecture_contract": "a",
                "resource_contract": {
                    "ensemble_text": ensemble,
                    "checkpoint_texts": [
                        {"name": "baseline", "text": checkpoints["baseline.json"]},
                        {"name": "large-operation", "text": checkpoints["large-operation.json"]},
                        {"name": "ranking", "text": checkpoints["ranking.json"]},
                    ],
                },
                "entries": [],
            }
            (template / ".work/input0-task-ml-cache.json").parent.mkdir(parents=True, exist_ok=True)
            (template / ".work/input0-task-ml-cache.json").write_text(json.dumps(cache, indent=2) + "\n")
            (template / "config/input0-chain.json").write_text(
                "${ARTIFACT_ROOT}|${ORBIT_SRC}|${ORBIT_BUILD}|${LLVM_BUILD}|${LLVM_SOURCE}|${AMOEBA_TEST_ROOT}\n"
            )
            (template / "reference/input0-neighborhood/numeric/input0_reference_runtime.h").write_text("header\n")
            (template / "reference/input0-neighborhood/numeric/lu_reference.cpp").write_text("source\n")
            source = Path(temporary) / "orbit-source"
            build = Path(temporary) / "orbit-build"
            llvm = Path(temporary) / "llvm-build"
            llvm_source = Path(temporary) / "llvm-source"
            amoeba_test = Path(temporary) / "amoeba-test"
            for path in (source, build, llvm, llvm_source, amoeba_test):
                path.mkdir()
            result = run_script(
                PREPARE,
                "--artifact-root",
                str(root),
                "--source-root",
                str(source),
                "--build-root",
                str(build),
                "--llvm-build",
                str(llvm),
                "--llvm-source",
                str(llvm_source),
                "--amoeba-test-root",
                str(amoeba_test),
                "--prepare-only",
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            chain = (root / "config/input0-chain.json").read_text()
            for path in (root, source, build, llvm, llvm_source, amoeba_test):
                self.assertIn(str(path.resolve()), chain)
            installed_ensemble = (root / ".work/formal-model-nohash-v2-trained-rerun/ensemble.json").read_text()
            installed_cache = json.loads((root / ".work/input0-task-ml-cache.json").read_text())
            self.assertEqual(installed_cache["resource_contract"]["ensemble_text"], installed_ensemble)
            by_name = {item["name"]: item["text"] for item in installed_cache["resource_contract"]["checkpoint_texts"]}
            self.assertEqual(by_name["baseline"], (model_dir / "baseline.json").read_text().replace("${ORBIT_SRC}", str(source.resolve())))
            self.assertTrue((root / ".work/selected-native-numeric-gate/run_input0_numeric.py").is_file())

            # The minimal publication ships model inputs, without cached predictions.
            (root / ".work/input0-task-ml-cache.json").unlink()
            (template / ".work/input0-task-ml-cache.json").unlink()
            cold = run_script(PREPARE, "--artifact-root", str(root),
                              "--source-root", str(source), "--build-root", str(build),
                              "--llvm-build", str(llvm), "--llvm-source", str(llvm_source),
                              "--amoeba-test-root", str(amoeba_test), "--prepare-only")
            self.assertEqual(cold.returncode, 0, cold.stderr)
            self.assertFalse((root / ".work/input0-task-ml-cache.json").exists())

            destination = root / "config/input0-chain.json"
            destination.write_text("pre-existing mismatched bytes\n")
            rejected = run_script(
                PREPARE,
                "--artifact-root",
                str(root),
                "--source-root",
                str(source),
                "--build-root",
                str(build),
                "--llvm-build",
                str(llvm),
                "--amoeba-test-root",
                str(amoeba_test),
                "--prepare-only",
            )
            self.assertNotEqual(rejected.returncode, 0)
            self.assertEqual(destination.read_text(), "pre-existing mismatched bytes\n")

    def test_prepare_rejects_unset_template_tokens_before_installing(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "artifact"
            template = Path(temporary) / "templates"
            template.mkdir()
            (template / "unresolved.txt").write_text("${MISSING_ROOT}\n")
            result = run_script(
                PREPARE,
                "--artifact-root",
                str(root),
                "--template-root",
                str(template),
                "--prepare-only",
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse((root / "unresolved.txt").exists())

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
