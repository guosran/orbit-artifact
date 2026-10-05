#!/usr/bin/env python3
"""Plot validated neighborhood stage values without imputing excluded workloads."""
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
DIRECT_WORKLOADS = (("gcn", "GCN"), ("harris", "Harris"), ("llama", "LLaMA"),
                    ("lu", "LU"), ("radar", "Radar"), ("raytracing", "Raytracing"))
COLORS = ("#d55e00", "#0072b2", "#009e73", "#cc79a7", "#e69f00", "#555555")
MARKERS = ("o", "s", "^", "D", "v", "x")


def _load_rows(document: dict) -> tuple[dict, dict, bool, bool]:
    kind = document.get("experiment_kind", "direct-model-neighborhood")
    supplement = kind == "ray-fission-supplement"
    exclusions = document.get("model_domain_exclusions") or {}
    if not isinstance(exclusions, dict):
        raise ValueError("model_domain_exclusions must be an object")
    if supplement:
        if exclusions:
            raise ValueError("Ray fission supplement cannot contain model-domain exclusions")
        workloads = (("raytracing", "Raytracing"),)
    else:
        if exclusions and set(exclusions) != {"raytracing"}:
            raise ValueError("only Raytracing may be excluded from the direct-model plot")
        workloads = tuple(DIRECT_WORKLOADS)
    excluded_ray = not supplement and bool(exclusions)
    if excluded_ray:
        summary = exclusions["raytracing"]
        if not isinstance(summary, dict) or summary.get("status") != "unsupported_model_domain" or \
                summary.get("task") != "Task_13" or summary.get("model_interval_max_ii") != 20 or \
                summary.get("native_cycles") is not None:
            raise ValueError("Ray N/A row lacks the required Task_13 exclusion summary")

    by_cell = {}
    for row in document.get("rows", []):
        key = row["workload"], row["stage"]
        if key in by_cell:
            raise ValueError(f"duplicate stage value: {key}")
        by_cell[key] = row
    required = {(workload, stage) for workload, _ in workloads for stage in STAGES}
    if set(by_cell) != required:
        raise ValueError("the plot requires exactly the configured five-stage workload table")

    values = {}
    for workload, _ in workloads:
        stages = [by_cell[workload, stage] for stage in STAGES]
        if workload == "raytracing" and excluded_ray:
            for row in stages:
                if row.get("status") != "unsupported_model_domain" or \
                        row.get("native_stage_cycles") is not None or \
                        row.get("numeric") != "not_applicable" or \
                        row.get("trace") != "not_applicable":
                    raise ValueError("Ray exclusion rows must remain N/A with no native cycles")
            continue
        for row in stages:
            if row.get("status") != "native_replayed" or row.get("numeric") != "pass" or \
                    row.get("trace") != "pass":
                raise ValueError(f"native/numeric/trace evidence incomplete: {(workload, row['stage'])}")
        series = [row.get("native_stage_cycles") for row in stages]
        if any(type(value) is not int or value <= 0 for value in series):
            raise ValueError(f"stage cycles must be positive integers: {workload}")
        values[workload] = series
    return by_cell, values, excluded_ray, supplement


def _save(fig: plt.Figure, output: Path, stem: str) -> None:
    for suffix in ("png", "svg", "pdf"):
        fig.savefig(output / f"{stem}.{suffix}")
    plt.close(fig)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--table", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    document = json.loads(args.table.read_text())
    _, values, excluded_ray, supplement = _load_rows(document)
    if supplement:
        plot_workloads = (("raytracing", "Raytracing · fission"),)
        name_tag = "input0-ray-fission-supplement"
        title_tag = "Raytracing fission supplement"
    elif excluded_ray:
        plot_workloads = tuple(item for item in DIRECT_WORKLOADS if item[0] != "raytracing")
        name_tag = "input0-ablation"
        title_tag = "Five-stage input-0 ablation · Raytracing model-domain N/A"
    else:
        plot_workloads = tuple(DIRECT_WORKLOADS)
        name_tag = "input0-ablation"
        title_tag = "Five-stage input-0 ablation · lower is better"

    args.output_dir.mkdir(parents=True, exist_ok=True)
    plt.rcParams.update({"font.size": 10, "axes.spines.top": False,
                         "axes.spines.right": False, "svg.fonttype": "none",
                         "pdf.fonttype": 42, "savefig.dpi": 220})
    x = list(range(1, 6))
    if excluded_ray:
        fig, axes = plt.subplots(1, 3, figsize=(14, 4.8),
                                 gridspec_kw={"width_ratios": [1.65, 1, 0.7]},
                                 constrained_layout=True)
        curve, reduction, na_panel = axes
    else:
        fig, (curve, reduction) = plt.subplots(
            1, 2, figsize=(12, 4.8), gridspec_kw={"width_ratios": [1.65, 1]},
            constrained_layout=True)
        na_panel = None
    improvements = {}
    normalized_values = []
    for index, (workload, name) in enumerate(plot_workloads):
        series = values[workload]
        normalized = [100 * value / series[0] for value in series]
        normalized_values.extend(normalized)
        curve.plot(x, normalized, label=name, color=COLORS[index],
                   marker=MARKERS[index], linewidth=1.8)
        improvements[workload] = 100 * (series[0] - series[-1]) / series[0]
    curve_padding = max(0.5, (max(normalized_values) - min(normalized_values)) * 0.12)
    curve.set(xticks=x, xticklabels=["S1", "S2", "S3", "S4", "S5"],
              ylim=(min(normalized_values) - curve_padding,
                    max(normalized_values) + curve_padding),
              xlabel="Cumulative stage", ylabel="Whole-program cycles (% of S1)",
              title="Five-stage normalized cycles")
    curve.grid(axis="y", alpha=0.2)
    curve.legend(ncol=2 if len(plot_workloads) > 1 else 1, loc="lower left", frameon=False)

    bars = reduction.barh([name for _, name in plot_workloads],
                          [improvements[workload] for workload, _ in plot_workloads],
                          color=[COLORS[i] for i in range(len(plot_workloads))])
    reduction.invert_yaxis()
    improvement_values = [improvements[workload] for workload, _ in plot_workloads]
    reduction_padding = max(0.5, (max([0, *improvement_values]) -
                                 min([0, *improvement_values])) * 0.2)
    reduction.set(xlim=(min([0, *improvement_values]) - reduction_padding,
                        max([0, *improvement_values]) + reduction_padding),
                  xlabel="Cycle reduction from S1 (%)", title="S5 relative to S1")
    reduction.grid(axis="x", alpha=0.2)
    for bar, value in zip(bars, improvement_values):
        label = f"{value:.4f}%" if 0 < value < 0.01 else f"{value:.2f}%"
        reduction.text(value + reduction_padding * (0.12 if value >= 0 else -0.12),
                       bar.get_y() + bar.get_height() / 2, label, va="center",
                       ha="left" if value >= 0 else "right")
    if na_panel is not None:
        na_panel.axis("off")
        na_panel.set_title("Not measured")
        na_panel.text(0.5, 0.56, "Raytracing\nN/A\nTask_13 outside\nmodel interval 20",
                      ha="center", va="center", transform=na_panel.transAxes,
                      bbox={"boxstyle": "round,pad=0.6", "facecolor": "#f2f2f2",
                            "edgecolor": "#999999"})
    fig.suptitle(title_tag + " · lower is better", fontsize=12)
    _save(fig, args.output_dir, name_tag + "-normalized")

    if supplement:
        fig, axis = plt.subplots(1, 1, figsize=(6.2, 4.8), constrained_layout=True)
        workload, name = plot_workloads[0]
        series = values[workload]
        axis.plot(x, series, marker=MARKERS[0], color=COLORS[0], linewidth=2)
        axis.set(xticks=x, xticklabels=["S1", "S2", "S3", "S4", "S5"],
                 ylabel="Cycles", title="Raytracing · five-stage fission")
        axis.yaxis.set_major_formatter(ScalarFormatter(useOffset=False))
        axis.ticklabel_format(axis="y", style="sci", scilimits=(-3, 4), useOffset=False)
        axis.grid(axis="y", alpha=0.2)
        axis.text(0.02, 0.03, f"S1: {series[0]:,}\nS5: {series[-1]:,}",
                  transform=axis.transAxes, fontsize=9,
                  bbox={"facecolor": "white", "alpha": 0.8, "edgecolor": "none"})
        fig.suptitle("Raytracing fission supplement · native mapper II", fontsize=12)
        _save(fig, args.output_dir, name_tag + "-absolute")
    else:
        if excluded_ray:
            fig, axes = plt.subplots(2, 3, figsize=(12, 7), constrained_layout=True)
            axes_flat = list(axes.flat)
            for axis in axes_flat:
                axis.axis("off")
            for index, (workload, name) in enumerate(plot_workloads):
                axis = axes_flat[index]
                axis.axis("on")
                series = values[workload]
                axis.plot(x, series, marker=MARKERS[index], color=COLORS[index], linewidth=2)
                axis.set(xticks=x, xticklabels=["S1", "S2", "S3", "S4", "S5"], ylabel="Cycles",
                         title=f"{name} · S5 reduction {improvements[workload]:.4f}%")
                axis.yaxis.set_major_formatter(ScalarFormatter(useOffset=False))
                axis.ticklabel_format(axis="y", style="sci", scilimits=(-3, 4), useOffset=False)
                axis.grid(axis="y", alpha=0.2)
                axis.text(0.02, 0.03, f"S1: {series[0]:,}\nS5: {series[-1]:,}",
                          transform=axis.transAxes, fontsize=9,
                          bbox={"facecolor": "white", "alpha": 0.8, "edgecolor": "none"})
            axes_flat[-1].axis("on")
            axes_flat[-1].axis("off")
            axes_flat[-1].text(0.5, 0.5, "Raytracing\nN/A · Task_13\noutside model interval 20",
                               ha="center", va="center", transform=axes_flat[-1].transAxes,
                               bbox={"boxstyle": "round,pad=0.6", "facecolor": "#f2f2f2",
                                     "edgecolor": "#999999"})
            fig.suptitle("Absolute whole-program cycles · Raytracing excluded as N/A", fontsize=12)
        else:
            fig, axes = plt.subplots(2, 3, figsize=(12, 7), constrained_layout=True)
            for index, ((workload, name), axis) in enumerate(zip(plot_workloads, axes.flat)):
                series = values[workload]
                axis.plot(x, series, marker=MARKERS[index], color=COLORS[index], linewidth=2)
                axis.set(xticks=x, xticklabels=["S1", "S2", "S3", "S4", "S5"], ylabel="Cycles",
                         title=f"{name} · S5 reduction {improvements[workload]:.4f}%")
                axis.yaxis.set_major_formatter(ScalarFormatter(useOffset=False))
                axis.ticklabel_format(axis="y", style="sci", scilimits=(-3, 4), useOffset=False)
                axis.grid(axis="y", alpha=0.2)
                axis.text(0.02, 0.03, f"S1: {series[0]:,}\nS5: {series[-1]:,}",
                          transform=axis.transAxes, fontsize=9,
                          bbox={"facecolor": "white", "alpha": 0.8, "edgecolor": "none"})
            fig.suptitle("Absolute whole-program cycles · each panel uses its own scale", fontsize=12)
        _save(fig, args.output_dir, name_tag + "-absolute")

    csv_name = "input0-ray-fission-supplement-values.csv" if supplement else "input0-ablation-values.csv"
    with (args.output_dir / csv_name).open("w", newline="") as output:
        writer = csv.writer(output)
        writer.writerow(["workload", "S1", "S2", "S3", "S4", "S5", "S5_cycle_reduction_percent"])
        for workload, name in (plot_workloads if supplement else DIRECT_WORKLOADS):
            if workload not in values:
                writer.writerow([name, "", "", "", "", "", ""])
            else:
                writer.writerow([name, *values[workload], improvements[workload]])
    print(args.output_dir)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
