"""Validate fixed phase caps and the separately labelled unused-budget variant."""


def expected_phase_budgets(search, cap, percent, policy="fixed-split"):
    nominal = {"A": cap * percent // 100, "B": cap - cap * percent // 100}
    if policy == "fixed-split":
        if search.get("sequential_budget_policy", "fixed-split") != policy:
            raise ValueError("transfer metadata cannot enter the fixed-split main table")
        return nominal
    if policy != "transfer-unused" or search.get("sequential_budget_policy") != policy:
        raise ValueError("unknown or mismatched Sequential budget policy")
    counts = search.get("phase_evaluations", {})
    actual_a = counts.get("A")
    if type(actual_a) is not int or not 0 <= actual_a <= nominal["A"]:
        raise ValueError("invalid phase A evaluation count")
    expected_transfer = (nominal["A"] - actual_a
                         if search.get("phase_a_stop_reason") == "no-new-legal-candidates" else 0)
    transfer = search.get("transferred_evaluation_count")
    if type(transfer) is not int or transfer != expected_transfer:
        raise ValueError("unused A allowance may transfer only on candidate exhaustion")
    effective = {"A": nominal["A"] - transfer, "B": nominal["B"] + transfer}
    if search.get("nominal_phase_budgets") != nominal or search.get("effective_phase_budgets") != effective:
        raise ValueError("nominal/effective phase allowance metadata mismatch")
    if sum(effective.values()) != cap:
        raise ValueError("transferred phase caps exceed the total allowance")
    return effective
