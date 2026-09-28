"""Backend payload and scheduler trace invariants for future source adapters."""
from modules.contracts import EXACT_ORACLE_MAX_ACTIVITIES

SCHEDULERS = {"fixed", "critical_path", "pipeline_aware", "beam", "exact"}


def validate_edge_payload(edge):
    """Validate a normalized source TaskEdgeGraph edge, never infer new edges."""
    if edge.get("source") != "canonical_TaskEdgeGraph":
        raise ValueError("communication must consume canonical TaskEdgeGraph")
    kind = edge["kind"]
    scope = edge["scope"]
    if kind == "completion":
        if edge["payload_bits"] != 0 or edge.get("numeric_reduction"):
            raise ValueError("completion join is synchronization only")
        return True
    if edge.get("unknown_access") or edge.get("conservative_alias"):
        if scope != "tensor_wide":
            raise ValueError("unknown access requires tensor-wide fallback")
    if scope == "tile_local":
        if edge.get("transferred_region") != edge.get("producer_region"):
            raise ValueError("tile-local edge must transfer corresponding region")
        if edge["payload_bits"] != edge["region_elements"] * edge["bits_per_element"]:
            raise ValueError("tile-local payload does not match region")
    elif scope == "tensor_wide":
        if edge["payload_bits"] != edge["tensor_elements"] * edge["bits_per_element"]:
            raise ValueError("tensor-wide edge must transfer whole-result payload")
    elif scope == "halo":
        if edge["payload_bits"] < edge["region_elements"] * edge["bits_per_element"]:
            raise ValueError("halo payload cannot omit required region")
    else:
        raise ValueError("unknown communication scope")
    return True


def validate_schedule_trace(trace):
    policy = trace["policy"]
    if policy not in SCHEDULERS:
        raise ValueError("unsupported scheduling policy")
    steps = trace["steps"]
    if policy == "exact" and len(steps) > EXACT_ORACLE_MAX_ACTIVITIES:
        raise ValueError("exact oracle is limited to small graphs")
    if policy == "beam" and (type(trace.get("beam_width")) is not int or trace["beam_width"] < 1):
        raise ValueError("beam width missing")
    chosen = set()
    dynamic = False
    for step in steps:
        ready = step["ready_set"]
        activity = step["chosen_activity"]
        if activity not in ready or activity in chosen:
            raise ValueError("chosen activity is not a new ready activity")
        if not step.get("placement") or "incoming_routes" not in step:
            raise ValueError("placement or incoming routes missing")
        if step["start"] < step["communication_ready_time"] or step["end"] < step["start"]:
            raise ValueError("invalid communication-ready schedule interval")
        if not step.get("resource_occupancy"):
            raise ValueError("resource occupancy missing")
        dynamic |= len(ready) > 1 and activity != sorted(ready)[0]
        chosen.add(activity)
    if trace.get("makespan") != max((step["end"] for step in steps), default=0):
        raise ValueError("makespan differs from scheduled end times")
    if policy in {"pipeline_aware", "beam"} and not dynamic:
        raise ValueError("fixture does not demonstrate dynamic ready-set choice")
    return True

