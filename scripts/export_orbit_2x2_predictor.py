#!/usr/bin/env python3
"""Export the pinned per-CGRA-2x2 checkpoint to the portable C++ contract.

This is an export-only adapter: it neither trains nor mutates the source
checkpoint.  The output includes the exact architecture source text and all
four learned members, so C++ can validate and run the same direct ensemble
without Python or a PyTorch runtime.
"""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
from typing import Any, Dict, Iterable, List, Mapping, Sequence

import torch
import yaml


SCHEMA = "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1"
MODEL_NAMESPACE = "orbit-per-cgra-2x2-direct-4member-v1"
PROTOCOL = "amoeba-static-rectangles-2x2-per-cgra-max4"
SOURCE_REPOSITORY = "https://github.com/guosran/cgra-ii-predictor"
SOURCE_BRANCH = "orbit-2x2-predictor"
SOURCE_COMMIT = "3ade31806cb4c92e31888109f7c42b8a77e4cbce"
EXPECTED_SHAPES = [
    [2, 2], [2, 4], [4, 2], [2, 6],
    [6, 2], [2, 8], [8, 2], [4, 4],
]


def _finite_floats(value: Any, expected: int, context: str) -> List[float]:
    if not isinstance(value, torch.Tensor) or tuple(value.shape) != (expected,):
        raise ValueError(f"{context} must be a tensor of shape [{expected}]")
    result = [float(item) for item in value.detach().cpu().tolist()]
    if any(not math.isfinite(item) for item in result):
        raise ValueError(f"{context} contains a non-finite value")
    return result


def _tensor_layer(
    state: Mapping[str, torch.Tensor], member: int, layer: int,
    input_width: int, output_width: int,
) -> Dict[str, Any]:
    prefix = f"members.{member}.regressor.{layer}"
    weight = state.get(prefix + ".weight")
    bias = state.get(prefix + ".bias")
    if not isinstance(weight, torch.Tensor) or tuple(weight.shape) != (
        output_width, input_width,
    ):
        raise ValueError(
            f"member {member} layer {layer} weight has the wrong shape"
        )
    if not isinstance(bias, torch.Tensor) or tuple(bias.shape) != (output_width,):
        raise ValueError(
            f"member {member} layer {layer} bias has the wrong shape"
        )
    weights = weight.detach().cpu().tolist()
    biases = bias.detach().cpu().tolist()
    if any(not math.isfinite(float(item)) for row in weights for item in row):
        raise ValueError(f"member {member} layer {layer} weight is non-finite")
    if any(not math.isfinite(float(item)) for item in biases):
        raise ValueError(f"member {member} layer {layer} bias is non-finite")
    return {
        "input_width": input_width,
        "output_width": output_width,
        "weights": [[float(item) for item in row] for row in weights],
        "bias": [float(item) for item in biases],
    }


def _source_candidate_metadata(metadata: Mapping[str, Any]) -> Dict[str, Any]:
    """Copy the source's candidate status and non-digest training evidence."""
    checkpoint = metadata.get("checkpoint", {})
    architecture = metadata.get("architecture", {})
    training = metadata.get("training", {})
    scope = metadata.get("scope", {})
    return {
        "package_schema": metadata.get("schema"),
        "promotion_status": metadata.get("promotion_status"),
        "target": metadata.get("target"),
        "shape_protocol_id": metadata.get("shape_protocol_id"),
        "checkpoint_schema": checkpoint.get("schema"),
        "feature_count": checkpoint.get("feature_count"),
        "effective_feature_count": checkpoint.get("effective_feature_count"),
        "ensemble_member_count": checkpoint.get("ensemble_member_count"),
        "architecture_facts": architecture.get("facts"),
        "candidate_only": True,
        "amoeba_benchmark_overlap_audit_complete": training.get(
            "amoeba_benchmark_overlap_audit_complete"
        ),
        "old_4x4_labels_reused": training.get("old_4x4_labels_reused"),
        "native_query_count": training.get("native_query_count"),
        "native_status_counts": training.get("native_status_counts"),
        "supports_whole_program_latency_or_throughput_claim": scope.get(
            "supports_whole_program_latency_or_throughput_claim"
        ),
    }


def export_bundle(candidate_dir: Path, output: Path) -> Dict[str, Any]:
    candidate_dir = candidate_dir.resolve()
    model_path = candidate_dir / "model.json"
    checkpoint_path = candidate_dir / "mapper.pt"
    architecture_path = candidate_dir / "architecture.yaml"
    for path in (model_path, checkpoint_path, architecture_path):
        if not path.is_file():
            raise ValueError(f"required candidate file is missing: {path.name}")

    metadata = json.loads(model_path.read_text(encoding="utf-8"))
    if metadata.get("schema") != "cgra-ii-per-cgra-2x2-candidate-package":
        raise ValueError("candidate package schema does not match per-CGRA 2x2")
    if metadata.get("promotion_status") != (
        "candidate_pending_amoeba_benchmark_overlap_audit"
    ):
        raise ValueError("candidate status changed; refusing to export")
    if metadata.get("shape_protocol_id") != PROTOCOL:
        raise ValueError("candidate shape protocol does not match")

    architecture_text = architecture_path.read_text(encoding="utf-8")
    architecture = yaml.safe_load(architecture_text)
    facts = metadata.get("architecture", {}).get("facts", {})
    expected_facts = {
        "multi_cgra_rows": 4,
        "multi_cgra_columns": 4,
        "per_cgra_tile_rows": 2,
        "per_cgra_tile_columns": 2,
        "total_tile_count": 64,
    }
    if facts != expected_facts:
        raise ValueError("candidate architecture facts do not match 4x4 CGRAs x 2x2 PEs")
    if architecture.get("multi_cgra_defaults", {}).get("rows") != 4 or \
       architecture.get("multi_cgra_defaults", {}).get("columns") != 4 or \
       architecture.get("per_cgra_defaults", {}).get("rows") != 2 or \
       architecture.get("per_cgra_defaults", {}).get("columns") != 2:
        raise ValueError("architecture YAML is outside the exact 4x4 x 2x2 contract")

    checkpoint = torch.load(checkpoint_path, map_location="cpu", weights_only=True)
    if not isinstance(checkpoint, dict):
        raise ValueError("checkpoint must be a state dictionary object")
    if checkpoint.get("schema") != "cgra-ii-direct-mapper-ensemble":
        raise ValueError("checkpoint schema does not match the direct ensemble")
    if checkpoint.get("output_mode") != "continuous" or \
       checkpoint.get("deployment_readout") != \
       "arithmetic_mean_bounded_continuous_regression" or \
       checkpoint.get("ranking_readout") != \
       "arithmetic_mean_bounded_continuous_regression":
        raise ValueError("checkpoint output mode or ensemble readout changed")
    if checkpoint.get("shape_protocol_id") != PROTOCOL:
        raise ValueError("checkpoint shape protocol does not match")
    if checkpoint.get("ensemble_member_count") != 4 or \
       checkpoint.get("ensemble_reduction") != "arithmetic_mean":
        raise ValueError("checkpoint must contain the exact four-member mean ensemble")
    if checkpoint.get("candidate_only") is not True:
        raise ValueError("checkpoint is not marked candidate-only")
    if checkpoint.get("supported_mapper_shapes") != EXPECTED_SHAPES or \
       checkpoint.get("training_mapper_shapes") != EXPECTED_SHAPES:
        raise ValueError("checkpoint shape lists do not match the eight-shape protocol")
    if checkpoint.get("ensemble_seeds") != [17, 41, 113, 239]:
        raise ValueError("checkpoint member seed order changed")

    config = checkpoint.get("config")
    names = checkpoint.get("feature_names")
    compact_names = checkpoint.get("compact_feature_names")
    state = checkpoint.get("state_dict")
    if not isinstance(config, dict) or not isinstance(names, list) or \
       not isinstance(compact_names, list) or not isinstance(state, dict):
        raise ValueError("checkpoint config, feature names, or state_dict is malformed")
    if len(names) != 148 or len(set(names)) != 148:
        raise ValueError("checkpoint raw feature contract must have 148 unique names")
    if len(compact_names) != 61 or len(set(compact_names)) != 61:
        raise ValueError("checkpoint selected feature contract must have 61 unique names")
    if not set(compact_names).issubset(names):
        raise ValueError("selected features are not a subset of the raw feature contract")
    if config.get("shape_protocol") != PROTOCOL or \
       config.get("hidden_dimensions") != [64, 32] or \
       float(config.get("mapper_ii_ceiling", 0.0)) != 20.0:
        raise ValueError("checkpoint architecture or output contract changed")
    if config.get("enabled_feature_names") != compact_names:
        raise ValueError("compact feature names differ from checkpoint config")

    selected_indices = [index for index, name in enumerate(names)
                        if name in set(compact_names)]
    if len(selected_indices) != 61:
        raise ValueError("selected feature indices are not complete")

    members: List[Dict[str, Any]] = []
    for member in range(4):
        mean = _finite_floats(
            state.get(f"members.{member}.feature_mean"), 148,
            f"member {member} feature_mean",
        )
        scale = _finite_floats(
            state.get(f"members.{member}.feature_scale"), 148,
            f"member {member} feature_scale",
        )
        if any(value <= 0.0 for value in scale):
            raise ValueError(f"member {member} feature_scale must be positive")
        members.append({
            "member_index": member,
            "seed": checkpoint["ensemble_seeds"][member],
            "feature_mean": mean,
            "feature_scale": scale,
            "layers": [
                _tensor_layer(state, member, 0, 61, 64),
                _tensor_layer(state, member, 2, 64, 32),
                _tensor_layer(state, member, 4, 32, 1),
            ],
        })

    bundle = {
        "schema": SCHEMA,
        "model_namespace": MODEL_NAMESPACE,
        "source_model": {
            "repository": SOURCE_REPOSITORY,
            "branch": SOURCE_BRANCH,
            "commit": SOURCE_COMMIT,
            "candidate_metadata": _source_candidate_metadata(metadata),
        },
        "feature_contract": {
            "contract_id": "cgra-ii-pre-mapper-features-148-2x2-per-cgra-v1",
            "extractor": "cgra_ii_predictor.mapper_model:mapper_feature_vector",
            "shape_protocol_id": PROTOCOL,
            "feature_width": 148,
            "feature_names": names,
            "selected_feature_indices": selected_indices,
            "selected_feature_names": [names[index] for index in selected_indices],
        },
        "shape_protocol": {
            "protocol_id": PROTOCOL,
            "supported_mapper_tile_shapes": [
                {"rows": rows, "cols": cols} for rows, cols in EXPECTED_SHAPES
            ],
            "orientation_equivalent": False,
            "maximum_physical_cgras_per_task": 4,
        },
        "architecture": {
            "name": "AMOEBA_4x4_CGRA_2x2_Tiles",
            "exact_yaml_text": architecture_text,
        },
        "network": {
            "input_width": 148,
            "hidden_dimensions": [64, 32],
            "selected_input_width": 61,
            "activation": "gelu_erf",
            "residual_activation": "softplus",
            "lower_bound_rule": "max(rec_mii,res_mii)",
            "output_rule": "min(lower_bound + softplus(logit), mapper_ii_ceiling)",
            "mapper_ii_ceiling": 20.0,
            "ensemble_reduction": "arithmetic_mean",
        },
        "members": members,
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(bundle, indent=2, sort_keys=True) + "\n",
                      encoding="utf-8")
    return bundle


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--candidate-dir", type=Path,
        default=Path("models/candidates/per-cgra-2x2"),
    )
    parser.add_argument(
        "--output", type=Path,
        default=Path("models/candidates/per-cgra-2x2/ensemble.json"),
    )
    args = parser.parse_args()
    bundle = export_bundle(args.candidate_dir, args.output)
    print(
        f"exported {len(bundle['members'])} direct members, "
        f"{bundle['feature_contract']['feature_width']} raw features, "
        f"{len(bundle['feature_contract']['selected_feature_indices'])} selected features"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
