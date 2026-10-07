#!/usr/bin/env python3
"""Audit existing LLaMA archives without restoring files or running a search."""
import argparse
from collections import Counter, defaultdict
import hashlib
import json
from pathlib import Path
import tarfile

import run_sequential_comparison as comparison
import show_sequential_comparison as evidence
from sequential_validation_audit import require_complete_validation


def hash_value(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode()).hexdigest()


def hash_stream(stream):
    digest, size = hashlib.sha256(), 0
    for block in iter(lambda: stream.read(1024 * 1024), b""):
        digest.update(block); size += len(block)
    return digest.hexdigest(), size


def native_winner(cell):
    value = comparison.read(cell / "result.json")
    require_complete_validation(value)
    native = min(value["native_top5"]["records"] + value["native_controls"]["records"], key=lambda r: r["native_cycles"])
    selection = next(r for r in value["top5"] + value["controls"] if
                     (r["rank"], r["candidate_id"]) == (native["rank"], native["candidate_id"]))
    return native, selection


def scan(cell, winner_id, target_history=None, target_path=None):
    manifest_path = cell / "raw-auxiliary-manifest.json"
    manifest = comparison.read(manifest_path)
    if manifest["schema"] != "orbit-lossless-auxiliary-archive-v1":
        raise ValueError("unexpected auxiliary manifest schema")
    rows = {r["path"]: r for r in manifest["files"]}
    if len(rows) != len(manifest["files"]):
        raise ValueError("duplicate manifest member")
    archive_path = cell / "raw-auxiliary.tar.gz"
    archive_binding = comparison.file_binding(archive_path)
    if archive_binding["size"] != manifest["archive_bytes"]:
        raise ValueError("auxiliary archive size changed")
    graphs, bodies, valid, candidates, parents, winner = {}, {}, [], [], Counter(), None
    prefix, label_prefix, extended = defaultdict(list), defaultdict(list), Counter()
    verified = set()
    def verify(member, digest, size):
        bound = rows.get(member.name)
        if bound is None or (size, digest) != (bound["size"], bound["sha256"]) or size != member.size:
            raise ValueError("archived member binding mismatch: " + member.name)
        verified.add(member.name)
    with tarfile.open(archive_path, "r|gz") as archive:
        for member in archive:
            name = member.name
            if name == "search/archive.jsonl":
                digest, size = hashlib.sha256(), 0
                for line_number, line in enumerate(archive.extractfile(member), 1):
                    digest.update(line); size += len(line)
                    row = json.loads(line)
                    if row.get("record_type") != "candidate":
                        continue
                    candidates.append((line_number, row))
                    parents[row.get("parent_candidate_id")] += 1
                    if row["candidate_id"] == winner_id:
                        winner = row
                    if row.get("valid"):
                        key = row["candidate_key"]
                        valid.append((row["candidate_id"], row["graph_facts_key"], key.split("|", 1)[1], row["predicted_whole_program_cycles"]))
                    if target_history is None:
                        continue
                    record = {k: row.get(k) for k in ("candidate_id", "parent_candidate_id", "round", "valid", "reject_reason", "graph_facts_key", "candidate_key", "predicted_whole_program_cycles")}
                    history = row.get("action_history", {})
                    actions = history.get("actions", [])
                    paths = [row.get("action_path", [])] + row.get("alternate_action_paths", [])
                    for n in range(1, len(target_path) + 1):
                        if any(p == target_path[:n] for p in paths):
                            label_prefix[n].append(record)
                        if any(len(p) >= n and p[:n] == target_path[:n] for p in paths):
                            extended[n] += 1
                        if (history.get("known") is True and actions == target_history["actions"][:n]
                                and history.get("initialShapes") == target_history["initialShapes"]):
                            prefix[n].append(record)
                verify(member, digest.hexdigest(), size)
            elif name.startswith("search/witnesses/graph-") and name.endswith(".txt"):
                payload = archive.extractfile(member).read()
                verify(member, hashlib.sha256(payload).hexdigest(), len(payload))
                document = json.loads(payload)
                graphs[Path(name).stem] = (hash_value(json.loads(document["canonical_structural_facts"])),
                    tuple(document["typed_kernel_body_ids"]), hash_value(document["partition_lineages"]))
            elif name.startswith("search/witnesses/body-") and name.endswith(".txt"):
                digest, size = hash_stream(archive.extractfile(member))
                verify(member, digest, size); bodies[Path(name).stem] = digest
    expected = {p for p in rows if p == "search/archive.jsonl" or
                (p.startswith(("search/witnesses/graph-", "search/witnesses/body-")) and p.endswith(".txt"))}
    if verified != expected or winner is None:
        raise ValueError("missing archived diagnostic evidence")
    expanded = {gid: (facts, tuple(bodies[b] for b in ids), partition) for gid, (facts, ids, partition) in graphs.items()}
    return dict(artifact=dict(archive=archive_binding, manifest=comparison.file_binding(manifest_path),
                    member_bindings=rows, verified_relevant_members=len(verified)), winner=winner,
                graphs=expanded, bodies=bodies, valid=valid, candidates=candidates, parents=parents,
                prefix=prefix, label_prefix=label_prefix, extended=extended)


def numeric_tie_key(row):
    choices = row["task_choices"]
    task_index = {choice["task"]: i for i, choice in enumerate(choices)}
    key = []
    for choice in choices:
        key.extend((int(choice["rows"]), int(choice["cols"])))
    for placement in row["task_schedule"]:
        key.extend((task_index[placement["task"]], int(placement["row"]), int(placement["col"]),
                    int(placement["start_cycle"]), int(placement["end_cycle"]), int(placement["idle_cycles"])))
    key.extend(task_index[task] for task in row["dispatch_order"])
    return key


def configuration(row):
    path = row["action_path"]
    return (path[-1] if path else "identity") + "|" + "".join(f"{s['rows']}x{s['cols']};" for s in row["shapes"])


def reconstruct_beam(entries, width, diversity, targets):
    valid_rows = [row for _, row in entries if row.get("valid")]
    sort_keys = {r["candidate_id"]: (int(r["predicted_whole_program_cycles"]), numeric_tie_key(r),
                r["candidate_key"], r["candidate_id"]) for r in valid_rows}
    identity = next(r for r in valid_rows if "identity" in r.get("control_roles", []))
    def select(rows):
        ordered = sorted(rows, key=lambda r: sort_keys[r["candidate_id"]])
        kept, keys, configs, slots = [], set(), set(), {"cost": [], "diversity": [], "fill": []}
        for role in ("cost", "diversity", "fill"):
            limit = width - diversity if role == "cost" else width
            for row in ordered:
                if len(kept) >= limit:
                    break
                key, config = row["candidate_key"], configuration(row)
                if not key or key in keys or (role == "diversity" and config in configs):
                    continue
                kept.append(row); keys.add(key); configs.add(config)
                slots[role].append(row["candidate_id"])
        return dict(ordered=ordered, selected=kept, slots=slots)
    def ids(rows):
        return [r["candidate_id"] for r in rows]
    rounds = {}
    for round_no, target_id in targets.items():
        children = [(line, r) for line, r in entries if r.get("valid") and r.get("round") == round_no and r.get("parent_candidate_id")]
        if len({r["candidate_key"] for _, r in children}) != len(children):
            raise ValueError("duplicate valid archive key in Joint frontier")
        generated, seen, insertion = [], [], None
        all_prefix_selections_match = True
        for ordinal, (line, row) in enumerate(children, 1):
            seen.append(row)
            immediate = select(generated + [row])
            one_shot = select(seen)
            all_prefix_selections_match &= ids(immediate["selected"]) == ids(one_shot["selected"])
            if row["candidate_id"] == target_id:
                insertion = dict(archive_line_1based=line, valid_child_ordinal_1based=ordinal,
                    scored_children_seen=len(seen), incremental_selection_input_count=len(generated) + 1,
                    rank_among_all_scored_children_seen=ids(one_shot["ordered"]).index(target_id) + 1,
                    rank_in_actual_incremental_selection=ids(immediate["ordered"]).index(target_id) + 1,
                    selected_after_immediate_selectBeam=target_id in ids(immediate["selected"]),
                    actual_immediate_slot_ids=immediate["slots"],
                    actual_immediate_selected_ids=ids(immediate["selected"]),
                    target=dict(candidate_id=target_id, parent_candidate_id=row["parent_candidate_id"],
                                valid=row["valid"], predicted_cycles=row["predicted_whole_program_cycles"],
                                configuration=configuration(row)),
                    target_config_unique_among_seen=sum(configuration(r) == configuration(row) for r in seen) == 1)
            generated = immediate["selected"]
        boundary = select(generated)
        full = select([r for _, r in children])
        if ids(boundary["selected"]) != ids(full["selected"]) or not all_prefix_selections_match:
            raise ValueError("incremental beam differs from full-prefix selection; do not use full-round ranks for attribution")
        beam = list(boundary["selected"])
        popped = None
        if not any(r["candidate_key"] == identity["candidate_key"] for r in beam):
            if len(beam) >= width:
                popped = beam.pop()["candidate_id"]
            beam.append(identity)
        next_parents = sorted({r["parent_candidate_id"] for _, r in entries
            if r.get("round") == round_no + 1 and r.get("parent_candidate_id")})
        expected_parents = sorted(ids(beam))
        if next_parents != expected_parents:
            raise ValueError("reconstructed next-round beam does not match observed archive parent set")
        rounds[str(round_no)] = dict(valid_children=len(children), all_prefix_selections_match=True,
            incremental_child_beam_before_identity=ids(boundary["selected"]),
            slots_before_identity=boundary["slots"], identity_injection_popped_candidate=popped,
            beam_after_identity=ids(beam), target_candidate_id=target_id,
            target_rank_among_all_round_children=ids(full["ordered"]).index(target_id) + 1,
            target_in_next_beam=target_id in ids(beam), target_insertion=insertion,
            expected_next_round_parent_ids=expected_parents, actual_next_round_parent_ids=next_parents,
            next_round_parent_set_matches=True)
    return dict(beam_width=width, diversity_slots=diversity, rounds=rounds)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, default=comparison.ROOT / "results/sequential-comparison-4096-fast2-host")
    parser.add_argument("--output-dir", type=Path, default=comparison.ROOT / "diagnostics/sequential-comparison-4096-fast2-host/llama-path-diagnosis")
    args = parser.parse_args(); root, output = args.results_root.resolve(), args.output_dir.resolve()
    seq_cell, joint_cell = root / "llama/sequential-50", root / "llama/joint"
    evidence.audit_bindings(root, [("llama", "joint"), ("llama", "sequential-50")])
    joint_binding = comparison.read(joint_cell / "comparison-binding.json")
    source_contract = comparison.read(joint_binding["source_contract"])
    beam_source = next(r for r in source_contract["sources"] if r["path"] ==
                       "lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp")
    seq_native, seq_selection = native_winner(seq_cell); joint_native, joint_selection = native_winner(joint_cell)
    seq = scan(seq_cell, seq_native["candidate_id"])
    joint = scan(joint_cell, joint_native["candidate_id"], seq_selection["action_history"], seq_selection["action_path"])
    joint_search = comparison.read(joint_cell / "search/search-summary.json")
    if joint_search["decision_flow"] != "joint":
        raise ValueError("beam reconstruction expects standalone Joint")
    targets = {r["round"]: r["candidate_id"] for values in joint["prefix"].values() for r in values if r["valid"]}
    beam = reconstruct_beam(joint["candidates"], joint_search["beam_width"], joint_search["diversity_slots"], targets)
    witness = seq["graphs"][seq_selection["graph_facts_key"]]
    matches = {gid for gid, value in joint["graphs"].items() if value == witness}
    suffix = seq_selection["candidate_key"].split("|", 1)[1]
    resource_matches = [dict(candidate_id=cid, graph_facts_key=gid, candidate_key_suffix=tail, predicted_cycles=score)
                        for cid, gid, tail, score in joint["valid"] if gid in matches and tail == suffix]
    matched_parents = {r["candidate_id"] for values in joint["prefix"].values() for r in values}
    report = dict(schema="orbit-llama-sequential-path-diagnosis-v1", input_bindings=[comparison.file_binding(p) for p in
        (Path(__file__).resolve(), seq_cell / "result.json", joint_cell / "result.json")],
        archive_identities={"sequential-50": seq["artifact"], "joint": joint["artifact"]},
        beam_algorithm_binding=dict(source_contract=joint_binding["content_binding"]["source_contract"],
            optimizer=joint_binding["content_binding"]["optimizer"], source_path=beam_source["path"],
            source_text_sha256=hashlib.sha256(beam_source["text"].encode()).hexdigest(),
            contract="standalone Joint; source stateLess/selectBeam/retainCanonicalBeam; successful-score archive order"),
        graph_equivalence_definition="parsed canonical structural facts, ordered exact typed-body witness SHA256s and partition lineage facts; resource suffix includes active-transfer proof when present; never compare run-local graph IDs",
        seq_winner_graph_witness=dict(structural_facts_sha256=witness[0], ordered_body_sha256=witness[1], partition_lineages_sha256=witness[2]),
        graph_witness_counts={"joint": len(joint["graphs"]), "sequential-50": len(seq["graphs"])},
        joint_graph_component_match_counts={"structural_facts": sum(v[0] == witness[0] for v in joint["graphs"].values()),
            "ordered_body_witnesses": sum(v[1] == witness[1] for v in joint["graphs"].values()),
            "partition_lineages": sum(v[2] == witness[2] for v in joint["graphs"].values()), "full_graph": len(matches)},
        joint_exact_graph_and_resource_candidates=resource_matches,
        joint_exact_typed_action_prefix_records=dict(joint["prefix"]),
        joint_label_path_prefix_records=dict(joint["label_prefix"]),
        joint_label_prefix_extension_counts=dict(joint["extended"]),
        joint_direct_archive_children_of_typed_prefix_candidates={cid: joint["parents"][cid] for cid in sorted(matched_parents)},
        joint_beam_reconstruction=beam,
        winners={"joint": dict(native_cycles=joint_native["native_cycles"], predicted_cycles=joint_selection["predicted_whole_program_cycles"], selection=joint_selection),
                 "sequential-50": dict(native_cycles=seq_native["native_cycles"], predicted_cycles=seq_selection["predicted_whole_program_cycles"], selection=seq_selection)},
        final_ranking_direction=dict(predicted_sequential_over_joint=seq_selection["predicted_whole_program_cycles"] / joint_selection["predicted_whole_program_cycles"],
                                     native_sequential_over_joint=seq_native["native_cycles"] / joint_native["native_cycles"]),
        extra_objective_evaluations=0, extra_predictor_queries=0, extra_mapper_calls=0,
        limitations=["archive child absence alone cannot prove beam eviction; attempt trace lacks parent/round IDs",
                     "canonical witness equality is the implemented dedup equivalence, not a proof against every possible semantic reformulation",
                     "final winner ordering agrees between prediction and mapper; this does not validate every intermediate ranking"])
    output.mkdir(parents=True, exist_ok=True)
    comparison.replay.atomic_write(output / "results.json", report)
    lines = ["LLaMA 路径审计：所有数据来自既有档案，未增加搜索、预测或mapper预算。", "",
        f"Joint {joint_native['native_cycles']:,} cycles；Sequential 50/50 {seq_native['native_cycles']:,} cycles；Sequential / Joint = {report['final_ranking_direction']['native_sequential_over_joint']:.6f}。",
        f"Sequential winner {seq_native['candidate_id']}，完整图canonical等价匹配 {len(matches)}，完整图及资源配置匹配 {len(resource_matches)}；Joint graph witnesses {len(joint['graphs'])}。", "",
        "| 相同typed动作前缀长度 | Joint候选 | 父候选 | round | 预测makespan | 直接archive子候选数 |", "|---:|---|---|---:|---:|---:|"]
    for n, records in sorted(joint["prefix"].items()):
        for r in records:
            lines.append(f"| {n} | {r['candidate_id']} | {r['parent_candidate_id']} | {r['round']} | {r['predicted_whole_program_cycles']} | {joint['parents'][r['candidate_id']]} |")
    lines += ["", "按pinned控制器重建增量beam，每个prefix选择均与完整已评分prefix选择一致；下一轮父候选集合与原档案完全相同。"]
    for round_no, r in beam["rounds"].items():
        i = r["target_insertion"]
        lines.append(f"round {round_no}: {r['target_candidate_id']} 为第{i['valid_child_ordinal_1based']}个合法child，已评分{i['scored_children_seen']}个child中rank{i['rank_among_all_scored_children_seen']}；实际增量保留输入{i['incremental_selection_input_count']}项中rank{i['rank_in_actual_incremental_selection']}；下一轮beam保留={r['target_in_next_beam']}。")
    lines += ["", "第二步候选合法且已经评估，失去的是beam扩展机会，永久archive仍保留。最终两种方案的预测排序方向与真实mapper排序一致。member SHA256和大小逐项核验；tar SHA为本次审计身份，历史manifest绑定的是各未压缩member。"]
    (output / "results.md").write_text("\n".join(lines) + "\n")
    print(json.dumps({"graph_matches": len(matches), "resource_matches": len(resource_matches),
        "typed_prefix_lengths": sorted(joint["prefix"]), "evidence": str(output / "results.json")}))


if __name__ == "__main__":
    main()
