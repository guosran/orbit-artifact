#!/usr/bin/env python3
"""Write a portable, protocol-bound argv for the existing stage launcher."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--optimizer", type=Path, default=os.environ.get("ORBIT_OPTIMIZER"))
    parser.add_argument("--output-root", type=Path, default=Path("results/input0-neighborhood-publication"))
    parser.add_argument("--output", type=Path, default=Path(".work/input0-neighborhood-publication/chain-command.json"))
    args = parser.parse_args()
    if not args.optimizer:
        parser.error("set ORBIT_OPTIMIZER or pass --optimizer")
    optimizer = args.optimizer.resolve()
    if not optimizer.is_file():
        parser.error("optimizer is not a file")
    protocol = ROOT / ".work/input0-neighborhood-publication/protocol.json"
    document = json.loads(protocol.read_text())
    budget = document["search"]
    command = [sys.executable, str(ROOT / "scripts/run_neighborhood_stage_chain.py"),
               "--config", str(ROOT / ".work/input0-neighborhood-publication/input0-chain.json"),
               "--output-root", str(args.output_root.resolve()),
               "--protocol", str(protocol),
               "--source-contract-file", str(ROOT / ".work/input0-neighborhood-publication/source-model-contract.json"),
               "--optimizer", str(optimizer),
               "--architecture", str(ROOT / "config/architectures/amoeba_4x4_full_mesh_context12.yaml"),
               "--sram-config", str(ROOT / "config/architectures/amoeba_4x4_vectorcgra_sram.json"),
               "--mapping-cache", str(ROOT / ".work/input0-task-mapping-cache"),
               "--model-cache", str(ROOT / ".work/formal-model-nohash-v2-trained-rerun/ensemble.json"),
               "--cost-cache", str(ROOT / ".work/input0-task-ml-cache.json"),
               "--replay-script", str(ROOT / "scripts/neighborhood_replay.py"),
               "--table-script", str(ROOT / "scripts/render_neighborhood_table.py"),
               "--workloads", "llama", "lu", "harris", "radar", "gcn", "raytracing", "--jobs", "1",
               "--max-rounds", str(budget["max_rounds"]),
               "--max-candidates", str(budget["max_unique_complete_candidates_scored"]),
               "--beam-width", str(budget["beam_width"]),
               "--diversity-slots", str(budget["diversity_min_slots"])]
    payload = json.dumps(command, indent=2) + "\n"
    output = args.output.resolve()
    if output.exists() and output.read_text() != payload:
        raise ValueError("existing command binding differs; choose a new output file and results namespace")
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = output.with_name(output.name + ".partial")
    temporary.write_text(payload)
    temporary.replace(output)
    print(output)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, KeyError) as error:
        print(f"publication command failed: {error}", file=sys.stderr)
        raise SystemExit(2)
