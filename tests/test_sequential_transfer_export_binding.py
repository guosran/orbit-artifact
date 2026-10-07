import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import run_sequential_comparison as comparison
from show_sequential_budget_transfer import audit_supplement_bindings


class TransferExportBindingTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        base = Path(self.temporary.name)
        self.main, self.root, self.runtime = (base / n for n in ("main", "supplement", "runtime"))
        self.script = self.runtime / "scripts/validate.py"
        self.script.parent.mkdir(parents=True)
        self.script.write_text("# frozen validation script\n")
        self.dependency = base / "native-reference.so"
        self.dependency.write_bytes(b"native reference fixture")
        payloads = [{"path": "scripts/validate.py", "text": self.script.read_text()}]
        self.main_contract = self.main / "source-contract.json"
        self.write(self.main_contract, {"replay_payloads": payloads})
        contract = self.runtime / "source-contract.json"
        self.write(contract, {"replay_payloads": payloads})
        self.write(self.main / "validation-payload-binding.json", {
            "source_contract": comparison.file_binding(self.main_contract),
            "files": {"scripts/validate.py": comparison.file_binding(self.script),
                      "native-reference.so": comparison.file_binding(self.dependency)}})
        manifest = self.runtime / "budget-transfer-runtime.json"
        self.write(manifest, {"schema": "orbit-sequential-budget-transfer-runtime-v1",
            "base_contract": comparison.file_binding(self.main_contract),
            "runtime_bindings": [comparison.file_binding(contract)]})
        self.write(self.root / "queue-binding.json", {
            "runtime_bindings": [comparison.file_binding(manifest)]})
        self.write(self.root / "protocol.json", {
            "experiment_kind": "sequential-budget-transfer-supplement",
            "decision_flow_comparison": {"sequential_budget_policy": "transfer-unused"}})
        self.write(self.root / "experiment-plan.json", {
            "source_contract": str(contract), "coordinator_payloads": []})
        self.cell = self.root / "gcn/sequential-50-transfer"
        binding = {"content_binding": {"source_contract": comparison.file_binding(contract)}}
        for name in ("comparison-binding.json", "search-input-binding.json"):
            self.write(self.cell / name, binding)

    @staticmethod
    def write(path, value):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(value))

    def audit(self):
        return audit_supplement_bindings(self.main, self.root, [("gcn", "sequential-50-transfer")])

    def test_pre_run_contract_suffices_without_retrospective_sidecar(self):
        result = self.audit()
        self.assertIn("post-run", result["policy"])
        self.assertFalse((self.root / "validation-payload-binding.json").exists())

    def test_changed_validation_script_fails(self):
        self.script.write_text("# changed script\n")
        with self.assertRaisesRegex(ValueError, "validation script differs"):
            self.audit()

    def test_changed_native_tool_dependency_fails(self):
        self.dependency.write_bytes(b"changed reference")
        with self.assertRaisesRegex(ValueError, "字节绑定"):
            self.audit()

    def test_runtime_manifest_must_have_been_bound_before_launch(self):
        self.write(self.root / "queue-binding.json", {"runtime_bindings": []})
        with self.assertRaisesRegex(ValueError, "did not bind"):
            self.audit()

    def test_search_and_comparison_binding_must_match(self):
        self.write(self.cell / "search-input-binding.json", {})
        with self.assertRaisesRegex(ValueError, "input bindings differ"):
            self.audit()


if __name__ == "__main__":
    unittest.main()
