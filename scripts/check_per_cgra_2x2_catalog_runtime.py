#!/usr/bin/env python3
"""Run focused runtime acceptance for the direct per-CGRA 2x2 cost pass.

The checker consumes existing real-module cost-pass command records, reruns
those commands with outputs and caches redirected into an isolated directory,
and checks C++ feature/prediction results against the pinned Python source
model. It also validates unsupported rows, exact cache-hit stability, strict
architecture/model binding, and the source-domain catalogue verifier.
It does not invoke the native mapper or prepare workload modules.
"""

from __future__ import annotations

import argparse
import copy
import json
import math
import os
import re
import shlex
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List, Mapping, Optional, Sequence, Tuple

import torch


MODEL_NAMESPACE = "orbit-per-cgra-2x2-direct-4member-v1"
MODEL_SCHEMA = "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1"
SHAPE_PROTOCOL = "amoeba-static-rectangles-2x2-per-cgra-max4"
SHAPES = ((2, 2), (2, 4), (4, 2), (2, 6), (6, 2), (2, 8), (8, 2), (4, 4))
MODEL_COMMIT = "3ade31806cb4c92e31888109f7c42b8a77e4cbce"
MODEL_REPOSITORY = "https://github.com/guosran/cgra-ii-predictor"
MODEL_BRANCH = "orbit-2x2-predictor"
SOURCE_REPOSITORY = "https://github.com/guosran/orbit.git"
SOURCE_COMMIT = "6a1b6fcf6e155651e96b3b881565ad58fdf0c03e"
MEMBER_SEEDS = (17, 41, 113, 239)
CEILING = 20.0


def _load_json(path: Path) -> Dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"expected JSON object at {path}")
    return value


def _write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n",
                    encoding="utf-8")


def _run(argv: Sequence[str], cwd: Path, stdout_path: Path,
         stderr_path: Path, *, expected: int = 0,
         contains: Optional[str] = None) -> Dict[str, Any]:
    env = os.environ.copy()
    env.update({
        "OMP_NUM_THREADS": "1",
        "MKL_NUM_THREADS": "1",
        "OPENBLAS_NUM_THREADS": "1",
        "NUMEXPR_NUM_THREADS": "1",
        "CUDA_VISIBLE_DEVICES": "",
    })
    result = subprocess.run(argv, cwd=str(cwd), env=env, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                            check=False)
    stdout_path.parent.mkdir(parents=True, exist_ok=True)
    stdout_path.write_text(result.stdout, encoding="utf-8")
    stderr_path.write_text(result.stderr, encoding="utf-8")
    if expected == 0 and result.returncode != 0:
        raise RuntimeError(
            f"command failed ({result.returncode}): {argv!r}; "
            f"stderr: {result.stderr[-3000:]}"
        )
    if expected != 0 and result.returncode == 0:
        raise AssertionError(f"command unexpectedly succeeded: {argv!r}")
    if contains is not None and contains not in result.stderr:
        raise AssertionError(
            f"expected diagnostic substring {contains!r} not present; "
            f"stderr: {result.stderr[-3000:]}"
        )
    return {
        "argv": list(argv),
        "cwd": str(cwd),
        "returncode": result.returncode,
        "stdout_log": str(stdout_path),
        "stderr_log": str(stderr_path),
        "stderr_tail": result.stderr[-2000:],
    }


def _pass_options(argv: Sequence[str], flag: str) -> Tuple[int, List[Tuple[str, str]]]:
    prefix = flag + "="
    found = [(index, arg[len(prefix):]) for index, arg in enumerate(argv)
             if arg.startswith(prefix)]
    if len(found) != 1:
        raise ValueError(f"expected one {flag} argument, found {len(found)}")
    index, encoded = found[0]
    parsed: List[Tuple[str, str]] = []
    for token in shlex.split(encoded):
        if "=" not in token:
            raise ValueError(f"malformed {flag} option {token!r}")
        key, value = token.split("=", 1)
        if not key or not value:
            raise ValueError(f"empty key or value in {flag} option {token!r}")
        parsed.append((key, value))
    if len({key for key, _ in parsed}) != len(parsed):
        raise ValueError(f"duplicate keys in {flag} argument")
    return index, parsed


def _quote_pass_value(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def _replace_pass_options(argv: Sequence[str], flag: str,
                          replacements: Mapping[str, str],
                          additions: Mapping[str, str] | None = None
                          ) -> List[str]:
    index, parsed = _pass_options(argv, flag)
    options = dict(parsed)
    options.update(replacements)
    for key, value in (additions or {}).items():
        if key in options:
            raise ValueError(f"cannot add existing pass option {key}")
        options[key] = value
    encoded = " ".join(f"{key}={_quote_pass_value(value)}"
                       for key, value in options.items())
    result = list(argv)
    result[index] = flag + "=" + encoded
    return result


def _load_command_record(path: Path, pin: Path, *,
                         allow_template_pin: bool = False) -> Dict[str, Any]:
    record = _load_json(path)
    argv = record.get("argv")
    if not isinstance(argv, list) or not argv or not all(
            isinstance(item, str) for item in argv):
        raise ValueError(f"invalid argv in command record {path}")
    if not allow_template_pin and Path(argv[0]).resolve() != pin.resolve():
        raise ValueError(f"command record is not pinned to {pin}: {argv[0]}")
    if record.get("exit_code") != 0:
        raise ValueError(f"source command was not successful: {path}")
    return record


def _run_supported_command(command_path: Path, pin: Path, root: Path,
                           label: str, source_root: Path,
                           candidate_dir: Path,
                           bundle_path: Path,
                           artifact_root: Path) -> Dict[str, Any]:
    record = _load_command_record(command_path, pin, allow_template_pin=True)
    argv = list(record["argv"])
    template_optimizer = argv[0]
    argv[0] = str(pin)
    index, options = _pass_options(
        argv, "--predict-analytical-task-cost-catalog")
    original = dict(options)
    required = {"function", "space-file", "ensemble-file", "architecture-path",
                "model-namespace", "cache", "output", "source-git-repository",
                "source-git-commit"}
    if not required.issubset(original):
        raise ValueError(f"source command missing required keys: {required - set(original)}")
    if original["model-namespace"] != MODEL_NAMESPACE:
        raise ValueError("supported command must select the direct per-CGRA model")
    if original["source-git-repository"] != SOURCE_REPOSITORY or \
       original["source-git-commit"] != SOURCE_COMMIT:
        raise ValueError("supported command has the wrong workload source binding")
    module_path = Path(argv[1]).resolve()
    workspace = root / label
    workspace.mkdir(parents=True, exist_ok=False)
    cache = workspace / "fresh-cache.json"
    first_catalog = workspace / "first-cost-catalog.json"
    first_features = workspace / "first-cpp-features.json"
    first_argv = _replace_pass_options(
        argv, "--predict-analytical-task-cost-catalog",
        {"cache": str(cache), "output": str(first_catalog)},
        {"feature-output": str(first_features)},
    )
    first_run = _run(first_argv, artifact_root, workspace / "first.stdout.log",
                     workspace / "first.stderr.log")
    if not cache.is_file() or not first_catalog.is_file() or \
       not first_features.is_file():
        raise AssertionError("first C++ pass did not produce its isolated outputs")

    second_catalog = workspace / "second-cost-catalog.json"
    second_features = workspace / "second-cpp-features.json"
    second_argv = _replace_pass_options(
        argv, "--predict-analytical-task-cost-catalog",
        {"cache": str(cache), "output": str(second_catalog)},
        {"feature-output": str(second_features)},
    )
    second_run = _run(second_argv, artifact_root, workspace / "second.stdout.log",
                      workspace / "second.stderr.log")
    first = _load_json(first_catalog)
    second = _load_json(second_catalog)
    _assert_cache_equal(first, second, label)
    _assert_features_equal(first_features, second_features)
    return {
        "label": label,
        "source_command_record": str(command_path),
        "source_prep_optimizer_template": template_optimizer,
        "actual_runtime_optimizer": str(pin),
        "source_module": str(module_path),
        "function": original["function"],
        "candidate_space": original["space-file"],
        "fresh_cache": str(cache),
        "first_catalog": str(first_catalog),
        "first_feature_output": str(first_features),
        "second_catalog": str(second_catalog),
        "second_feature_output": str(second_features),
        "first_run": first_run,
        "second_run": second_run,
        "cache_round_trip": _cache_report(first, second),
        "parity": _check_cpp_against_python(first_catalog, first_features,
                                              source_root, candidate_dir,
                                              bundle_path),
    }


def _entry_key(entry: Mapping[str, Any]) -> Tuple[str, int, int]:
    return (str(entry["task"]), int(entry["mapper_tile_rows"]),
            int(entry["mapper_tile_cols"]))


def _assert_cache_equal(first: Mapping[str, Any], second: Mapping[str, Any],
                        label: str) -> None:
    if first.get("namespace") != MODEL_NAMESPACE or \
       second.get("namespace") != MODEL_NAMESPACE:
        raise AssertionError(f"{label}: wrong catalogue namespace")
    first_entries = first.get("entries")
    second_entries = second.get("entries")
    if not isinstance(first_entries, list) or not isinstance(second_entries, list):
        raise AssertionError(f"{label}: missing cost entries")
    if len(first_entries) != len(second_entries) or not first_entries:
        raise AssertionError(f"{label}: cost query count changed on cache hit")
    first_by_key = {_entry_key(entry): entry for entry in first_entries}
    second_by_key = {_entry_key(entry): entry for entry in second_entries}
    if len(first_by_key) != len(first_entries) or first_by_key.keys() != second_by_key.keys():
        raise AssertionError(f"{label}: duplicate or changed catalogue keys")
    for key, left in first_by_key.items():
        right = second_by_key[key]
        for scalar in ("predicted_ii", "predicted_ii_std"):
            if scalar not in left or left[scalar] != right.get(scalar):
                raise AssertionError(f"{label}: cache changed exact {scalar} for {key}")
        if left.get("direct_ensemble_members") != right.get("direct_ensemble_members"):
            raise AssertionError(f"{label}: cache changed exact member values for {key}")


def _cache_report(first: Mapping[str, Any], second: Mapping[str, Any]) -> Dict[str, Any]:
    query_count = len(first["entries"])
    cache = second.get("predictor_metadata", {}).get("ml_cache", {})
    hits = int(cache.get("hits", -1))
    misses = int(cache.get("misses", -1))
    if hits < query_count or misses != 0:
        raise AssertionError(
            f"second run did not serve every query from cache: "
            f"query_count={query_count} hits={hits} misses={misses}"
        )
    return {
        "status": "pass",
        "query_count": query_count,
        "second_run_hits": hits,
        "second_run_misses": misses,
        "all_member_and_aggregate_scalars_exact": True,
    }


def _assert_features_equal(first_path: Path, second_path: Path) -> None:
    first = _load_json(first_path)
    second = _load_json(second_path)
    if first != second:
        raise AssertionError("C++ raw features changed between fresh and cached runs")


def _import_pinned_source(source_root: Path):
    sys.path.insert(0, str(source_root / "src"))
    from cgra_ii_predictor.dfg import GraphData
    from cgra_ii_predictor.mapper_model import (
        DirectMapperIIEnsemble,
        MapperModelConfig,
        mapper_feature_names,
        mapper_feature_vector,
    )
    from cgra_ii_predictor.shape_protocol import SHAPE_PROTOCOL_2X2
    return (GraphData, DirectMapperIIEnsemble, MapperModelConfig,
            mapper_feature_names, mapper_feature_vector, SHAPE_PROTOCOL_2X2)


def _source_model(candidate_dir: Path, source: Tuple[Any, ...]):
    _GraphData, DirectMapperIIEnsemble, MapperModelConfig, _names, _features, protocol = source
    checkpoint = torch.load(candidate_dir / "mapper.pt", map_location="cpu",
                            weights_only=True)
    raw_config = checkpoint.get("config")
    if not isinstance(raw_config, dict):
        raise ValueError("pinned source checkpoint lacks config")
    config = MapperModelConfig(
        hidden_dimensions=tuple(raw_config["hidden_dimensions"]),
        mapper_ii_ceiling=float(raw_config["mapper_ii_ceiling"]),
        shape_protocol=protocol.protocol_id,
        enabled_feature_names=tuple(raw_config["enabled_feature_names"]),
    )
    if raw_config.get("shape_protocol") != protocol.protocol_id:
        raise ValueError("pinned source checkpoint is not the 2x2 shape protocol")
    model = DirectMapperIIEnsemble(4, config)
    model.load_state_dict(checkpoint["state_dict"], strict=True)
    model.eval()
    return model


def _cpp_model_from_bundle(bundle_path: Path):
    # Evaluate the exported JSON as deployed: normalization, selected feature
    # projection, erf GELU, softplus residual and lower-bound ceiling.
    import torch.nn.functional as functional
    bundle = _load_json(bundle_path)
    if bundle.get("schema") != MODEL_SCHEMA or \
       bundle.get("model_namespace") != MODEL_NAMESPACE:
        raise ValueError("portable model bundle schema/namespace changed")
    return bundle, functional


def _check_cpp_against_python(catalog_path: Path, feature_path: Path,
                              source_root: Path, candidate_dir: Path,
                              bundle_path: Path) -> Dict[str, Any]:
    source = _import_pinned_source(source_root)
    GraphData, _Ensemble, _Config, feature_names, feature_vector, protocol = source
    model = _source_model(candidate_dir, source)
    bundle, functional = _cpp_model_from_bundle(bundle_path)
    names = tuple(feature_names(protocol.protocol_id))
    if len(names) != 148 or len(bundle["feature_contract"]["feature_names"]) != 148:
        raise AssertionError("2x2 feature contract is not 148 wide")
    if tuple(bundle["feature_contract"]["feature_names"]) != names:
        raise AssertionError("portable JSON model feature names differ from pinned source")

    catalog = _load_json(catalog_path)
    cpp = _load_json(feature_path)
    if catalog.get("namespace") != MODEL_NAMESPACE or \
       catalog.get("predictor_metadata", {}).get("model_schema") != MODEL_SCHEMA:
        raise AssertionError("runtime catalog lacks the direct model contract")
    if cpp.get("schema") != "cgra-ii-cpp-feature-output-v1" or \
       cpp.get("feature_width") != 148 or tuple(cpp.get("feature_names", ())) != names:
        raise AssertionError("runtime C++ feature output contract is invalid")
    catalog_entries = catalog.get("entries")
    feature_queries = cpp.get("queries")
    if not isinstance(catalog_entries, list) or not isinstance(feature_queries, list):
        raise AssertionError("missing runtime entries or C++ feature queries")
    cat_by_key = {_entry_key(entry): entry for entry in catalog_entries}
    if len(cat_by_key) != len(catalog_entries) or len(feature_queries) != len(catalog_entries):
        raise AssertionError("C++ features and costs do not cover the same query count")
    feature_by_key: Dict[Tuple[str, int, int], Mapping[str, Any]] = {}
    for row in feature_queries:
        key = (str(row["task"]), int(row["rows"]), int(row["columns"]))
        if key in feature_by_key:
            raise AssertionError(f"duplicate C++ feature query {key}")
        feature_by_key[key] = row
    if feature_by_key.keys() != cat_by_key.keys():
        raise AssertionError("C++ feature-output and catalog key domains differ")

    max_feature_error = 0.0
    max_member_error = 0.0
    max_mean_error = 0.0
    max_std_error = 0.0
    unique_graphs = set()
    per_shape: Dict[Tuple[int, int], int] = {shape: 0 for shape in SHAPES}
    task_ids = set()
    rec_values: List[float] = []
    res_values: List[float] = []
    lower_values: List[float] = []
    ordered = sorted(cat_by_key.items(), key=lambda pair: (pair[0][0], pair[0][1], pair[0][2]))
    cpp_feature_rows: List[List[float]] = []
    lower_rows: List[float] = []
    expected_members: List[List[float]] = []
    expected_means: List[float] = []
    expected_stds: List[float] = []
    for key, entry in ordered:
        task, rows, cols = key
        if (rows, cols) not in SHAPES:
            raise AssertionError(f"unsupported shape in catalog: {key}")
        feature = feature_by_key[key]
        if int(feature["rows"]) != rows or int(feature["columns"]) != cols:
            raise AssertionError(f"C++ feature identity mismatch for {key}")
        rec_mii = float(feature["rec_mii"])
        res_mii = float(feature["res_mii"])
        lower_bound = float(feature["lower_bound"])
        if not all(math.isfinite(value) for value in (rec_mii, res_mii, lower_bound)):
            raise AssertionError(f"non-finite C++ analytical facts for {key}")
        if max(rec_mii, res_mii) != lower_bound or \
           float(entry["analytical_lower_bound"]) != lower_bound:
            raise AssertionError(f"catalog lower bound disagrees with C++ Rec/Res for {key}")
        graph_key = (
            tuple(int(value) for value in feature["node_types"]),
            tuple(tuple(float(value) for value in row) for row in feature["node_features"]),
            tuple(tuple(int(value) for value in edge) for edge in feature["edges"]),
            tuple(tuple(int(value) for value in edge)
                  for edge in feature.get("semantic_edges", [])),
        )
        unique_graphs.add(graph_key)
        graph = GraphData(*graph_key)
        python_features = feature_vector(
            graph, rows, cols, rec_mii, res_mii, lower_bound,
            mapper_ii_ceiling=CEILING, shape_protocol=protocol.protocol_id,
        )
        c_features = [float(value) for value in feature["features"]]
        if len(c_features) != 148 or len(python_features) != 148:
            raise AssertionError(f"raw feature width mismatch for {key}")
        feature_error = max(abs(a - b) for a, b in zip(c_features, python_features))
        max_feature_error = max(max_feature_error, feature_error)
        if feature_error > 1.0e-12:
            raise AssertionError(f"C++ vs pinned Python raw features differ for {key}: {feature_error}")

        if entry.get("support_status") != "supported":
            raise AssertionError(f"supported workload unexpectedly has unsupported row {key}")
        cpp_members = entry.get("direct_ensemble_members")
        if not isinstance(cpp_members, list) or len(cpp_members) != 4:
            raise AssertionError(f"catalog does not retain four direct members for {key}")
        if [member.get("seed") for member in cpp_members] != list(MEMBER_SEEDS):
            raise AssertionError(f"direct model member order/seed changed for {key}")
        for index, member in enumerate(cpp_members):
            if member.get("member_index") != index:
                raise AssertionError(f"direct model member index changed for {key}")

        cpp_feature_rows.append(c_features)
        lower_rows.append(lower_bound)
        expected_members.append([float(member["predicted_ii"]) for member in cpp_members])
        expected_means.append(float(entry["predicted_ii"]))
        expected_stds.append(float(entry["predicted_ii_std"]))
        per_shape[(rows, cols)] += 1
        task_ids.add(task)
        rec_values.append(rec_mii)
        res_values.append(res_mii)
        lower_values.append(lower_bound)

    if set(per_shape) != set(SHAPES) or any(per_shape[shape] == 0 for shape in SHAPES):
        raise AssertionError("real-module catalog does not cover all eight 2x2 shapes")
    if len(unique_graphs) < 3:
        raise AssertionError("acceptance module did not provide varied real mapper-visible bodies")
    features = torch.tensor(cpp_feature_rows, dtype=torch.float32)
    lower = torch.tensor(lower_rows, dtype=torch.float32)
    with torch.no_grad():
        source_members = torch.stack(
            [member(features, lower) for member in model.members], dim=1)
        source_mean = source_members.mean(dim=1)
        source_std = source_members.std(dim=1, unbiased=False)
    for query_index in range(len(ordered)):
        for member_index in range(4):
            error = abs(float(source_members[query_index, member_index]) -
                        expected_members[query_index][member_index])
            max_member_error = max(max_member_error, error)
        mean_error = abs(float(source_mean[query_index]) - expected_means[query_index])
        std_error = abs(float(source_std[query_index]) - expected_stds[query_index])
        max_mean_error = max(max_mean_error, mean_error)
        max_std_error = max(max_std_error, std_error)
    if max_member_error > 1.0e-5 or max_mean_error > 1.0e-5 or max_std_error > 1.0e-5:
        raise AssertionError(
            "C++ runtime differs from pinned Python source network: "
            f"member={max_member_error}, mean={max_mean_error}, std={max_std_error}"
        )

    # Independently evaluate the portable JSON inference payload used by C++.
    selected = bundle["feature_contract"]["selected_feature_indices"]
    portable_members = []
    for member in bundle["members"]:
        mean = torch.tensor(member["feature_mean"], dtype=torch.float32)
        scale = torch.tensor(member["feature_scale"], dtype=torch.float32)
        activation = ((features - mean) / scale)[:, selected]
        for layer_index, layer in enumerate(member["layers"]):
            weights = torch.tensor(layer["weights"], dtype=torch.float32)
            bias = torch.tensor(layer["bias"], dtype=torch.float32)
            activation = functional.linear(activation, weights, bias)
            if layer_index < 2:
                activation = functional.gelu(activation, approximate="none")
        raw = torch.nn.functional.softplus(activation.squeeze(-1)) + lower
        portable_members.append(torch.minimum(raw, torch.full_like(lower, CEILING)))
    portable = torch.stack(portable_members, dim=1)
    exported_member_error = 0.0
    exported_mean_error = 0.0
    for query_index in range(len(ordered)):
        for member_index in range(4):
            exported_member_error = max(
                exported_member_error,
                abs(float(portable[query_index, member_index]) -
                    expected_members[query_index][member_index]),
            )
        exported_mean_error = max(
            exported_mean_error,
            abs(float(portable[query_index].mean()) - expected_means[query_index]),
        )
    if exported_member_error > 1.0e-5 or exported_mean_error > 1.0e-5:
        raise AssertionError("portable JSON payload differs from C++ catalog predictions")

    return {
        "status": "pass",
        "catalog": str(catalog_path),
        "cpp_features": str(feature_path),
        "query_count": len(ordered),
        "real_task_count": len(task_ids),
        "distinct_mapper_visible_graph_count": len(unique_graphs),
        "shape_query_counts": {
            f"{rows}x{cols}": per_shape[(rows, cols)] for rows, cols in SHAPES
        },
        "cxx_analytical_facts": {
            "rec_mii_min": min(rec_values), "rec_mii_max": max(rec_values),
            "res_mii_min": min(res_values), "res_mii_max": max(res_values),
            "lower_bound_min": min(lower_values), "lower_bound_max": max(lower_values),
            "source": "actual C++ feature-output rec_mii/res_mii; lower bound independently checked as max(RecMII, ResMII) and against catalog",
        },
        "cxx_vs_pinned_python_frontend_max_abs_error": max_feature_error,
        "cxx_vs_pinned_python_source_model": {
            "max_member_abs_error": max_member_error,
            "max_mean_abs_error": max_mean_error,
            "max_population_std_abs_error": max_std_error,
        },
        "cxx_vs_portable_json_payload": {
            "max_member_abs_error": exported_member_error,
            "max_mean_abs_error": exported_mean_error,
        },
        "source_model": {
            "repository": MODEL_REPOSITORY,
            "branch": MODEL_BRANCH,
            "commit": MODEL_COMMIT,
        },
    }


def _check_unsupported_catalog(path: Path) -> Dict[str, Any]:
    catalog = _load_json(path)
    if catalog.get("namespace") != MODEL_NAMESPACE:
        raise AssertionError("unsupported catalog has wrong model namespace")
    entries = catalog.get("entries")
    if not isinstance(entries, list) or not entries:
        raise AssertionError("unsupported catalog has no rows")
    unsupported = []
    supported = []
    for entry in entries:
        lb = float(entry.get("analytical_lower_bound", -1))
        if entry.get("support_status") == "unsupported":
            unsupported.append(entry)
            forbidden = ("predicted_ii", "predicted_ii_std", "ii_mean_source",
                         "direct_ensemble_members", "startup_cycles", "model_status",
                         "production_ready", "mapper_success_probability")
            if lb <= CEILING or entry.get("model_interval_max_ii") != CEILING or \
               entry.get("status") != "unsupported-model-domain" or \
               entry.get("unsupported_reason") != "analytical-lower-bound-exceeds-model-ceiling" or \
               any(name in entry for name in forbidden):
                raise AssertionError(f"unsupported row contains invalid predictions or reason: {_entry_key(entry)}")
        elif entry.get("support_status") == "supported":
            supported.append(entry)
            if lb > CEILING or not isinstance(entry.get("predicted_ii"), (int, float)) or \
               not isinstance(entry.get("direct_ensemble_members"), list):
                raise AssertionError(f"supported row is malformed: {_entry_key(entry)}")
        else:
            raise AssertionError(f"catalog row has unknown support status: {_entry_key(entry)}")
    if not unsupported or not supported:
        raise AssertionError("unsupported-domain test requires both supported and unsupported rows")
    task13 = [entry for entry in unsupported if entry.get("task") == "Task_13"]
    if len(task13) != 8:
        raise AssertionError(f"expected Task_13's eight Ray queries to be unsupported, found {len(task13)}")
    return {
        "status": "pass",
        "catalog": str(path),
        "total_queries": len(entries),
        "supported_queries": len(supported),
        "unsupported_queries": len(unsupported),
        "unsupported_tasks": sorted({entry["task"] for entry in unsupported}),
        "unsupported_lower_bound_min": min(entry["analytical_lower_bound"] for entry in unsupported),
        "unsupported_lower_bound_max": max(entry["analytical_lower_bound"] for entry in unsupported),
        "task13_all_eight_shapes_explicitly_unsupported_without_predictions": True,
    }


def _run_model_rejection_tests(command_path: Path, pin: Path,
                               root: Path, architecture: Path,
                               old_ensemble: Path,
                               direct_bundle: Path,
                               artifact_root: Path) -> Dict[str, Any]:
    record = _load_command_record(command_path, pin, allow_template_pin=True)
    base_argv = list(record["argv"])
    base_argv[0] = str(pin)
    _, original = _pass_options(base_argv, "--predict-analytical-task-cost-catalog")
    original_map = dict(original)
    tests: Dict[str, Any] = {}
    for test_name in ("changed-architecture", "new-namespace-old-model",
                      "tampered-bundle-member", "tampered-bundle-provenance"):
        directory = root / test_name
        directory.mkdir(parents=True, exist_ok=False)
        cache = directory / "must-not-be-created-cache.json"
        output = directory / "must-not-be-created-catalog.json"
        feature = directory / "must-not-be-created-features.json"
        replacements = {"cache": str(cache), "output": str(output)}
        expected_text = None
        if test_name == "changed-architecture":
            changed_arch = directory / "architecture-changed-by-one-byte.yaml"
            changed_arch.write_bytes(architecture.read_bytes() + b"\n")
            replacements["architecture-path"] = str(changed_arch)
            expected_text = "architecture"
        elif test_name == "new-namespace-old-model":
            replacements["ensemble-file"] = str(old_ensemble)
            expected_text = "schema"
        else:
            bundle = _load_json(direct_bundle)
            if test_name == "tampered-bundle-member":
                bundle["members"][0]["layers"][0]["weights"][0].pop()
                expected_text = "shape"
            else:
                bundle["source_model"]["commit"] = "tampered-commit"
                expected_text = "source"
            changed_bundle = directory / "tampered-direct-ensemble.json"
            _write_json(changed_bundle, bundle)
            replacements["ensemble-file"] = str(changed_bundle)
        argv = _replace_pass_options(
            base_argv, "--predict-analytical-task-cost-catalog", replacements,
        )
        pass_arg = next(arg for arg in argv if arg.startswith(
            "--predict-analytical-task-cost-catalog="))
        if "feature-output" not in pass_arg:
            argv = _replace_pass_options(
                argv, "--predict-analytical-task-cost-catalog", {},
                {"feature-output": str(feature)},
            )
        result = _run(argv, artifact_root, directory / "stdout.log",
                      directory / "stderr.log", expected=1)
        stderr = Path(result["stderr_log"]).read_text(encoding="utf-8").lower()
        if expected_text and expected_text not in stderr:
            raise AssertionError(
                f"{test_name} did not fail with a {expected_text} diagnostic: {stderr[-2500:]}"
            )
        if cache.exists() or output.exists() or feature.exists():
            raise AssertionError(f"{test_name} rejection wrote partial outputs/cache")
        tests[test_name] = {
            "status": "pass",
            "returncode": result["returncode"],
            "diagnostic": result["stderr_tail"],
            "no_cache_or_partial_catalog_or_features_written": True,
            "command": result["argv"],
        }
    return tests


def _rewrite_search_command(record_path: Path, pin: Path, root: Path,
                             cost_catalog: Path, label: str,
                             artifact_root: Path, source_contract: Path,
                             network: Path, protocol_template: Path,
                             *, tamper: Optional[str] = None) -> Tuple[List[str], Path]:
    """Build the exact one-candidate, non-native source-verifier invocation."""
    source = _load_command_record(record_path, pin, allow_template_pin=True)
    pass_index, cost_options = _pass_options(
        source["argv"], "--predict-analytical-task-cost-catalog")
    cost = dict(cost_options)
    module = Path(source["argv"][1]).resolve()
    function = cost["function"]
    architecture = Path(cost["architecture-path"]).resolve()
    model = Path(cost["ensemble-file"]).resolve()
    cwd = artifact_root.resolve()
    directory = root / f"source-verifier-{label}"
    directory.mkdir(parents=True, exist_ok=False)
    chosen_catalog = cost_catalog
    if tamper:
        data = _load_json(cost_catalog)
        if tamper == "member":
            supported = next(entry for entry in data["entries"]
                             if entry.get("support_status") == "supported")
            supported["direct_ensemble_members"][0]["predicted_ii"] += 0.5
        elif tamper == "provenance":
            data["predictor_metadata"]["source_model"]["commit"] = "tampered-commit"
        else:
            raise ValueError(f"unknown tamper kind: {tamper}")
        chosen_catalog = directory / f"tampered-{tamper}-catalog.json"
        _write_json(chosen_catalog, data)

    # The artifact checkout intentionally has no source-tree default protocol
    # path. Bind a temp copy of the published 2x2 template with exactly the
    # small budgets passed below; the source verifier runs before search.
    protocol = _load_json(protocol_template)
    search = protocol.get("search")
    if not isinstance(search, dict):
        raise ValueError("2x2 protocol template has no search object")
    search["max_rounds"] = 1
    search["max_unique_complete_candidates_scored"] = 1
    search["beam_width"] = 16
    search["diversity_min_slots"] = 4
    search["max_partition_factor"] = 4
    protocol_path = directory / "runtime-source-verifier-protocol.json"
    _write_json(protocol_path, protocol)

    out = directory / "output.mlir"
    search_options = {
        "output-dir": str(directory / "search-output"),
        "function": function,
        "stage": "shape-only",
        "architecture-path": str(architecture),
        "source-repository": SOURCE_REPOSITORY,
        "source-commit": SOURCE_COMMIT,
        "model-namespace": MODEL_NAMESPACE,
        "parent-cost-file": str(chosen_catalog),
        "model": str(model),
        "cache": str(directory / "search-cache.json"),
        "protocol": str(protocol_path),
        "source-contract-file": str(source_contract),
        "bootstrap-supported-shapes": "true",
        "require-source-iteration-domain": "true",
        "max-rounds": "1",
        "max-candidates": "1",
        "beam-width": "16",
        "diversity-slots": "4",
        "scoring-workers": "1",
    }
    encoded = " ".join(f"{key}={_quote_pass_value(value)}"
                       for key, value in search_options.items())
    argv = [
        str(pin), str(module), "--verify-each",
        "--architecture-spec=" + str(architecture),
        "--joint-inter-task-network-spec=" + str(network),
        "--search-joint-neighborhood=" + encoded,
        "-o", str(out),
    ]
    return argv, cwd


def _run_source_verifier(record_path: Path, pin: Path, root: Path,
                        supported_catalog: Path, artifact_root: Path,
                        source_contract: Path, network: Path,
                         protocol_template: Path,
                         ray_fission_command: Optional[Path] = None,
                         ray_fission_catalog: Optional[Path] = None,
                         ray_fission_protocol_template: Optional[Path] = None
                         ) -> Dict[str, Any]:
    accepted_argv, cwd = _rewrite_search_command(
        record_path, pin, root, supported_catalog, "gcn-accepted",
        artifact_root, source_contract, network, protocol_template)
    accepted_result = _run(accepted_argv, cwd, root / "source-verifier-gcn-accepted.stdout.log",
                           root / "source-verifier-gcn-accepted.stderr.log",
                           expected=0)
    search_dir = Path(dict(_pass_options(
        accepted_argv, "--search-joint-neighborhood")[1])["output-dir"])
    summary_path = search_dir / "search-summary.json"
    if not summary_path.is_file():
        raise AssertionError("valid source-bound Search did not write search-summary.json")
    summary = _load_json(summary_path)
    if not summary.get("cost_catalogue_loaded") or \
       summary.get("canonical_bootstrap_applied") or \
       summary.get("canonical_all_unit_cost_status") != "supported":
        raise AssertionError(
            "valid GCN Search did not consume the direct 2x2 all-supported catalogue"
        )
    if not summary.get("unique_complete_candidates_scored"):
        raise AssertionError("valid GCN Search did not score any complete candidate")
    output_module = Path(accepted_argv[accepted_argv.index("-o") + 1])
    if not output_module.is_file() or output_module.stat().st_size == 0:
        raise AssertionError("valid GCN Search did not materialize its shape-only result")
    negative: Dict[str, Any] = {}
    for tamper, expected_diagnostic in (
        ("member", "direct model-domain aggregate disagrees with its four members"),
        ("provenance", "direct model-domain catalogue has invalid predictor source"),
    ):
        argv, cwd = _rewrite_search_command(
            record_path, pin, root, supported_catalog,
            f"gcn-{tamper}-tampered", artifact_root, source_contract,
            network, protocol_template, tamper=tamper)
        result = _run(argv, cwd,
                      root / f"source-verifier-{tamper}.stdout.log",
                      root / f"source-verifier-{tamper}.stderr.log",
                      expected=1, contains=expected_diagnostic)
        negative[tamper] = {
            "status": "pass",
            "returncode": result["returncode"],
            "expected_verifier_error": expected_diagnostic,
            "stderr_tail": result["stderr_tail"],
        }
    if (ray_fission_command is None) != (ray_fission_catalog is None):
        raise ValueError("Ray-fission Search requires both its command template and catalog")
    ray_fission: Optional[Dict[str, Any]] = None
    if ray_fission_command is not None and ray_fission_catalog is not None:
        ray_argv, ray_cwd = _rewrite_search_command(
            ray_fission_command, pin, root, ray_fission_catalog,
            "ray-fission-bootstrap", artifact_root, source_contract,
            network, ray_fission_protocol_template or protocol_template)
        ray_result = _run(
            ray_argv, ray_cwd,
            root / "source-verifier-ray-fission.stdout.log",
            root / "source-verifier-ray-fission.stderr.log", expected=0)
        ray_search_dir = Path(dict(_pass_options(
            ray_argv, "--search-joint-neighborhood")[1])["output-dir"])
        ray_summary_path = ray_search_dir / "search-summary.json"
        if not ray_summary_path.is_file():
            raise AssertionError("Ray-fission Search did not write search-summary.json")
        ray_summary = _load_json(ray_summary_path)
        unsupported_unit = ray_summary.get("canonical_all_unit_unsupported_queries")
        actual_shapes = ray_summary.get("canonical_actual_identity_shapes")
        ray_costs = _load_json(ray_fission_catalog)
        if not ray_summary.get("cost_catalogue_loaded") or \
           not ray_summary.get("canonical_bootstrap_applied") or \
           ray_summary.get("canonical_all_unit_cost_status") != "unsupported-model-domain" or \
           not isinstance(unsupported_unit, list) or len(unsupported_unit) != 2 or \
           not isinstance(actual_shapes, list):
            raise AssertionError("Ray-fission Search did not record the expected supported-shape bootstrap")
        unsupported_tasks = {entry.get("task") for entry in unsupported_unit}
        if unsupported_tasks != {"Task_13", "Task_13.fission.0"} or any(
                entry.get("mapper_tile_rows") != 2 or
                entry.get("mapper_tile_cols") != 2 or
                float(entry.get("analytical_lower_bound", 0.0)) <= CEILING
                for entry in unsupported_unit):
            raise AssertionError("Ray-fission bootstrap did not preserve its two proven unsupported unit queries")
        supported_query_keys = {
            (entry.get("task"), entry.get("mapper_tile_rows"),
             entry.get("mapper_tile_cols"))
            for entry in ray_costs.get("entries", [])
            if entry.get("support_status") == "supported"
        }
        selected_shapes = {
            entry.get("task"): (entry.get("rows"), entry.get("cols"))
            for entry in actual_shapes
        }
        if not unsupported_tasks.issubset(selected_shapes):
            raise AssertionError("Ray-fission Search omitted unsupported tasks from canonical shape metadata")
        for task in unsupported_tasks:
            cgra_rows, cgra_cols = selected_shapes[task]
            if (cgra_rows, cgra_cols) == (1, 1) or \
               (task, cgra_rows * 2, cgra_cols * 2) not in supported_query_keys:
                raise AssertionError("Ray-fission Search did not select a supported larger direct-model shape")
        ray_output = Path(ray_argv[ray_argv.index("-o") + 1])
        if not ray_output.is_file() or ray_output.stat().st_size == 0:
            raise AssertionError("Ray-fission Search did not materialize its bootstrapped result")
        ray_fission_record = _load_json(ray_fission_command)
        ray_fission = {
            "status": "pass",
            "source_command_template": str(ray_fission_command),
            "source_prep_optimizer_template": ray_fission_record["argv"][0],
            "actual_runtime_optimizer": str(pin),
            "catalog": str(ray_fission_catalog),
            "summary": str(ray_summary_path),
            "unsupported_unit_queries": unsupported_unit,
            "canonical_identity_shapes": actual_shapes,
            "larger_shapes_are_supported_catalog_queries": True,
            "scored_candidates": ray_summary.get("unique_complete_candidates_scored"),
            "native_mapper_invoked": False,
            "run": ray_result,
        }
    return {
        "status": "pass",
        "source_verifier_valid_catalog": "passed",
        "direct_model_search_integration": {
            "status": "pass",
            "summary": str(summary_path),
            "cost_catalogue_loaded": summary["cost_catalogue_loaded"],
            "canonical_all_unit_cost_status": summary["canonical_all_unit_cost_status"],
            "canonical_bootstrap_applied": summary["canonical_bootstrap_applied"],
            "unique_complete_candidates_scored": summary["unique_complete_candidates_scored"],
            "native_mapper_invoked": False,
        },
        "accepted_catalog": str(supported_catalog),
        "accepted_run": accepted_result,
        "tampered_catalog_rejections": negative,
        "ray_fission_supported_shape_bootstrap": ray_fission,
        "search_budget": {"max_rounds": 1, "max_candidates": 1,
                          "scoring_workers": 1, "native_mapper_invoked": False},
    }


def run(args: argparse.Namespace) -> Dict[str, Any]:
    args.report_dir = args.report_dir.resolve()
    args.artifact_root = args.artifact_root.resolve()
    pin = args.pin.resolve()
    if not pin.is_file():
        raise ValueError(f"pinned optimizer is missing: {pin}")
    if not args.supported_command_json:
        raise ValueError("at least one real all-supported command record is required")
    if args.report_dir.exists():
        raise FileExistsError(f"refusing to overwrite acceptance directory {args.report_dir}")
    args.report_dir.mkdir(parents=True)
    torch.set_num_threads(1)
    torch.set_num_interop_threads(1)

    supported = []
    for index, command_path in enumerate(args.supported_command_json):
        label = command_path.parent.parent.name
        if not label:
            label = f"supported-{index}"
        supported.append(_run_supported_command(
            command_path.resolve(), pin, args.report_dir / "supported", label,
            args.source_model_root.resolve(), args.candidate_dir.resolve(),
            args.bundle.resolve(), args.artifact_root.resolve()))
    unsupported = _check_unsupported_catalog(args.unsupported_catalog.resolve())

    rejection_tests = _run_model_rejection_tests(
        args.supported_command_json[0].resolve(), pin,
        args.report_dir / "model-rejection-tests",
        args.architecture.resolve(), args.legacy_ensemble.resolve(),
        args.bundle.resolve(), args.artifact_root.resolve())
    source_verifier = _run_source_verifier(
        args.supported_command_json[0].resolve(), pin,
        args.report_dir / "source-verifier", Path(supported[0]["first_catalog"]),
        args.artifact_root.resolve(), args.source_contract.resolve(),
        args.network_spec.resolve(), args.protocol_template.resolve(),
        args.ray_fission_command_json.resolve()
        if args.ray_fission_command_json else None,
        args.ray_fission_catalog.resolve()
        if args.ray_fission_catalog else None,
        args.ray_fission_protocol_template.resolve()
        if args.ray_fission_protocol_template else None)

    return {
        "schema": "orbit-per-cgra-2x2-direct-runtime-acceptance-v1",
        "status": "pass",
        "pinned_optimizer": str(pin),
        "model_namespace": MODEL_NAMESPACE,
        "source_model": {"repository": MODEL_REPOSITORY,
                         "branch": MODEL_BRANCH, "commit": MODEL_COMMIT},
        "workload_source": {"repository": SOURCE_REPOSITORY,
                            "commit": SOURCE_COMMIT},
        "supported_real_module_runs": supported,
        "unsupported_domain_rows": unsupported,
        "strict_binding_rejection_tests": rejection_tests,
        "source_domain_verifier": source_verifier,
        "claim_scope": "frontend/runtime consistency and strict binding only; no mapper accuracy or production-readiness claim",
        "native_mapper_invoked": False,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pin", type=Path, required=True)
    parser.add_argument("--supported-command-json", type=Path,
                        action="append", required=True,
                        help="successful real all-supported predict-pass command record")
    parser.add_argument("--unsupported-catalog", type=Path, required=True,
                        help="fresh direct-model catalogue containing actual LB>20 rows")
    parser.add_argument("--architecture", type=Path, required=True)
    parser.add_argument("--legacy-ensemble", type=Path, required=True,
                        help="old formal-max4 model; must reject under direct namespace")
    parser.add_argument("--source-model-root", type=Path, required=True,
                        help="read-only archive of the exact Python model source commit")
    parser.add_argument("--candidate-dir", type=Path, required=True,
                        help="pinned source checkpoint package with mapper.pt")
    parser.add_argument("--bundle", type=Path, required=True,
                        help="portable C++ model bundle")
    parser.add_argument("--artifact-root", type=Path, required=True)
    parser.add_argument("--source-contract", type=Path, required=True)
    parser.add_argument("--network-spec", type=Path, required=True)
    parser.add_argument("--protocol-template", type=Path, required=True)
    parser.add_argument("--ray-fission-command-json", type=Path,
                        help="successful Ray-fission cost-pass command template; Search is rerun on --pin")
    parser.add_argument("--ray-fission-catalog", type=Path,
                        help="Ray-fission catalog with its exact source-bound unsupported unit queries")
    parser.add_argument("--ray-fission-protocol-template", type=Path,
                        help="separately bound Ray-fission protocol template; defaults to --protocol-template")
    parser.add_argument("--report-dir", type=Path, required=True)
    args = parser.parse_args()
    report = run(args)
    _write_json(args.report_dir / "direct-runtime-acceptance.json", report)
    print(json.dumps(report, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
