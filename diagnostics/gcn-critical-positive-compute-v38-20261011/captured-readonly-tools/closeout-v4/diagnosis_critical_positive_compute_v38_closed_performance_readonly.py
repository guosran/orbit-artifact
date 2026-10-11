#!/usr/bin/env python3
"""Report closed GCN search costs from receipts; perform no search or mapping."""
import argparse
import hashlib
import json
from pathlib import Path
import re

BASE = Path(__file__).resolve().parent / "diagnosis/search-regression-repair-20261010"
SOURCE = "76345481683a2e199c0cad155de2acb51149f350"


def sha(path):
    digest = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def require(condition, message):
    if not condition:
        raise ValueError(message)


def usage_fields(text):
    fields = {}
    names = {
        "search_user_seconds": "User time (seconds)",
        "search_system_seconds": "System time (seconds)",
        "maximum_rss_kib": "Maximum resident set size (kbytes)",
        "gnu_time_filesystem_outputs_raw": "File system outputs",
    }
    for name, label in names.items():
        match = re.search(r"^\s*" + re.escape(label) + r":\s*(\S+)\s*$", text, re.M)
        require(match is not None, "Missing GNU time field: " + label)
        fields[name] = float(match[1]) if name.endswith("seconds") else int(match[1])
    match = re.search(r"Elapsed \(wall clock\) time \(h:mm:ss or m:ss\):\s*(\S+)", text)
    require(match is not None, "Missing wall time")
    seconds = 0.0
    for component in match[1].split(":"):
        seconds = seconds * 60 + float(component)
    fields["search_wall_seconds"] = seconds
    return fields


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    require(not args.output.exists(), "Preserve prior report; use a new output directory")
    inputs = {str(Path(__file__).resolve()): sha(__file__)}

    def load(path):
        path = Path(path).resolve()
        digest = sha(path)
        value = json.loads(path.read_text())
        require(sha(path) == digest, "Receipt changed while reading: " + str(path))
        inputs[str(path)] = digest
        return value

    rows = []
    for label, stage in (("replica", "replica"), ("full", "fission")):
        unit = BASE / f"critical-positive-compute-v38-{label}256-continuation1/runs/b256/gcn" / stage
        completion = load(unit / "completion.json")
        require(completion["status"] == "pass-targeted-diagnostic"
                and completion["source_commit"] == SOURCE
                and completion["actual_objective_calls"] == 256
                and completion["extra_objective_calls"] == 0
                and completion["native_evaluated"] == completion["numeric_validated"] == 5
                and completion["certified_scheduler_rejected"] == 0,
                "Original exact256/five outcomes are not closed: " + label)
        for path, digest in completion["artifact_hashes"].items():
            require(sha(path) == digest, "Closed artifact differs: " + path)
            require(path not in inputs or inputs[path] == digest, "Conflicting artifact: " + path)
            inputs[path] = digest
        audit = load(unit / "search-audit.json")
        require(audit["status"] == "pass" and audit["source_commit"] == SOURCE
                and audit["objective_calls"] == 256 and audit["stage"] == stage,
                "Search audit differs: " + label)
        usage = unit / "usage.txt"
        inputs[str(usage)] = sha(usage)
        attempts, zero = audit["exact_semantic_attempts"], audit["zero_debit_attempts"]
        require(attempts - zero == 255, "Bootstrap/charged attempt accounting differs")
        rows.append(dict(domain=stage, native_cycles=completion["native_cycles"], objective_calls=256,
                         candidate_semantic_attempts=attempts, zero_debit_attempts=zero,
                         zero_debit_fraction=zero / attempts, charged_candidate_attempts=255,
                         bootstrap_objective_calls=1,
                         communication_window_paid=audit["retained_communication_shape_charges"],
                         communication_windows=len(audit["retained_communication_windows"]),
                         paid_critical_compute_shapes=len(audit["first_tier_guided_paid"]),
                         **usage_fields(usage.read_text())))
    for path, digest in inputs.items():
        require(sha(path) == digest, "Input changed after analysis: " + path)
    report = dict(schema="orbit-v38-gcn-closed-pair-performance-readonly-v1",
                  status="verified-isolated-research", source_commit=SOURCE, rows=rows,
                  full_over_replica_search_wall_ratio=rows[1]["search_wall_seconds"] / rows[0]["search_wall_seconds"],
                  additional_objective_calls=0, additional_native_calls=0, additional_numeric_calls=0,
                  paper_admission=False, input_sha256=inputs,
                  limitations=[
                      "These searches were admitted in parallel on this host; timings are observations, not an isolated stage profile or controlled cross-version speed comparison.",
                      "Zero-debit attempts include legality rejection and duplicates; their number alone does not justify removing checks.",
                      "GNU time filesystem outputs are raw block accounting, not retained file sizes or physical disk bandwidth.",
                  ])
    args.output.mkdir(parents=True)
    report_path = args.output / "REPORT.json"
    report_path.write_text(json.dumps(report, indent=2) + "\n")
    seal = dict(status="pass", report_sha256=sha(report_path), input_pre_post_verified=True,
                source_commit=SOURCE, extra_objective_calls=0, native_calls=0, numeric_calls=0)
    (args.output / "FINAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    print(json.dumps(dict(status="pass", rows=rows, report_sha256=sha(report_path))))


if __name__ == "__main__":
    main()
