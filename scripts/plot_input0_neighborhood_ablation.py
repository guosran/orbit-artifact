#!/usr/bin/env python3
"""Plot validated stage values without selecting or ranking candidates."""
from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter

STAGES = ("shape-only", "shape-temporal", "shape-temporal-replica",
          "shape-temporal-replica-tiling", "full-joint")
WORKLOADS = (("gcn", "GCN"), ("harris", "Harris"), ("llama", "LLaMA"),
             ("lu", "LU"), ("radar", "Radar"), ("raytracing", "Raytracing"))
COLORS = ("#d55e00", "#0072b2", "#009e73", "#cc79a7", "#e69f00", "#555555")
MARKERS = ("o", "s", "^", "D", "v", "x")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--table", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    document = json.loads(args.table.read_text())
    rows = {}
    for row in document["rows"]:
        key = row["workload"], row["stage"]
        if key in rows:
            raise ValueError(f"duplicate stage value: {key}")
        if row["status"] != "native_replayed" or row["numeric"] != "pass" or row["trace"] != "pass":
            raise ValueError(f"native/numeric/trace evidence incomplete: {key}")
        rows[key] = row
    required = {(workload, stage) for workload, _ in WORKLOADS for stage in STAGES}
    if set(rows) != required:
        raise ValueError("the plot requires exactly the six-program, five-stage table")
    values = {workload: [rows[workload, stage]["native_stage_cycles"] for stage in STAGES]
              for workload, _ in WORKLOADS}
    if any(not isinstance(value, int) or value <= 0 for series in values.values() for value in series):
        raise ValueError("stage cycles must be positive integers")
    args.output_dir.mkdir(parents=True, exist_ok=True)
    plt.rcParams.update({"font.size": 10, "axes.spines.top": False,
                         "axes.spines.right": False, "svg.fonttype": "none",
                         "pdf.fonttype": 42, "savefig.dpi": 220})
    x = list(range(1, 6))
    fig, (curve, reduction) = plt.subplots(1, 2, figsize=(12, 4.8),
                                         gridspec_kw={"width_ratios": [1.65, 1]},
                                         constrained_layout=True)
    improvements = []
    for index, (workload, name) in enumerate(WORKLOADS):
        series = values[workload]
        curve.plot(x, [100 * value / series[0] for value in series],
                   label=name, color=COLORS[index], marker=MARKERS[index],
                   linestyle="--" if workload == "raytracing" else "-", linewidth=1.8)
        improvements.append(100 * (series[0] - series[-1]) / series[0])
    curve.set(xticks=x, xticklabels=["S1", "S2", "S3", "S4", "S5"], ylim=(58, 104),
              xlabel="Cumulative stage", ylabel="Whole-program cycles (% of S1)",
              title="Five-stage input-0 ablation · lower is better")
    curve.grid(axis="y", alpha=0.2)
    curve.legend(ncol=3, loc="lower left", frameon=False)
    bars = reduction.barh([name for _, name in WORKLOADS], improvements, color=COLORS)
    reduction.invert_yaxis()
    reduction.set(xlim=(0, 45), xlabel="Cycle reduction from S1 (%)", title="S5 relative to S1")
    reduction.grid(axis="x", alpha=0.2)
    for bar, value in zip(bars, improvements):
        label = f"{value:.4f}%" if 0 < value < 0.01 else f"{value:.2f}%"
        reduction.text(value + 0.6, bar.get_y() + bar.get_height() / 2, label, va="center")
    fig.suptitle("Best-found production scheduler cycles using actual mapper II", fontsize=12)
    for suffix in ("png", "svg", "pdf"):
        fig.savefig(args.output_dir / f"input0-ablation-normalized.{suffix}")
    plt.close(fig)

    fig, axes = plt.subplots(2, 3, figsize=(12, 7), constrained_layout=True)
    for index, ((workload, name), axis) in enumerate(zip(WORKLOADS, axes.flat)):
        series = values[workload]
        axis.plot(x, series, marker=MARKERS[index], color=COLORS[index], linewidth=2)
        axis.set(xticks=x, xticklabels=["S1", "S2", "S3", "S4", "S5"], ylabel="Cycles",
                 title=f"{name} · S5 reduction {improvements[index]:.4f}%")
        axis.yaxis.set_major_formatter(ScalarFormatter(useOffset=False))
        axis.ticklabel_format(axis="y", style="sci", scilimits=(-3, 4), useOffset=False)
        axis.grid(axis="y", alpha=0.2)
        axis.text(0.02, 0.03, f"S1: {series[0]:,}\nS5: {series[-1]:,}",
                  transform=axis.transAxes, fontsize=9,
                  bbox={"facecolor": "white", "alpha": 0.8, "edgecolor": "none"})
    fig.suptitle("Absolute whole-program cycles · each panel uses its own scale", fontsize=12)
    for suffix in ("png", "svg", "pdf"):
        fig.savefig(args.output_dir / f"input0-ablation-absolute.{suffix}")
    plt.close(fig)
    with (args.output_dir / "input0-ablation-values.csv").open("w", newline="") as output:
        writer = csv.writer(output)
        writer.writerow(["workload", "S1", "S2", "S3", "S4", "S5", "S5_cycle_reduction_percent"])
        for index, (workload, name) in enumerate(WORKLOADS):
            writer.writerow([name, *values[workload], improvements[index]])
    print(args.output_dir)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
