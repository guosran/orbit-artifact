#!/usr/bin/env python3
"""Preserve C++ evidence for the explicitly excluded original Ray program."""
from __future__ import annotations

import argparse
import json
from pathlib import Path

import neighborhood_replay as replay
import run_neighborhood_stage_chain as chain


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--chain-command-file", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    argv = json.loads(args.chain_command_file.read_text())
    index = next(i for i, value in enumerate(argv)
                 if Path(value).name == "run_neighborhood_stage_chain.py")
    options, config_path = chain._parse_args(argv[index + 1:])
    chain._validate_options(options)
    protocol = chain.read_json(options.protocol)
    exclusion = protocol.get("model_domain_exclusions", {}).get("raytracing")
    if (not exclusion or exclusion.get("task") != "Task_13"
            or exclusion.get("model_interval_max_ii") != 20
            or protocol.get("model_namespace") != "orbit-per-cgra-2x2-direct-4member-v1"):
        raise ValueError("requires the explicit original-Ray direct-model exclusion")
    config = chain.read_json(config_path)
    entry = config["workloads"]["raytracing"]
    canonical = (config_path.parent / entry["canonical"]).resolve()
    catalog = (config_path.parent / entry["parent_cost_file"]).resolve()
    cache = (config_path.parent / entry["cost_cache"]).resolve()
    model = (config_path.parent / config["defaults"]["model_cache"]).resolve()
    output = args.output.resolve()
    if output.exists():
        raise ValueError("refusing to replace existing exclusion evidence")
    preflight = output.parent / "model-domain-preflight"
    if preflight.exists():
        raise ValueError("preflight directory must be fresh")
    preflight.mkdir(parents=True)
    command = replay.build_search_command(
        optimizer=options.optimizer, canonical=canonical, output_dir=preflight,
        function=replay.infer_function(canonical, None), stage=chain.protocol_stages(protocol)[0],
        architecture=options.architecture, protocol=protocol,
        checkpoint=preflight / "checkpoint.json", seed_manifest=None,
        previous_winner=None, parent_cost_file=catalog, model_cache=model,
        cost_cache=cache, max_rounds=options.max_rounds,
        max_candidates=options.max_candidates, beam_width=options.beam_width,
        diversity_slots=options.diversity_slots, resume=None,
        protocol_path=options.protocol, source_contract_file=options.source_contract_file,
        workload="raytracing", inter_task_network=options.inter_task_network)
    execution = replay._run_logged(command, preflight, "cpp-preflight")
    diagnostic = next((line for line in Path(execution["stderr"]).read_text().splitlines()
                       if "error:" in line), "")
    expected = "task has no supported model shape for canonical identity: Task_13"
    if execution["exit_code"] == 0 or expected not in diagnostic:
        raise ValueError("C++ did not establish the required model-domain exclusion: " + diagnostic)
    costs = chain.read_json(catalog)
    queries = [entry for entry in costs["entries"] if entry.get("task") == "Task_13"]
    fabric = protocol["fabric"]
    shapes = {(rows * fabric["per_cgra_pe_rows"], cols * fabric["per_cgra_pe_columns"])
              for rows, cols in protocol["search"]["later_shapes"]}
    actual = {(entry["mapper_tile_rows"], entry["mapper_tile_cols"]) for entry in queries}
    if len(queries) != 8 or actual != shapes or any(
            entry.get("status") != "unsupported-model-domain"
            or entry.get("support_status") != "unsupported"
            or entry.get("model_interval_max_ii") != 20
            or entry.get("analytical_lower_bound", 0) <= 20
            or "predicted_ii" in entry for entry in queries):
        raise ValueError("C++ catalogue does not prove all eight shapes outside the interval")
    binding = replay.source_binding(protocol, canonical, options.optimizer,
                                    options.architecture, model, cache, catalog,
                                    options.source_contract_file, options.inter_task_network)
    paths = {"canonical_program": canonical, "cost_catalog": catalog,
             "source_contract_file": options.source_contract_file,
             "architecture": options.architecture, "ensemble": model,
             "inter_task_network": options.inter_task_network, "protocol": options.protocol}
    witness = costs["predictor_metadata"]["canonical_module_witness"]
    evidence = {
        "schema": "orbit-model-domain-exclusion-evidence-v1",
        "status": "proved_outside_model_interval", "workload": "raytracing",
        "task": "Task_13", "model_namespace": costs["namespace"],
        "model_interval_max_ii": 20, "canonical_task_witness": witness,
        "canonical_module_witness": witness, "source_binding": binding,
        **{key: str(path) for key, path in paths.items()},
        "exact_payloads": {key: {"path": str(path), "exact_bytes": path.read_text()}
                           for key, path in paths.items()},
        "queries": queries, "preflight_command": command,
        "exit_code": execution["exit_code"], "failure_diagnostic": diagnostic,
        "native_cycles": None, "formal_go": False,
    }
    replay.atomic_write(output, evidence)
    print(json.dumps({"output": str(output), "status": evidence["status"],
                      "unsupported_shapes": len(queries)}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
