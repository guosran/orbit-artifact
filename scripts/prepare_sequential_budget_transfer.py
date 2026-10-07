#!/usr/bin/env python3
"""Prepare an isolated replay runtime for the opt-in budget-transfer supplement."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess


def binding(path):
    payload = path.read_bytes()
    return {"path": str(path), "size": len(payload), "sha256": hashlib.sha256(payload).hexdigest()}


def replace_once(text, old, new):
    if text.count(old) != 1:
        raise ValueError("runtime patch anchor is not unique: " + old[:100])
    return text.replace(old, new, 1)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifact-root", type=Path, required=True)
    parser.add_argument("--base-runtime", type=Path, required=True)
    parser.add_argument("--base-contract", type=Path, required=True)
    parser.add_argument("--source-root", type=Path, required=True)
    parser.add_argument("--runtime-root", type=Path, required=True)
    args = parser.parse_args()
    artifact, base, original_contract, source, runtime = (path.resolve() for path in
        (args.artifact_root, args.base_runtime, args.base_contract, args.source_root, args.runtime_root))
    scripts = runtime / "scripts"
    if scripts.exists():
        raise FileExistsError("use a fresh replay runtime; do not replace bound scripts")
    scripts.mkdir(parents=True)
    for path in (base / "scripts").glob("*.py"):
        shutil.copyfile(path, scripts / path.name)
    for path in artifact.iterdir():
        if path.name in {".git", "scripts", "bin"} or (runtime / path.name).exists():
            continue
        (runtime / path.name).symlink_to(path, target_is_directory=path.is_dir())
    replay = scripts / "neighborhood_replay.py"
    text = replay.read_text()
    text = replace_once(text, '    if protocol.get("model_namespace"):\n',
        '    budget_policy = protocol.get("decision_flow_comparison", {}).get("sequential_budget_policy", "fixed-split")\n'
        '    if budget_policy not in {"fixed-split", "transfer-unused"}:\n'
        '        raise ContractError("unknown Sequential budget policy")\n'
        '    if budget_policy == "transfer-unused":\n'
        '        if decision_flow != "sequential":\n'
        '            raise ContractError("transfer-unused requires Sequential")\n'
        '        search_options.append("sequential-budget-policy=transfer-unused")\n'
        '    if protocol.get("model_namespace"):\n')
    replay.write_text(text)
    coordinator = scripts / "run_sequential_comparison.py"
    text = coordinator.read_text()
    text = replace_once(text, '           ("sequential-25", "sequential", 25), ("sequential-75", "sequential", 75))',
        '           ("sequential-25", "sequential", 25), ("sequential-75", "sequential", 75),\n'
        '           ("sequential-50-transfer", "sequential", 50))')
    text = replace_once(text, 'default=[m[0] for m in METHODS])',
        'default=[m[0] for m in METHODS if m[0] != "sequential-50-transfer"])')
    text = replace_once(text, '    contract = read(args.source_contract_file)\n',
        '    if "sequential-50-transfer" in args.methods:\n'
        '        if args.methods != ["sequential-50-transfer"]:\n'
        '            parser.error("transfer supplement uses a separate protocol and output namespace")\n'
        '        protocol["experiment_kind"] = "sequential-budget-transfer-supplement"\n'
        '        protocol["source_variant"] = "sequential-budget-transfer-v1"\n'
        '        protocol["scope"] = "Supplemental Sequential variant; original fixed 50/50 main results remain unchanged"\n'
        '        protocol["decision_flow_comparison"].update(\n'
        '            sequential_budget_policy="transfer-unused", sensitivity_graph_budget_percent=[],\n'
        '            stage_b_budget="nominal B plus unused nominal A only on no-new-legal-candidates",\n'
        '            comparison_role="supplemental variant; never substituted into the fixed 50/50 main table")\n'
        '    contract = read(args.source_contract_file)\n')
    coordinator.write_text(text)
    contract = json.loads(original_contract.read_text())
    changed = []
    for row in contract["sources"]:
        payload = (source / row["path"]).read_text()
        if payload != row["text"]:
            changed.append(row["path"])
        row["text"] = payload
    expected = ["lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp"]
    if changed != expected:
        raise ValueError("mapper/scheduler/rewrite source changed: " + str(changed))
    for row in contract["replay_payloads"]:
        row["text"] = (runtime / row["path"]).read_text()
    contract["published_source_commit"] = subprocess.check_output(
        ["git", "-C", str(source), "rev-parse", "HEAD"], text=True).strip()
    contract["source_dirty"] = True
    contract["immutable_optimizer_pin"] = "${ARTIFACT_ROOT}/bin/mlir-amoeba-opt"
    contract_path = runtime / "source-model-contract.json"
    contract_path.write_text(json.dumps(contract, separators=(",", ":")) + "\n")
    manifest = {"schema": "orbit-sequential-budget-transfer-runtime-v1", "source_root": str(source),
        "base_runtime": str(base), "base_contract": binding(original_contract),
        "changed_compiler_sources": changed,
        "model_payloads_unchanged": contract["model_payloads"] == json.loads(original_contract.read_text())["model_payloads"],
        "source_namespace_unchanged": contract["source_commit"],
        "replay_changes": "policy argument forwarding and supplemental label/protocol only; existing materializer/scheduler/native/numeric path retained",
        "runtime_bindings": [binding(path) for path in (replay, coordinator, contract_path)],
        "main_results_modified": False}
    (runtime / "budget-transfer-runtime.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps(manifest, indent=2))


if __name__ == "__main__":
    main()
