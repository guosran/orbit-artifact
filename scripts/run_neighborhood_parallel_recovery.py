#!/usr/bin/env python3
"""Recover one workload using the frozen chain's stage and replay interfaces.

Workers own disjoint workload directories. Their progress records are separate
from the serial coordinator's record; the latter can reconcile finished stages
on its next invocation. Search, candidate selection and costs remain in C++.
"""
from __future__ import annotations

import argparse
from dataclasses import replace
import json
from pathlib import Path
import sys

import run_neighborhood_stage_chain as chain


def run(command_file: Path, workload: str, jobs: int) -> int:
    command = json.loads(command_file.read_text(encoding="utf-8"))
    if not isinstance(command, list):
        raise chain.ChainError("chain command must be a JSON argv array")
    index = next((i for i, arg in enumerate(command)
                  if Path(str(arg)).name == "run_neighborhood_stage_chain.py"), None)
    if index is None:
        raise chain.ChainError("frozen chain script missing from argv")
    original, config_path = chain._parse_args(command[index + 1:])
    options = replace(original, jobs=jobs)
    chain._validate_options(options)
    if workload not in original.workloads:
        raise chain.ChainError("workload is outside the frozen batch")
    config = chain.load_config(config_path)
    config["config_base"] = str(config_path.parent.resolve())
    base = config_path.parent.resolve()
    manifest = chain._ensure_contract_snapshot(
        original.output_root, chain._contract_specs(config, original, config_base=base))
    entry = chain._merged_workload(config, workload)
    progress = original.output_root / "parallel" / workload / "progress.json"
    state = {"schema": "orbit-neighborhood-parallel-recovery-v1",
             "workload": workload, "jobs": jobs, "status": "running",
             "contract_manifest": str(manifest), "stages": {},
             "started_utc": chain.now(), "subprocess_timeout": None}
    chain.atomic_write(progress, state)
    previous = None
    failed = False
    for stage in chain.STAGES:
        directory = original.output_root / workload / stage
        directory.mkdir(parents=True, exist_ok=True)
        record = state["stages"].setdefault(stage, {})
        if failed:
            record.update(status="blocked", reason="earlier stage failed")
            chain.atomic_write(progress, state)
            continue
        try:
            expected = chain.expected_binding(entry, workload, stage, original,
                                              config_base=base, contract_manifest=manifest)
            binding = directory / "chain-binding.json"
            if binding.exists() and not chain._stage_binding_matches(binding, expected):
                raise chain.ChainError("stage binding differs from frozen batch")
            if not binding.exists() and any((directory / name).exists()
                                            for name in ("result.json", "checkpoint.json", "search")):
                raise chain.ChainError("existing stage lacks its binding")
            chain.atomic_write(binding, expected)
            complete, result = chain._stage_complete(directory, expected)
            if not complete:
                search_done = chain._search_artifacts_complete(directory)
                resume = (directory / "checkpoint.json").is_file() and not search_done
                argv = chain._build_replay_command(
                    workload=workload, stage=stage, entry=entry, options=options,
                    config_base=base, stage_dir=directory, previous_winner=previous,
                    resume=resume, skip_search=search_done)
                label = chain._next_label(directory, "replay-parallel")
                command_record = chain._run_logged(argv, directory, label)
                record["command"] = command_record
                if command_record.get("exit_code") != 0:
                    raise chain.ChainError("replay process failed; see recorded stderr")
                result = chain.read_json(directory / "result.json")
                if result.get("status") != "native_replayed":
                    raise chain.ChainError("required native replay evidence is incomplete")
            previous = chain.write_winner(directory, result)
            result = dict(result)
            result["winner_path"] = str(previous)
            chain.atomic_write(directory / "result.json", result)
            record.update(status="reused" if complete else "complete",
                          result=str(directory / "result.json"),
                          actual_stage_cycles=result.get("actual_stage_cycles"),
                          winner_path=str(previous))
        except (chain.ChainError, OSError, ValueError) as error:
            record.update(status="failed", reason=f"{type(error).__name__}: {error}")
            failed = True
        state["updated_utc"] = chain.now()
        chain.atomic_write(progress, state)
    state.update(status="incomplete" if failed else "complete", ended_utc=chain.now())
    chain.atomic_write(progress, state)
    return 2 if failed else 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--chain-command-file", type=Path, required=True)
    parser.add_argument("--workload", choices=chain.WORKLOADS, required=True)
    parser.add_argument("--jobs", type=int, default=4)
    args = parser.parse_args()
    try:
        return run(args.chain_command_file, args.workload, args.jobs)
    except (chain.ChainError, OSError, ValueError) as error:
        print(f"parallel recovery failed: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
