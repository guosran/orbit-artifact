#!/usr/bin/env python3
"""Replay an existing winner through the existing full-joint action registry.

This invokes no search, predictor, scheduler or mapper. The existing replay pass
uses the complete post-initial-round menu (round=1), so replay success proves
materialization/source-proof reachability, not original beam retention or budget
reachability.
"""
import argparse
import json
from pathlib import Path
import subprocess
import time

import neighborhood_replay as replay
import run_sequential_comparison as comparison
from sequential_validation_audit import require_complete_validation


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cell", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--prefix-lengths", type=int, nargs="+", default=[3])
    args = parser.parse_args()
    cell, output = args.cell.resolve(), args.output_dir.resolve()
    output.mkdir(parents=True, exist_ok=False)
    binding = comparison.read(cell / "comparison-binding.json")
    result = comparison.read(cell / "result.json")
    require_complete_validation(result)
    winner = min(result["native_top5"]["records"] + result["native_controls"]["records"],
                 key=lambda r: r["native_cycles"])
    selected = next(r for r in result["top5"] + result["controls"]
                    if (r["candidate_id"], r["rank"]) == (winner["candidate_id"], winner["rank"]))
    history = selected["action_history"]
    if not history["known"]:
        raise ValueError("winner lacks authenticated typed history")
    canonical = Path(binding["inputs"]["canonical"])
    optimizer = Path(binding["optimizer"])
    for role, path in (("canonical", canonical), ("optimizer", optimizer)):
        if comparison.file_binding(path) != binding["content_binding"][role]:
            raise ValueError("changed bound replay input: " + role)
    function = replay.infer_function(canonical, binding["inputs"].get("function"))
    records = []
    for length in sorted(set(args.prefix_lengths + [len(history["actions"])])):
        if not 0 < length <= len(history["actions"]):
            raise ValueError("invalid prefix length")
        action_path = output / f"prefix-{length}.actions.json"
        actions = dict(schema="orbit-joint-neighborhood-typed-actions-v1",
            canonicalInput=str(canonical), candidateInput=str(canonical), function=function,
            stage="full-joint", maxPartitionFactor=8, initialShapes=history["initialShapes"],
            actions=history["actions"][:length])
        action_path.write_text(json.dumps(actions, indent=2) + "\n")
        target = output / f"prefix-{length}"
        options = " ".join([f"action-file={action_path}", f"canonical-input={canonical}",
            f"candidate-input={canonical}", f"function={function}", "stage=full-joint",
            "max-partition-factor=8", f"output-dir={target}"])
        command = [str(optimizer), str(canonical), "--allow-unregistered-dialect",
                   "--replay-joint-neighborhood-actions=" + options, "-o", "/dev/null"]
        started = time.time()
        with (output / f"prefix-{length}.stdout.log").open("w") as stdout, (output / f"prefix-{length}.stderr.log").open("w") as stderr:
            code = subprocess.call(command, stdout=stdout, stderr=stderr)
        facts = comparison.read(target / "source-facts.json") if (target / "source-facts.json").exists() else None
        verified_endpoint = bool(facts and facts.get("source_iteration_domain_verified") is True and
            facts.get("action_history", {}).get("actions") == history["actions"][:length] and
            all(facts.get(key) is False for key in ("prediction_run", "native_mapping_run", "ranking_performed", "cost_catalog_read")))
        if length == len(history["actions"]):
            verified_endpoint = verified_endpoint and facts.get("action_history") == history and facts.get("shapes") == selected["shapes"]
        records.append(dict(prefix_length=length, command=command, exit_code=code,
            elapsed_seconds=time.time() - started, action_file_binding=comparison.file_binding(action_path),
            endpoint_history_and_resources_verified=verified_endpoint,
            source_facts=facts, output_bindings=[comparison.file_binding(p) for p in sorted(target.rglob("*")) if p.is_file()]))
        comparison.replay.atomic_write(output / "replay.json", dict(
            schema="orbit-sequential-winner-path-replay-v1", candidate_id=winner["candidate_id"],
            native_cycles=winner["native_cycles"], original_search_budget_unchanged=True,
            extra_objective_evaluations=0, extra_predictor_queries=0, extra_mapper_calls=0,
            input_bindings=[comparison.file_binding(p) for p in (canonical, optimizer, cell / "result.json")],
            limitation="replay menu round=1 per step; no claim about original per-round beam retention or objective budget",
            records=records))
        if code:
            raise ValueError(f"prefix {length} replay failed; retained logs at {output}")
        if not verified_endpoint:
            raise ValueError(f"prefix {length} replay facts differ from authenticated history/resources; retained evidence at {output}")
    print(json.dumps({"candidate_id": winner["candidate_id"], "replayed_prefix_lengths": [r["prefix_length"] for r in records],
        "extra_objective_evaluations": 0, "extra_mapper_calls": 0, "evidence": str(output / "replay.json")}))


if __name__ == "__main__":
    main()
