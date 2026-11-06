#!/usr/bin/env python3
"""Independent measurement/accounting view; no production planning or fitting."""
import argparse
import hashlib
import json
from pathlib import Path
from statistics import median


def identity(path):
    return {"path": str(path.resolve()), "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}


def main():
    ap = argparse.ArgumentParser(__doc__)
    ap.add_argument("--measurement", type=Path, required=True)
    ap.add_argument("--query", type=Path, required=True)
    ap.add_argument("--case", required=True)
    ap.add_argument("--output", type=Path, required=True)
    a = ap.parse_args()
    assert not a.output.exists(), "output must be new"
    facts = json.loads((a.query / "facts.json").read_text())
    cost = json.loads((a.query / "cost.json").read_text())
    receipt = json.loads((a.query / "receipt.json").read_text())
    protocol = json.loads((a.measurement / "protocol.json").read_text())
    case = next(c for c in protocol["cases"] if c["id"] == a.case)
    artifact = json.loads(Path(case["artifact"]["path"]).read_text())
    assert facts["binding"]["artifact_sha256"] == artifact["elf_sha256"] == receipt["artifact_sha256"]
    assert facts["elements"] == case["fixture"]["elements"]
    assert facts["tile_elements"] == case["fixture"]["chunk"]
    assert cost["status"] == "predicted" and not cost["complete_program_cost"]
    assert cost["owner_scope"] == "submit-to-successful-wait-return"
    assert not cost["separately_charge_native_dma"]
    samples = [json.loads(s) for s in (a.measurement / "samples.jsonl").read_text().splitlines()]
    samples = [s for s in samples if s["case"] == a.case and not s["warmup"]]
    assert samples
    rows = []
    for s in samples:
        assert all(check["passed"] for check in s["checks"].values())
        events = s["events"]
        start = [e for e in events if e["kind"] == "actual_xrt_start"]
        wait = [e for e in events if e["kind"] == "actual_xrt_wait"]
        sync = [e for e in events if e["kind"] == "actual_bo_sync"]
        assert len(start) == len(wait) == 1 and len(sync) == 3
        assert "TO_DEVICE" in sync[0]["direction"] and "TO_DEVICE" in sync[1]["direction"]
        assert "FROM_DEVICE" in sync[2]["direction"]
        assert sync[0]["end_ns"] <= sync[1]["start_ns"] <= start[0]["start_ns"]
        assert start[0]["end_ns"] <= wait[0]["start_ns"] <= wait[0]["end_ns"] <= sync[2]["start_ns"]
        span = wait[0]["end_ns"] - start[0]["start_ns"]
        assert span == s["dispatch_to_wait_end_ns"]
        sync_ns = sum(e["end_ns"] - e["start_ns"] for e in sync)
        remainder = s["runner_wall_ns"] - span - sync_ns
        assert remainder >= 0
        rows.append(dict(seed=s["seed"], repeat=s["repeat"], wall_ns=s["runner_wall_ns"],
                         completion_ns=span, observed_sync_ns=sync_ns,
                         observed_other_runner_ns=remainder,
                         completion_prediction_ns=cost["duration_ns"],
                         completion_error_ns=cost["duration_ns"] - span))
    a.output.mkdir(parents=True)
    summary = dict(schema="orbit.device-delivery.accounting-view.v15", case=a.case,
                   samples=len(rows), receipts={n: identity(a.query / n) for n in
                       ["facts.json", "cost.json", "receipt.json"]},
                   measurement=identity(a.measurement / "samples.jsonl"),
                   medians={k: median(r[k] for r in rows) for k in rows[0] if k not in ["seed", "repeat"]},
                   note="Medians of components need not sum to the median wall; each sample partitions exactly.",
                   whole_program_prediction_ns=None, physical_bytes=None,
                   unpriced=["TO/FROM sync under this new observer/context/ABI condition",
                             "outside-completion runner bookkeeping and dispatch",
                             "input generation/reset, output validation and evidence I/O outside runner wall",
                             "one-time context/BO/file/toolchain preparation"],
                   rule="Do not add a v14 fixed API price from a different condition; no compute/DMA/start/wait double charge.",
                   rows=rows)
    (a.output / "summary.json").write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    chosen = next(s for s in samples if s["seed"] == 11)
    origin = min(e["start_ns"] for e in chosen["events"])
    trace = {"displayTimeUnit": "ns", "traceEvents": [dict(name=e["kind"] + ":" + e.get("direction", ""),
              cat="host-observed API, not device trace", ph="X", pid=1, tid=1,
              ts=(e["start_ns"] - origin) / 1000, dur=(e["end_ns"] - e["start_ns"]) / 1000,
              args={"clock": "host perf_counter_ns", "device_interval": False}) for e in chosen["events"]]}
    (a.output / "host-api-perfetto.json").write_text(json.dumps(trace, indent=2) + "\n")
    print(json.dumps({"status": "passed", "samples": len(rows), "complete_cost": None}))


if __name__ == "__main__":
    main()
