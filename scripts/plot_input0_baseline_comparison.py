#!/usr/bin/env python3
"""Plot admitted II20 input0 stages against preserved AMOEBA decisions."""

import argparse
import csv
import json
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

STAGES = ("shape-only", "shape-temporal", "shape-temporal-replica",
          "shape-temporal-replica-tiling", "full-joint")
WORKLOADS = (("gcn", "GCN"), ("harris", "Harris"), ("llama", "LLaMA"),
             ("lu", "LU"), ("radar", "Radar"))
ARCH = "config/architectures/amoeba_4x4_cgra_2x2_context6.yaml"
NET = "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml"
MODEL = "orbit-per-cgra-2x2-direct-4member-v1"
COLORS = ("#d55e00", "#0072b2", "#009e73", "#cc79a7", "#e69f00")


def read(path):
    return json.loads(path.read_text())


def positive_cycles(value):
    if type(value) is not int or value <= 0:
        raise ValueError("cycles must be a positive integer")
    return value


def load_rows(stages, baselines, supplemental):
    provenance = stages["provenance"]
    if (stages.get("schema") != "orbit-neighborhood-final-results-v1"
            or provenance.get("architecture") != ARCH
            or provenance.get("inter_task_network") != NET
            or provenance.get("model_namespace") != MODEL):
        raise ValueError("ORBIT experiment does not match the II20 comparison")
    cells = {(r["workload"], r["stage"]): r for r in stages["rows"]}
    if len(cells) != len(stages["rows"]):
        raise ValueError("duplicate ORBIT stage")
    original = {r["workload"]: r for r in baselines["rows"]}
    unit = {r["workload"]: r for r in supplemental["all_unit"]["rows"]}
    rows = []
    for workload, _ in WORKLOADS:
        baseline = original[workload]
        if (baseline.get("status") != "complete" or baseline.get("input_index") != 0
                or baseline.get("input_id") != "input0"
                or baseline.get("architecture") != ARCH
                or baseline.get("inter_task_network") != NET
                or baseline.get("model_namespace") != MODEL
                or baseline.get("formal_go") is not False
                or any(baseline.get(k) != "pass" for k in
                       ("mapper_equality", "numeric", "independent_trace"))):
            raise ValueError("AMOEBA baseline is not admitted: " + workload)
        if baseline.get("preserved_original_decisions", {}).get("all_active_replicas_one") is False:
            policy = baseline.get("replica_timing_policy", {})
            if (policy.get("schema") != "amoeba-original-f45-replica-scaling-v1"
                    or policy.get("child_mapper_profiles_used") is not False
                    or policy.get("status") != "original-f45-scheduler-estimate"):
                raise ValueError("multi-replica baseline lacks its estimation policy")
        fixed = unit[workload]
        if any(fixed.get(k) != "pass" for k in ("mapper_equality", "numeric", "independent_trace")):
            raise ValueError("fixed 1x1 baseline is not admitted: " + workload)
        row = {"workload": workload, "fixed_1x1_cycles": positive_cycles(fixed["baseline_cycles"]),
               "amoeba_cycles": positive_cycles(baseline["native_cycles"])}
        for index, stage in enumerate(STAGES, 1):
            result = cells[workload, stage]
            if result.get("numeric") != "pass" or result.get("trace") != "pass":
                raise ValueError("ORBIT stage is not admitted: " + workload + "/" + stage)
            row["s" + str(index) + "_cycles"] = positive_cycles(result["actual_stage_cycles"])
        row["s5_reduction_vs_amoeba_percent"] = 100 * (1 - row["s5_cycles"] / row["amoeba_cycles"])
        rows.append(row)
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stages", type=Path, required=True)
    parser.add_argument("--baselines", type=Path, required=True)
    parser.add_argument("--supplemental", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    rows = load_rows(read(args.stages), read(args.baselines), read(args.supplemental))
    args.output_dir.mkdir(parents=True, exist_ok=True)
    with (args.output_dir / "comparison.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    (args.output_dir / "comparison.json").write_text(json.dumps({
        "schema": "orbit-input0-validated-baseline-comparison-v1", "input_index": 0,
        "architecture": ARCH, "inter_task_network": NET, "model_namespace": MODEL,
        "formal_go": False, "rows": rows,
        "amoeba_replica_duration": "original F45 full-parent duration ceiling division; unchanged compiled II",
        "ray_scope": "original II20 excluded; II23 and fission are separate supplements",
    }, indent=2) + "\n")
    plt.rcParams.update({"font.size": 10, "axes.spines.top": False,
                         "axes.spines.right": False, "svg.fonttype": "none",
                         "pdf.fonttype": 42, "savefig.dpi": 220})
    fig, (curve, bars) = plt.subplots(1, 2, figsize=(11, 4.8),
                                    gridspec_kw={"width_ratios": [1.6, 1]})
    for index, (row, (_, name)) in enumerate(zip(rows, WORKLOADS)):
        curve.plot(range(1, 6), [100 * row["s" + str(i) + "_cycles"] / row["amoeba_cycles"]
                                for i in range(1, 6)], marker="o", color=COLORS[index], label=name)
    curve.axhline(100, color="#666666", linestyle="--", linewidth=1, label="AMOEBA")
    curve.set(xticks=range(1, 6), xticklabels=["S1", "S2", "S3", "S4", "S5"],
              ylabel="Cycles (% of AMOEBA)", xlabel="ORBIT cumulative stage")
    curve.grid(axis="y", alpha=.2)
    curve.legend(ncol=2, frameon=False)
    reductions = [row["s5_reduction_vs_amoeba_percent"] for row in rows]
    rectangles = bars.barh([name for _, name in WORKLOADS], reductions, color=COLORS)
    bars.invert_yaxis()
    bars.set(xlabel="S5 cycle reduction from AMOEBA (%)", xlim=(0, max(reductions) * 1.22))
    bars.grid(axis="x", alpha=.2)
    for rect, value in zip(rectangles, reductions):
        bars.text(value + .6, rect.get_y() + rect.get_height() / 2, f"{value:.2f}%", va="center")
    fig.suptitle("Input0 · common architecture and communication · lower cycles are better")
    fig.text(.5, .015, "AMOEBA retains original replica duration estimates; ORBIT uses mapped rewritten bodies. SRAM pending, formal GO false.",
             ha="center", fontsize=8)
    fig.tight_layout(rect=(0, .045, 1, .95))
    for extension in ("png", "svg", "pdf"):
        fig.savefig(args.output_dir / ("input0-amoeba-comparison." + extension))
    plt.close(fig)


if __name__ == "__main__":
    main()
