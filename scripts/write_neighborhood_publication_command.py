#!/usr/bin/env python3
"""Write a fresh, source-bound v19 launch command without editing its template.

The output command is a local run artifact. Candidate generation, legality,
ranking, and archive ordering remain in the C++ optimizer.
"""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
from typing import Any, Mapping, Sequence

ROOT = Path(__file__).resolve().parents[1]
WORKLOADS = ("llama", "lu", "gcn", "harris", "radar", "raytracing")
V19_SEARCH = {
    "max_rounds": 4,
    "max_unique_complete_candidates_scored": 4096,
    "beam_width": 16,
    "diversity_min_slots": 4,
    "native_shortlist": 5,
    "supported_shape_bootstrap_policy": "minimum-area-supported-model-shape-v1",
}
MODEL_COST_SOURCE_COMMIT = "a57376e7043b1681e64e7169c5a8cb02eb192331"
MODEL_FILES = ("ensemble.json", "baseline.json", "large-operation.json", "ranking.json")


class CommandError(RuntimeError):
    """The requested launch profile is not portable or not v19-shaped."""


def read_json(path: Path, label: str) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text())
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise CommandError(f"cannot read {label} {path}: {error}") from error
    if not isinstance(value, dict):
        raise CommandError(f"{label} must be a JSON object: {path}")
    return value


def git_value(source_root: Path, *args: str) -> str:
    process = subprocess.run(
        ["git", "-C", str(source_root), *args],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if process.returncode:
        detail = process.stderr.strip() or process.stdout.strip()
        raise CommandError(f"git {' '.join(args)} failed in {source_root}: {detail}")
    return process.stdout.strip()


def require_ancestor(source_root: Path, base: str, head: str) -> None:
    process = subprocess.run(
        ["git", "-C", str(source_root), "merge-base", "--is-ancestor", base, head],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if process.returncode:
        detail = process.stderr.strip()
        suffix = f": {detail}" if detail else ""
        raise CommandError(f"source base {base} is not an ancestor of source HEAD {head}{suffix}")


def portable_binding(path: Path, artifact_root: Path, source_root: Path,
                     build_root: Path) -> str:
    resolved = path.resolve()
    for base, token in (
        (artifact_root, "${ARTIFACT_ROOT}"),
        (source_root, "${ORBIT_SRC}"),
        (build_root, "${ORBIT_BUILD}"),
    ):
        try:
            relative = resolved.relative_to(base.resolve())
        except ValueError:
            continue
        return f"{token}/{relative.as_posix()}"
    raise CommandError(
        f"path is outside ARTIFACT_ROOT, ORBIT_SRC, and ORBIT_BUILD: {resolved}"
    )


def runtime_path(path: Path, artifact_root: Path) -> str:
    """Use cwd-relative artifact paths in the local argv file when possible."""
    resolved = path.resolve()
    try:
        return resolved.relative_to(artifact_root.resolve()).as_posix()
    except ValueError:
        return str(resolved)


def validate_v19_protocol(protocol: Mapping[str, Any]) -> dict[str, Any]:
    if protocol.get("schema") != "orbit-amoeba-input0-neighborhood-v3":
        raise CommandError("protocol schema must be orbit-amoeba-input0-neighborhood-v3")
    search = protocol.get("search")
    if not isinstance(search, dict):
        raise CommandError("protocol has no search object")
    for key, expected in V19_SEARCH.items():
        if search.get(key) != expected:
            raise CommandError(f"v19 search.{key} must be {expected!r}")
    domain = protocol.get("source_iteration_domain")
    if not isinstance(domain, dict) or domain.get("required") is not True:
        raise CommandError("v19 protocol must require source-iteration-domain proofs")
    execution = protocol.get("execution")
    if not isinstance(execution, dict):
        raise CommandError("protocol has no execution object")
    expected_execution = {"workload_lanes": 3, "cpus_per_lane": 4, "max_host_cores": 12}
    for key, expected in expected_execution.items():
        if execution.get(key) != expected:
            raise CommandError(f"v19 execution.{key} must be {expected}")
    return search


def validate_chain_config(config: Mapping[str, Any],
                          workloads: Sequence[str] = WORKLOADS) -> list[str]:
    if config.get("schema") != "orbit-amoeba-input0-neighborhood-chain-config-v1":
        raise CommandError("chain config must use the source-domain chain schema")
    entries = config.get("workloads")
    if not isinstance(entries, dict) or set(entries) != set(workloads):
        raise CommandError(f"chain config must contain exactly {list(workloads)}")
    for workload in workloads:
        entry = entries[workload]
        if not isinstance(entry, dict):
            raise CommandError(f"chain config entry is not an object: {workload}")
        missing = {"canonical", "parent_cost_file", "cost_cache"} - set(entry)
        if missing:
            raise CommandError(f"{workload} lacks fresh source-domain inputs: {sorted(missing)}")
        expected_paths = {
            "canonical": f"{workload}/canonical.mlir",
            "parent_cost_file": f"{workload}/cost-catalog.json",
            "cost_cache": f"{workload}/ml-cache.json",
        }
        for key, expected in expected_paths.items():
            if entry.get(key) != expected:
                raise CommandError(
                    f"{workload}.{key} must name its fresh source-domain output {expected!r}"
                )
        forbidden = {"seed_manifest", "historical_native_winner", "seed_index"} & set(entry)
        if forbidden:
            raise CommandError(
                f"v19 chain config cannot import historical seed inputs for {workload}: "
                f"{sorted(forbidden)}"
            )
        extra = set(entry) - {"canonical", "parent_cost_file", "cost_cache"}
        if extra:
            raise CommandError(f"{workload} has unsupported source-domain config fields: {sorted(extra)}")
    return list(workloads)


def protocol_workloads(protocol: Mapping[str, Any]) -> tuple[list[str], list[str]]:
    """Separate reported cells from measured chains using explicit protocol scope."""
    names = protocol.get("workloads_in_delivery_order", list(WORKLOADS))
    if not isinstance(names, list) or any(not isinstance(name, str) for name in names):
        raise CommandError("protocol workloads must be a list of names")
    all_workloads = [name.lower() for name in names]
    supplement = protocol.get("experiment_kind") == "ray-fission-supplement"
    expected = {"raytracing"} if supplement else set(WORKLOADS)
    if set(all_workloads) != expected or len(all_workloads) != len(expected):
        raise CommandError("protocol workload scope is incomplete or duplicated")
    excluded = protocol.get("model_domain_exclusions", {})
    if not isinstance(excluded, dict) or set(excluded) - {"raytracing"}:
        raise CommandError("only the declared Ray model-domain exception is supported")
    if excluded and (supplement or protocol.get("model_namespace") !=
                     "orbit-per-cgra-2x2-direct-4member-v1"):
        raise CommandError("Ray exclusion requires the native-source direct 2x2 cohort")
    for entry in excluded.values():
        if (not isinstance(entry, dict) or entry.get("status") != "unsupported_model_domain"
                or entry.get("task") != "Task_13"
                or entry.get("model_interval_max_ii") != 20):
            raise CommandError("Ray exclusion must declare Task_13 beyond model II 20")
    return all_workloads, [name for name in all_workloads if name not in excluded]


def validate_model_bundle(model_root: Path) -> Path:
    ensemble = model_root / "ensemble.json"
    try:
        value = json.loads(ensemble.read_text())
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise CommandError(f"cannot read portable model ensemble {ensemble}: {error}") from error
    if value.get("schema") == "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1":
        if (not isinstance(value.get("members"), list) or len(value["members"]) != 4
                or not isinstance(value.get("feature_contract", {}).get("feature_names"), list)
                or len(value["feature_contract"]["feature_names"]) != 148
                or not isinstance(value.get("architecture", {}).get("exact_yaml_text"), str)
                or not value["architecture"]["exact_yaml_text"]
                or not isinstance(value.get("model_namespace"), str)):
            raise CommandError("direct 2x2 portable ensemble has an incomplete contract")
        return ensemble
    checkpoints = value.get("checkpoints")
    if not isinstance(checkpoints, dict) or set(checkpoints) != {
        "baseline", "large-operation", "ranking"
    }:
        raise CommandError("portable ensemble must name baseline, large-operation, and ranking")
    expected = set(MODEL_FILES) - {"ensemble.json"}
    found: set[str] = set()
    for name, record in checkpoints.items():
        relative_text = record.get("path") if isinstance(record, dict) else None
        if not isinstance(relative_text, str):
            raise CommandError(f"portable model path is missing: {name}")
        relative = Path(relative_text)
        if relative.as_posix() != f"{name}.json":
            raise CommandError(f"portable checkpoint binding is unexpected for {name}: {relative_text}")
        if relative.is_absolute() or ".." in relative.parts or relative.name not in expected:
            raise CommandError(f"portable model path escapes its bundle: {relative_text}")
        path = (model_root / relative).resolve()
        try:
            path.relative_to(model_root.resolve())
        except ValueError as error:
            raise CommandError(f"portable model path escapes its bundle: {relative_text}") from error
        if not path.is_file():
            raise CommandError(f"portable model checkpoint is missing: {path}")
        found.add(relative.name)
    if found != expected:
        raise CommandError("portable model checkpoint set is incomplete")
    return ensemble


def write_exact(path: Path, payload: str, label: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() or path.is_symlink():
        if path.is_symlink() or not path.is_file() or path.read_text() != payload:
            raise CommandError(f"refusing to overwrite a different {label}: {path}")
        return
    temporary = path.with_name(path.name + f".partial-{os.getpid()}")
    try:
        temporary.write_text(payload)
        os.replace(temporary, path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifact-root", type=Path, default=ROOT)
    parser.add_argument("--source-root", type=Path)
    parser.add_argument("--build-root", type=Path)
    parser.add_argument("--source-base", required=True,
                        help="Git commit/ref the published ORBIT source change is based on")
    parser.add_argument("--source-variant", required=True,
                        help="fresh public source variant label; do not reuse a v17 label")
    parser.add_argument("--config", type=Path, required=True,
                        help="fresh chain config written by the source-domain preparer")
    parser.add_argument("--protocol-template", type=Path, required=True,
                        help="immutable profile template from the active experiment")
    parser.add_argument("--protocol-output", type=Path, required=True,
                        help="newly bound protocol path; must differ from the template")
    parser.add_argument("--source-contract-file", type=Path, required=True)
    parser.add_argument("--optimizer", type=Path)
    parser.add_argument("--architecture", type=Path)
    parser.add_argument("--sram-config", type=Path)
    parser.add_argument("--inter-task-network", type=Path)
    parser.add_argument("--model-root", type=Path)
    parser.add_argument("--mapping-cache", type=Path)
    parser.add_argument("--output-root", type=Path, required=True,
                        help="fresh results namespace for this source/protocol binding")
    parser.add_argument("--output", type=Path,
                        help="local JSON argv file; defaults below .work/input0-neighborhood-v19")
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    artifact_root = args.artifact_root.resolve()
    source_value = args.source_root or os.environ.get("ORBIT_SRC")
    if not source_value:
        raise CommandError("pass --source-root or set ORBIT_SRC to the built ORBIT source checkout")
    source_root = Path(source_value).resolve()
    if not source_root.is_dir():
        raise CommandError("pass --source-root or set ORBIT_SRC to the built ORBIT source checkout")
    build_value = args.build_root or os.environ.get("ORBIT_BUILD")
    if not build_value:
        raise CommandError("pass --build-root or set ORBIT_BUILD to the optimizer build directory")
    build_root = Path(build_value).resolve()
    if not build_root.is_dir():
        raise CommandError("pass --build-root or set ORBIT_BUILD to the optimizer build directory")
    optimizer_value = args.optimizer or os.environ.get("ORBIT_OPTIMIZER")
    if not optimizer_value:
        raise CommandError("pass --optimizer or set ORBIT_OPTIMIZER to an executable optimizer")
    optimizer = Path(optimizer_value).resolve()
    if not optimizer.is_file() or not os.access(optimizer, os.X_OK):
        raise CommandError("pass --optimizer or set ORBIT_OPTIMIZER to an executable optimizer")
    architecture = (args.architecture or artifact_root / "config/architectures/amoeba_4x4_full_mesh_context12.yaml").resolve()
    if not architecture.is_file():
        raise CommandError(f"architecture spec is missing: {architecture}")
    model_root = (args.model_root or artifact_root / "reference/input0-neighborhood/models").resolve()
    ensemble = validate_model_bundle(model_root)
    config_path = args.config.resolve()
    config = read_json(config_path, "chain config")
    defaults = config.get("defaults")
    if not isinstance(defaults, dict) or set(defaults) != {"model_cache"}:
        raise CommandError("chain config defaults must bind only the portable model ensemble")
    model_cache_value = defaults.get("model_cache")
    if not isinstance(model_cache_value, str):
        raise CommandError("chain config model_cache must be a path string")
    model_cache = Path(model_cache_value)
    if not model_cache.is_absolute():
        model_cache = config_path.parent / model_cache
    if model_cache.resolve() != ensemble.resolve():
        raise CommandError("chain config model_cache differs from the portable model ensemble")
    protocol_template = args.protocol_template.resolve()
    protocol_output = args.protocol_output.resolve()
    if protocol_template == protocol_output:
        raise CommandError("protocol output must be new; the active template is immutable")
    protocol = read_json(protocol_template, "protocol template")
    search = validate_v19_protocol(protocol)
    declared_workloads, workloads = protocol_workloads(protocol)
    validate_chain_config(config, declared_workloads)
    source_contract = args.source_contract_file.resolve()
    if not source_contract.is_file():
        raise CommandError(f"source contract is missing: {source_contract}")
    contract = read_json(source_contract, "source contract")
    model_metadata = read_json(ensemble, "model ensemble")
    if model_metadata.get("schema") == "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1":
        if model_metadata["architecture"]["exact_yaml_text"] != architecture.read_text():
            raise CommandError("architecture bytes differ from the direct 2x2 model")
        if contract.get("model_namespace") != model_metadata["model_namespace"]:
            raise CommandError("source contract model namespace differs from the direct 2x2 ensemble")
        expected_model = [{"path": "ensemble.json", "text": ensemble.read_text()}]
        if contract.get("model_payloads") != expected_model:
            raise CommandError("source contract model bytes differ from the direct 2x2 ensemble")
    if protocol.get("source_commit") != contract.get("source_commit"):
        raise CommandError("protocol source_commit differs from the exact source/model contract")
    contract_text = source_contract.read_text()
    if any(marker in contract_text for marker in ("/home/", "/Users/", "C:\\Users\\")):
        raise CommandError("source contract contains a machine-local absolute path")
    source_head = git_value(source_root, "rev-parse", "HEAD")
    source_base = git_value(source_root, "rev-parse", "--verify", f"{args.source_base}^{{commit}}")
    require_ancestor(source_root, source_base, source_head)
    dirty = bool(git_value(source_root, "status", "--porcelain", "--untracked-files=all"))
    if contract.get("published_source_commit") != source_head:
        raise CommandError(
            "source contract published_source_commit differs from ORBIT_SRC HEAD; "
            "regenerate the contract from this source checkout"
        )
    if "v17" in args.source_variant.lower() or "v11" in args.source_variant.lower():
        raise CommandError("source variant must identify the current source, not a historical v17/v11 run")

    config_base = config_path.parent.resolve()
    output_root = args.output_root.resolve()
    mapping_cache = (args.mapping_cache or artifact_root / ".work/input0-task-mapping-cache").resolve()
    mapping_cache.mkdir(parents=True, exist_ok=True)
    sram_config = (args.sram_config or artifact_root / "config/architectures/amoeba_4x4_vectorcgra_sram.json").resolve()
    if not sram_config.is_file():
        raise CommandError(f"SRAM configuration is missing: {sram_config}")
    protocol["project_source_commit"] = source_head
    protocol["active"] = True
    protocol["measured_workloads"] = workloads
    protocol["project_source_base"] = source_base
    protocol["source_variant"] = args.source_variant
    protocol["source_dirty_build"] = dirty
    protocol["project_source_checkout"] = "${ORBIT_SRC}"
    protocol["current_binary_build_source"] = "${ORBIT_SRC}"
    protocol["optimizer_pin"] = portable_binding(optimizer, artifact_root, source_root, build_root)
    protocol["source_contract_file"] = portable_binding(
        source_contract, artifact_root, source_root, build_root
    )
    protocol["model_ensemble"] = portable_binding(ensemble, artifact_root, source_root, build_root)
    protocol["canonical_program_pattern"] = portable_binding(
        config_base, artifact_root, source_root, build_root
    ) + "/<workload>/canonical.mlir"
    protocol["ML_cache"] = portable_binding(
        config_base, artifact_root, source_root, build_root
    ) + "/<workload>/ml-cache.json"
    protocol["publication_variant"] = "fresh corrected-domain source-owned reproduction"

    command = [
        sys.executable,
        "scripts/run_neighborhood_stage_chain.py",
        "--config", runtime_path(config_path, artifact_root),
        "--output-root", runtime_path(output_root, artifact_root),
        "--protocol", runtime_path(protocol_output, artifact_root),
        "--source-contract-file", runtime_path(source_contract, artifact_root),
        "--optimizer", runtime_path(optimizer, artifact_root),
        "--architecture", runtime_path(architecture, artifact_root),
        "--sram-config", runtime_path(sram_config, artifact_root),
        "--mapping-cache", runtime_path(mapping_cache, artifact_root),
        "--model-cache", runtime_path(ensemble, artifact_root),
        "--replay-script", "scripts/neighborhood_replay.py",
        "--table-script", "scripts/render_neighborhood_table.py",
        "--workloads", *workloads,
        # The coordinator replaces this serial placeholder with its per-lane
        # mapper job count. Search itself stays C++-owned.
        "--jobs", "1",
        "--max-rounds", str(search["max_rounds"]),
        "--max-candidates", str(search["max_unique_complete_candidates_scored"]),
        "--beam-width", str(search["beam_width"]),
        "--diversity-slots", str(search["diversity_min_slots"]),
    ]
    if args.inter_task_network:
        network_path = args.inter_task_network.resolve()
        if not network_path.is_file():
            raise CommandError(f"inter-task network configuration is missing: {network_path}")
        command.extend(("--inter-task-network", runtime_path(network_path, artifact_root)))
        protocol["inter_task_network_spec"] = portable_binding(network_path, artifact_root, source_root, build_root)
    protocol["model_namespace"] = contract.get("model_namespace", "formal-max4-nohash-v2-exploratory")
    serialized_protocol = json.dumps(protocol, indent=2, sort_keys=True) + "\n"
    if any(marker in serialized_protocol for marker in ("/home/", "/Users/", "C:\\Users\\")):
        raise CommandError("bound protocol contains a machine-local absolute path")
    serialized_command = json.dumps(command, indent=2) + "\n"
    write_exact(protocol_output, serialized_protocol, "bound protocol")
    command_output = (args.output or artifact_root / ".work/input0-neighborhood-v19/chain-command.json").resolve()
    write_exact(command_output, serialized_command, "launch command")
    print(json.dumps({
        "schema": "orbit-input0-neighborhood-v19-launch-command-v1",
        "command_file": str(command_output),
        "protocol_file": str(protocol_output),
        "output_root": str(output_root),
        "project_source_commit": source_head,
        "project_source_base": source_base,
        "source_dirty_build": dirty,
        "source_variant": args.source_variant,
        "workloads": workloads,
        "search_budget": {
            "max_rounds": search["max_rounds"],
            "max_unique_complete_candidates_scored": search["max_unique_complete_candidates_scored"],
            "beam_width": search["beam_width"],
            "native_shortlist": search["native_shortlist"],
        },
        "cpu_lanes": 3,
        "cpus_per_lane": 4,
        "batch_command": [
            sys.executable, "scripts/run_neighborhood_parallel_batch.py",
            "--chain-command-file", str(command_output),
            "--workers", "3", "--cpus-per-worker", "4", "--jobs-per-worker", "4",
        ],
    }, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (CommandError, OSError, ValueError, KeyError) as error:
        print(f"write_neighborhood_publication_command.py: {error}", file=sys.stderr)
        raise SystemExit(2)
    except KeyboardInterrupt:
        raise SystemExit(130)
