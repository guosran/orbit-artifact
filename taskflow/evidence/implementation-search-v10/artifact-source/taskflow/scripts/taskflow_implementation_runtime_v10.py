#!/usr/bin/env python3
"""Reusable measurement-policy identity; exact per-case evidence stays separate."""
from pathlib import Path
from taskflow_implementation_search_v10 import load
from collect_direct_air_feedback_v9 import case_preparation_contract, runtime_identity as exact_runtime_identity


def runtime_identity(profile, invocation, timing):
    exact, cases = case_preparation_contract(profile, invocation)
    if invocation.get('observer')!=timing['observer']:
        raise ValueError('observer differs from predeclared policy')
    for policy in exact['case_policies']:
        abi=load(invocation['identities'][policy['profile_name']]['abi_path'])
        scratch=sorted(i for i,b in enumerate(abi['buffers']) if b['role']=='temporary')
        inputs=sorted(i for i,b in enumerate(abi['buffers']) if b['role']=='input')
        outputs=sorted(i for i,b in enumerate(abi['buffers']) if b['role']=='output')
        if policy['static_indices'] or policy['intermediate_indices']!=scratch or policy['per_call_input_indices']!=inputs or policy['output_indices']!=outputs:
            raise ValueError('actual BO state differs from declared role policy')
        if len(policy['actual_warmups_by_seed'])!=3 or any(n!=timing['warmups'] for n in policy['actual_warmups_by_seed'].values()):
            raise ValueError('actual warmups or seed count differ from preregistration')
        if any(n!=timing['hot'] for n in policy['labeled_hot_calls_by_seed'].values()):
            raise ValueError('actual hot sample count differs from preregistration')
        if policy['hot_state']!='warmup-before-all-labeled-hot':
            raise ValueError('labeled calls must follow completed warmups')
    canonical=dict(schema='orbit.implementation-search.preparation-policy.v10',
        inputs='all ABI role=input buffers staged on every call',static_inputs=False,
        temporary='all ABI role=temporary buffers passed as intermediate_indices',
        outputs='all ABI role=output buffers synchronized and copied; never static',
        per_seed_context=True,bo_key='profile',observer=timing['observer'],
        warmups=timing['warmups'],hot=timing['hot'],seeds=3,
        scope='preparation role policy; concrete ABI shapes, names and candidate counts are separately bound evidence')
    identity=exact_runtime_identity(profile,invocation,preparation=canonical)
    return identity,dict(canonical_policy=canonical,exact_per_case_contract=exact,cases=cases)
