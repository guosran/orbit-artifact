#!/usr/bin/env python3
"""Invoke mapper/native processes for a C++ selected global shortlist.

The compiler owns selection, mapping, placement and communication. Python
asserts the emitted records and renders their evidence; no search is here.
"""
from __future__ import annotations
import argparse, gzip, importlib.util, json, re, subprocess
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
import validate_embedded_native_trace as trace_validator
ROOT=Path(__file__).resolve().parents[1]
FISSION_STAGE = 'full-joint-fission'
ACTION_SCHEMA = 'orbit-joint-neighborhood-typed-actions-v1'
HISTORY_SCHEMA = 'orbit-joint-neighborhood-typed-actions-v1'
REPLAY_FACTS_SCHEMA = 'orbit-joint-neighborhood-action-replay-facts-v1'
FISSION_SOURCE_REPLAY_CONTRACTS = {
    'orbit-taskflow-fission-source-replay-v1',
    'orbit-taskflow-fission-source-replay-v2-ordinary-suffix-rebase',
}
COMMON_INTER_TASK_NETWORK = Path(
    'config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml')

def write(p, value):
    p.parent.mkdir(parents=True, exist_ok=True)
    temp=p.with_name(p.name+'.partial');temp.write_text(json.dumps(value,indent=2,sort_keys=True)+'\n');temp.replace(p)

def invoke(argv, directory, label):
    directory.mkdir(parents=True, exist_ok=True)
    out=directory/(label+'.stdout.gz');err=directory/(label+'.stderr.gz')
    began=datetime.now(timezone.utc).isoformat()
    write(directory/(label+'.command.json'), {'argv':argv,'status':'running','started_utc':began,'stdout_log':str(out),'stderr_log':str(err)})
    with out.open('wb') as out_file,err.open('wb') as err_file:
        o=subprocess.Popen(['gzip','-c','-n'],stdin=subprocess.PIPE,stdout=out_file)
        e=subprocess.Popen(['gzip','-c','-n'],stdin=subprocess.PIPE,stdout=err_file)
        try: result=subprocess.run(argv,cwd=ROOT,stdout=o.stdin,stderr=e.stdin)
        finally:
            o.stdin.close();e.stdin.close();o.wait();e.wait()
    record={'argv':argv,'status':'finished','exit_code':result.returncode,'started_utc':began,'ended_utc':datetime.now(timezone.utc).isoformat(),'stdout_log':str(out),'stderr_log':str(err)}
    write(directory/(label+'.command.json'),record)
    return record


class FissionReplayError(RuntimeError):
    """A selected fission row could not be independently source-replayed."""


def _json_file(path, description):
    try:
        value = json.loads(Path(path).read_text(encoding='utf-8'))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise FissionReplayError(f'{description} is unreadable: {error}') from error
    if not isinstance(value, dict):
        raise FissionReplayError(f'{description} must contain a JSON object')
    return value


def _fresh_replay_directory(parent):
    base = parent / 'source-fission-replay'
    candidate = base
    serial = 1
    while candidate.exists() or candidate.is_symlink():
        candidate = parent / f'source-fission-replay-{serial:03d}'
        serial += 1
    return candidate


def _validate_fission_network_binding(args, public_binding, witness,
                                     bound_protocol):
    """Tie the public network path/text to the exact C++ network bytes.

    The C++ continuation witness intentionally binds the network document by
    exact bytes and omits its path.  The path is therefore checked across the
    protocol, public source binding, and replay CLI before comparing the C++
    byte witness.
    """
    network_path = getattr(args, 'inter_task_network', None)
    if network_path is None:
        raise FissionReplayError(
            'full-joint-fission replay requires --inter-task-network')
    network_path = Path(network_path)
    expected_path = (ROOT / COMMON_INTER_TASK_NETWORK).resolve()
    if (not network_path.is_file() or network_path.is_symlink() or
            network_path.resolve() != expected_path):
        raise FissionReplayError(
            'fission replay must use the unchanged common inter-task network path')

    protocol_value = bound_protocol.get('inter_task_network_spec')
    if not isinstance(protocol_value, str) or not protocol_value:
        raise FissionReplayError(
            'bound protocol lacks inter_task_network_spec')
    expanded_protocol_path = protocol_value.replace('${ARTIFACT_ROOT}', str(ROOT))
    protocol_path = Path(expanded_protocol_path)
    if not protocol_path.is_absolute():
        protocol_path = ROOT / protocol_path
    if protocol_path.resolve() != expected_path:
        raise FissionReplayError(
            'bound protocol does not name the unchanged common inter-task network')

    public_network_paths = [
        public_binding[key]
        for key in ('inter_task_network', 'inter_task_network_spec')
        if key in public_binding
    ]
    if (not public_network_paths or
            any(not isinstance(value, str) or
                Path(value).resolve() != expected_path
                for value in public_network_paths)):
        raise FissionReplayError(
            'public source binding does not name the common inter-task network path')
    try:
        network_bytes = network_path.read_bytes()
        network_text = network_bytes.decode('utf-8')
    except (OSError, UnicodeDecodeError) as error:
        raise FissionReplayError(
            f'common inter-task network is unreadable or not UTF-8 text: {error}') from error
    if public_binding.get('inter_task_network_text') != network_text:
        raise FissionReplayError(
            'public source binding network text differs from the replay network file')

    cxx_network = witness.get('inter_task_network_spec_override')
    if (not isinstance(cxx_network, dict) or
            cxx_network.get('exact_bytes') != network_text):
        raise FissionReplayError(
            'C++ search binding network bytes differ from the public replay network')
    cxx_network_path = cxx_network.get('path')
    if (cxx_network_path is not None and
            (not isinstance(cxx_network_path, str) or
             Path(cxx_network_path).resolve() != expected_path)):
        raise FissionReplayError(
            'C++ search binding network path differs from the common network')


def _check_search_binding(selection, args, prepared_bytes, prepared_text,
                          public_binding):
    witness_value = selection.get('source_binding_witness')
    if not isinstance(witness_value, str) or not witness_value:
        raise FissionReplayError('selection has no source_binding_witness')
    witness_path = Path(witness_value).resolve()
    witness = _json_file(witness_path, 'C++ source binding witness')
    if (witness.get('schema') != 'orbit-neighborhood-exact-binding-v1' or
            witness.get('stage') != FISSION_STAGE):
        raise FissionReplayError('C++ source binding does not name full-joint-fission')
    if (witness.get('prepared_source_file') != str(args.prepared_source_file.resolve()) or
            witness.get('prepared_source_exact_bytes') != prepared_text or
            witness.get('max_fission_actions_per_task') != args.max_fission_actions_per_task or
            not witness.get('prepared_source_lowering_pipeline') or
            not isinstance(witness.get('fission_source_replay'), str) or
            witness.get('fission_source_replay') not in FISSION_SOURCE_REPLAY_CONTRACTS):
        raise FissionReplayError('C++ source binding has a different prepared source, cut cap, or lowering policy')
    files = witness.get('files')
    prepared_record = files.get('prepared_taskflow_source') if isinstance(files, dict) else None
    if (not isinstance(prepared_record, dict) or
            prepared_record.get('path') != str(args.prepared_source_file.resolve()) or
            prepared_record.get('exact_bytes') != prepared_text):
        raise FissionReplayError('C++ source binding lacks the exact prepared Taskflow source bytes')
    protocol_record = files.get('protocol')
    if not isinstance(protocol_record, dict) or not isinstance(protocol_record.get('exact_bytes'), str):
        raise FissionReplayError('C++ source binding lacks exact protocol bytes')
    try:
        bound_protocol = json.loads(protocol_record['exact_bytes'])
    except json.JSONDecodeError as error:
        raise FissionReplayError('C++ source binding protocol bytes are not JSON') from error
    bound_search = bound_protocol.get('search') if isinstance(bound_protocol, dict) else None
    if (not isinstance(bound_search, dict) or
            bound_protocol.get('stage_scheme') != FISSION_STAGE or
            bound_search.get('max_fission_actions_per_task') !=
            args.max_fission_actions_per_task or
            bound_search.get('max_partition_factor', 4) != args.max_partition_factor or
            witness.get('max_partition_factor') != args.max_partition_factor):
        raise FissionReplayError('C++ source binding protocol does not bind the requested fission cap')
    workload = getattr(args, 'workload', None)
    by_workload = bound_search.get('active_transfer_arguments_by_workload', {})
    if not isinstance(by_workload, dict):
        raise FissionReplayError('bound active-transfer workload map is malformed')
    configured = by_workload.get(workload, bound_search.get('active_transfer_arguments', []))
    require_proven = bound_search.get('active_transfer_require_proven', True)
    if (not isinstance(configured, list) or
            any(not isinstance(item, int) or isinstance(item, bool) or item < 0
                for item in configured) or len(set(configured)) != len(configured) or
            not isinstance(require_proven, bool)):
        raise FissionReplayError('bound active-transfer arguments are malformed')
    active_transfer = witness.get('active_transfer_proof')
    if configured:
        expected_proof = {
            'schema': 'orbit-static-active-transfer-proof-v1',
            'arguments_option': ','.join(str(item) for item in configured),
            'arguments': configured,
            'require_proven': require_proven,
            'witness_encoding': 'exact-byte-interned-active-transfer-v1',
        }
        if active_transfer != expected_proof:
            raise FissionReplayError('C++ source binding active-transfer proof differs from the protocol')
    elif active_transfer:
        raise FissionReplayError('C++ source binding has active-transfer proof absent from the protocol')
    protocol_arg = getattr(args, 'protocol', None)
    if protocol_arg is None:
        raise FissionReplayError('full-joint-fission replay requires the public protocol path')
    try:
        protocol_bytes = protocol_arg.read_bytes()
    except OSError as error:
        raise FissionReplayError(f'public protocol is unreadable: {error}') from error
    if (protocol_bytes != protocol_record['exact_bytes'].encode('utf-8') or
            Path(str(protocol_record.get('path', ''))).resolve() != protocol_arg.resolve()):
        raise FissionReplayError('C++ and public protocol snapshots differ')
    source_contract_arg = getattr(args, 'source_contract_file', None)
    source_contract_record = files.get('source_and_model_contract')
    if source_contract_arg is None:
        raise FissionReplayError('full-joint-fission replay requires the public source-contract path')
    try:
        expected_contract = source_contract_arg.read_bytes()
        expected_contract_text = expected_contract.decode('utf-8')
    except OSError as error:
        raise FissionReplayError(f'public source contract is unreadable: {error}') from error
    except UnicodeDecodeError as error:
        raise FissionReplayError('public source contract is not UTF-8 text') from error
    if (not isinstance(source_contract_record, dict) or
            source_contract_record.get('exact_bytes') != expected_contract_text or
            Path(str(source_contract_record.get('path', ''))).resolve() != source_contract_arg.resolve()):
        raise FissionReplayError('C++ and public source-contract snapshots differ')
    architecture_record = files.get('architecture')
    try:
        expected_architecture = args.architecture.read_bytes().decode('utf-8')
    except (OSError, UnicodeDecodeError) as error:
        raise FissionReplayError('public architecture is unreadable or not UTF-8 text') from error
    if (not isinstance(architecture_record, dict) or
            architecture_record.get('exact_bytes') != expected_architecture or
            Path(str(architecture_record.get('path', ''))).resolve() != args.architecture.resolve()):
        raise FissionReplayError('C++ and public architecture snapshots differ')
    _validate_fission_network_binding(args, public_binding, witness,
                                      bound_protocol)
    return witness_path, witness, configured, require_proven


def _typed_fission_actions(selection):
    history = selection.get('action_history')
    if (not isinstance(history, dict) or history.get('schema') != HISTORY_SCHEMA or
            history.get('known') is not True):
        raise FissionReplayError('selection has no authenticated typed action history')
    fission_actions = history.get('fissionActions')
    actions = history.get('actions')
    initial_shapes = history.get('initialShapes')
    if not isinstance(fission_actions, list) or not isinstance(actions, list):
        raise FissionReplayError('typed action history has malformed action arrays')
    if not isinstance(initial_shapes, list) or not initial_shapes:
        raise FissionReplayError('typed action history has no split-baseline initial shapes')
    for action in fission_actions:
        if not isinstance(action, dict) or action.get('family') != 'fission':
            raise FissionReplayError('fissionActions contains a non-fission action')
    for action in actions:
        if not isinstance(action, dict) or action.get('family') == 'fission':
            raise FissionReplayError('ordinary action history contains a malformed or fission action')
    return history, initial_shapes, fission_actions + actions


def replay_fission_candidate(selection, args, record_dir):
    """Replay one archived action path through the native source fission pass."""
    record_dir.mkdir(parents=True, exist_ok=True)
    canonical = getattr(args, 'canonical', None)
    prepared_source = getattr(args, 'prepared_source_file', None)
    binding_file = getattr(args, 'source_binding_file', None)
    cap = getattr(args, 'max_fission_actions_per_task', None)
    partition_cap = getattr(args, 'max_partition_factor', None)
    function = getattr(args, 'function', None)
    if (canonical is None or prepared_source is None or binding_file is None or
            getattr(args, 'protocol', None) is None or
            getattr(args, 'source_contract_file', None) is None or
            cap is None or partition_cap not in (1, 2, 4, 8) or not function):
        raise FissionReplayError('full-joint-fission replay is missing canonical source bindings or caps')
    for path, label in ((canonical, 'canonical input'),
                        (prepared_source, 'prepared source'),
                        (binding_file, 'source-binding file')):
        if not path.is_file() or path.is_symlink():
            raise FissionReplayError(f'{label} is missing or is a symlink: {path}')
        if any(character.isspace() for character in str(path)):
            raise FissionReplayError(f'{label} path contains whitespace unsupported by the native pass: {path}')
    try:
        canonical_bytes = canonical.read_bytes()
        prepared_bytes = prepared_source.read_bytes()
        prepared_text = prepared_bytes.decode('utf-8')
    except (OSError, UnicodeDecodeError) as error:
        raise FissionReplayError(f'cannot read exact fission inputs: {error}') from error
    public_binding = _json_file(binding_file, 'public source binding')
    if (public_binding.get('schema') != 'orbit-neighborhood-source-binding-v1' or
            public_binding.get('canonical_program') != str(canonical.resolve()) or
            public_binding.get('optimizer') != str(args.optimizer.resolve()) or
            public_binding.get('architecture') != str(args.architecture.resolve()) or
            public_binding.get('protocol_schema') != json.loads(args.protocol.read_text(encoding='utf-8')).get('schema') or
            public_binding.get('source_commit') != json.loads(args.protocol.read_text(encoding='utf-8')).get('source_commit') or
            public_binding.get('source_contract_file') != str(args.source_contract_file.resolve()) or
            public_binding.get('stage_initialization') != 'independent' or
            public_binding.get('prepared_source_file') != str(prepared_source.resolve()) or
            public_binding.get('prepared_source_exact_text') != prepared_text or
            public_binding.get('prepared_source_size_bytes') != len(prepared_bytes) or
            public_binding.get('max_fission_actions_per_task') != cap):
        raise FissionReplayError('prepared source differs from the pinned public source binding')
    cxx_binding_path, cxx_binding, active_transfer_arguments, active_transfer_require_proven = _check_search_binding(
        selection, args, prepared_bytes, prepared_text, public_binding)
    history, initial_shapes, actions = _typed_fission_actions(selection)
    candidate_path = selection.get('candidate_path') or selection.get('mapper_replay_path')
    if not isinstance(candidate_path, str) or not candidate_path:
        raise FissionReplayError('selection has no native candidate path')
    expected_candidate = Path(candidate_path).resolve()
    if not expected_candidate.is_file() or expected_candidate.is_symlink():
        raise FissionReplayError('search candidate is missing or is a symlink')
    for path, label in ((args.optimizer, 'optimizer'),
                        (args.architecture, 'architecture'),
                        (expected_candidate, 'search candidate')):
        if any(character.isspace() for character in str(path)):
            raise FissionReplayError(f'{label} path contains whitespace unsupported by the native pass: {path}')
    try:
        expected_candidate_bytes = expected_candidate.read_bytes()
    except OSError as error:
        raise FissionReplayError(f'cannot read exact search candidate bytes: {error}') from error

    replay_dir = _fresh_replay_directory(record_dir)
    action_file = record_dir / (replay_dir.name + '-actions.json')
    for path in (action_file, replay_dir):
        if any(character.isspace() for character in str(path)):
            raise FissionReplayError(f'native replay path contains whitespace: {path}')
    action_document = {
        'schema': ACTION_SCHEMA,
        'canonicalInput': str(canonical.resolve()),
        'candidateInput': str(canonical.resolve()),
        'function': function,
        'stage': FISSION_STAGE,
        'maxPartitionFactor': partition_cap,
        'maxFissionActionsPerTask': cap,
        'preparedSourceInput': str(prepared_source.resolve()),
        'preparedSourceExactBytes': prepared_text,
        'initialShapes': initial_shapes,
        'actions': actions,
    }
    if active_transfer_arguments:
        action_document['activeTransferArguments'] = active_transfer_arguments
        action_document['activeTransferRequireProven'] = active_transfer_require_proven
    action_text = json.dumps(action_document, indent=2, sort_keys=True) + '\n'
    try:
        with action_file.open('x', encoding='utf-8') as stream:
            stream.write(action_text)
    except OSError as error:
        raise FissionReplayError(f'cannot create unique typed action file: {error}') from error
    option = 'action-file={} canonical-input={} candidate-input={} function={} stage={} max-partition-factor={} prepared-source-file={} max-fission-actions-per-task={} expected-candidate-file={} output-dir={}'.format(
        action_file, canonical.resolve(), canonical.resolve(), function, FISSION_STAGE,
        partition_cap, prepared_source.resolve(), cap, expected_candidate, replay_dir)
    if active_transfer_arguments:
        option += ' active-transfer-arguments={} active-transfer-require-proven={}'.format(
            ','.join(str(item) for item in active_transfer_arguments),
            'true' if active_transfer_require_proven else 'false')
    command = invoke([
        str(args.optimizer), str(canonical), '--verify-each',
        f'--architecture-spec={args.architecture}',
        '--replay-joint-neighborhood-actions=' + option,
        '--mlir-print-op-generic', '-o', '/dev/null'], record_dir,
        'fission-replay')
    if command.get('exit_code') != 0:
        raise FissionReplayError('native typed source-fission replay process failed')
    facts_path = replay_dir / 'source-facts.json'
    facts = _json_file(facts_path, 'native source-fission replay facts')
    if (facts.get('schema') != REPLAY_FACTS_SCHEMA or
            facts.get('status') != 'complete' or
            facts.get('canonical_input_path') != str(canonical.resolve()) or
            facts.get('candidate_input_path') != str(canonical.resolve()) or
            facts.get('action_file_path') != str(action_file) or
            facts.get('stage') != FISSION_STAGE or
            facts.get('source_iteration_domain_verified') is not True or
            facts.get('fission_source_replay_verified') is not bool(history['fissionActions']) or
            facts.get('candidate_module') != 'candidate.mlir' or
            facts.get('prepared_source_input_path') != str(prepared_source.resolve()) or
            facts.get('prepared_source_input_witness') != 'prepared-source.mlir' or
            facts.get('expected_candidate_path') != str(expected_candidate) or
            facts.get('expected_candidate_witness') != 'expected-candidate.mlir' or
            facts.get('expected_candidate_exact_replay_match') is not True or
            facts.get('expected_candidate_comparison') !=
            'exact-generic-module-after-removing-only-function-graph-variant-id' or
            facts.get('max_fission_actions_per_task') != cap or
            facts.get('max_partition_factor') != partition_cap or
            facts.get('actions_applied') != len(actions) or
            not isinstance(facts.get('steps'), list) or
            len(facts.get('steps')) != len(actions)):
        raise FissionReplayError('native source-fission replay facts do not prove the requested exact replay')
    if active_transfer_arguments:
        if (facts.get('active_transfer_replay_verified') is not True or
                facts.get('active_transfer_arguments') != active_transfer_arguments or
                facts.get('active_transfer_require_proven') is not active_transfer_require_proven):
            raise FissionReplayError('native replay facts do not prove the protocol-bound active-transfer replay')
    elif (facts.get('active_transfer_replay_verified') not in (None, False) or
          facts.get('active_transfer_arguments') not in (None, [])):
        raise FissionReplayError('native replay facts contain unbound active-transfer proof data')
    for index, (action, step) in enumerate(zip(actions, facts['steps'])):
        expected_status = ('exact-source-replay-verified'
                           if index < len(history['fissionActions']) else 'applied')
        if (not isinstance(step, dict) or step.get('label') != action.get('label') or
                step.get('family') != action.get('family') or
                step.get('status') != expected_status):
            raise FissionReplayError('native replay facts do not preserve typed action order and status')
    required_witnesses = {
        'canonical-input.mlir': canonical_bytes,
        'candidate-input.mlir': canonical_bytes,
        'actions.json': action_text.encode('utf-8'),
        'prepared-source.mlir': prepared_bytes,
        'expected-candidate.mlir': expected_candidate_bytes,
    }
    for name, expected_bytes in required_witnesses.items():
        witness_path = replay_dir / name
        if not witness_path.is_file() or witness_path.is_symlink() or witness_path.read_bytes() != expected_bytes:
            raise FissionReplayError(f'native replay witness differs from its exact input: {name}')
    try:
        after_candidate_bytes = expected_candidate.read_bytes()
    except OSError as error:
        raise FissionReplayError(f'cannot re-read search candidate after native replay: {error}') from error
    if after_candidate_bytes != expected_candidate_bytes:
        raise FissionReplayError('search candidate bytes changed during native source replay')
    candidate_module = replay_dir / 'candidate.mlir'
    if not candidate_module.is_file() or candidate_module.is_symlink():
        raise FissionReplayError('native source-fission replay did not publish candidate.mlir')
    receipt = {
        'schema': 'orbit-neighborhood-source-fission-replay-evidence-v1',
        'status': 'verified',
        'stage': FISSION_STAGE,
        'candidate_id': selection.get('candidate_id'),
        'canonical_input': str(canonical.resolve()),
        'prepared_source_file': str(prepared_source.resolve()),
        'prepared_source_bytes': len(prepared_bytes),
        'prepared_source_public_binding': str(binding_file.resolve()),
        'prepared_source_search_binding': str(cxx_binding_path),
        'prepared_source_replay_witness': str(replay_dir / 'prepared-source.mlir'),
        'max_fission_actions_per_task': cap,
        'max_partition_factor': partition_cap,
        'active_transfer_arguments': active_transfer_arguments,
        'active_transfer_require_proven': (active_transfer_require_proven
                                           if active_transfer_arguments else None),
        'fission_action_count': len(history['fissionActions']),
        'ordinary_action_count': len(history['actions']),
        'typed_action_file': str(action_file),
        'replay_output_dir': str(replay_dir),
        'replay_facts': str(facts_path),
        'reconstructed_candidate': str(candidate_module),
        'expected_search_candidate': str(expected_candidate),
        'native_candidate_comparison': facts['expected_candidate_comparison'],
        'native_candidate_match': True,
        'command': command,
    }
    write(record_dir / 'source-fission-replay.json', receipt)
    return receipt

def replay(selection, args):
    score=selection['score_record'];cid=selection['candidate_id'];rank=selection['rank']
    header=json.loads(Path(selection['score_file_path']).read_text().splitlines()[0])
    production_scheduler=header.get('schedule_space')=='production-scheduler'
    dispatch_policy=header['dispatch_policy'] if production_scheduler else 'fixed'
    assert dispatch_policy in ('fixed','critical-path')
    d=args.output_dir/('rank-'+str(rank));d.mkdir(parents=True,exist_ok=True)
    result={'rank':rank,'candidate_id':cid,'graph_variant_id':selection['graph_variant_id'],
            'ranking_certified':selection['certified'],'predicted_cycles':selection['predicted_whole_program_cycles'],
            'numeric':'pending','independent_trace':'pending','mapper_equality':'pending','sram_gate':'pending',
            'status':'incomplete','production_ready':False,'started_utc':datetime.now(timezone.utc).isoformat()}
    if getattr(args, 'stage', None) == FISSION_STAGE:
        result['status'] = 'source_fission_replay_running'
        write(d/'result.json',result)
        try:
            result['source_fission_replay'] = replay_fission_candidate(selection, args, d)
        except FissionReplayError as error:
            failure = {
                'schema': 'orbit-neighborhood-source-fission-replay-evidence-v1',
                'status': 'incomplete', 'stage': FISSION_STAGE,
                'candidate_id': cid, 'blocker': str(error),
            }
            write(d/'source-fission-replay.json', failure)
            result.update(status='incomplete', source_fission_replay=failure,
                          blocker='source_fission_replay_failed: ' + str(error))
            write(d/'result.json',result)
            return result
    manifest = args.manifest
    if args.graph_manifests:
        binding = json.loads(args.graph_manifests.read_text())
        manifest = Path(binding[selection['graph_variant_id']])
    elif selection['graph_variant_id'] != 'identity':
        manifest = Path(selection['candidate_manifest'])
    mapped=d/'mapped.mlir';native=d/'native.mlir'
    network_options = ([f'--joint-inter-task-network-spec={args.inter_task_network}']
                       if args.inter_task_network is not None else [])
    argv=[str(args.optimizer),selection['mapper_replay_path'],'--verify-each',f'--architecture-spec={args.architecture}', *network_options]
    # Fresh identity inputs and older closure artifacts may lack the scored
    # semantic label. Bind every selection through the C++ enumerator before
    # strict materialization;
    # the materializer still checks every task, trip count and canonical shape
    # against the originally scored manifest.
    space=json.loads(manifest.read_text().splitlines()[0])
    if space.get('schema') == 'orbit-neighborhood-shape-selection-v1':
        # The source-owned selection binds one tuple to the exact program.
        # Re-enumeration would mutate that program and break its binding.
        assert space['record_type'] == 'selection'
        assert space['graph_variant_id'] == selection['graph_variant_id']
        assert space['candidate_id'] == score['shape_candidate_id']
    else:
        assert space['record_type']=='space' and space['representation']=='factored'
        assert space['graph_variant_id']==selection['graph_variant_id']
        argv.append(f'--enumerate-analytical-task-candidates=function={space["function"]} output={d}/replay-space.jsonl factored-output=true search-policy=complete-cartesian max-cgras-per-task={space["max_cgras_per_task"]} graph-variant-id={selection["graph_variant_id"]}')
    argv += [f'--materialize-analytical-task-candidate=candidates={manifest} candidate-id={score["shape_candidate_id"]}',
          f'--map-joint-scheduling-tasks=scores={selection["score_file_path"]} candidate-id={cid} mapping-cache-dir={args.mapping_cache}{" audit-calls=true" if getattr(args, "audit_mapper_calls", False) else ""}',
          '--mlir-print-op-generic','-o',str(mapped)]
    result['status']='mapper_running';write(d/'result.json',result)
    reusable=args.reuse_mapped_root/('rank-'+str(rank))/'mapped.mlir' if args.reuse_mapped_root else None
    reuse_ok=bool(reusable and reusable.is_file())
    if reuse_ok and production_scheduler:
        saved=reusable.read_text()
        reuse_ok=('joint_scheduling_scheduler_backend = "orchestrate-tasks-on-accelerators"' in saved and
                  f'joint_scheduling_production_dispatch_policy = "{dispatch_policy}"' in saved and
                  f'joint_scheduling_candidate_id = "{cid}"' in saved and
                  'amoeba.exact_schedule' not in saved and 'joint_scheduling_exact_dispatch_order' not in saved)
    if reuse_ok:
        import shutil
        shutil.copyfile(reusable,mapped)
        command={'exit_code':0,'reused_mapper_result':str(reusable)}
    else: command=invoke(argv,d,'mapper')
    result['mapper_command']=command
    if getattr(args, "audit_mapper_calls", False):
        log = gzip.open(d/'mapper.stderr.gz', 'rt').read() if (d/'mapper.stderr.gz').exists() else ""
        calls = [json.loads(line.split('[ORBIT-MAPPER-CALL] ', 1)[1])
                 for line in log.splitlines() if line.startswith('[ORBIT-MAPPER-CALL] ')]
        result['actual_mapper_calls'] = len(calls)
        write(d/'mapper-call-audit.json', calls)
    if command['exit_code']:
        result.update(status='incomplete',blocker='mapper_process_failed');write(d/'result.json',result);return result
    text=mapped.read_text();count=len(score['task_costs'])
    result['mapper_equality']='pass' if text.count('amoeba.mapper_replay_verified')==count else 'fail'
    result['mapper_cache_hits']=int(re.search(r'joint_scheduling_mapper_cache_hits = ([0-9]+)',text).group(1))
    result['mapper_cache_misses']=int(re.search(r'joint_scheduling_mapper_cache_misses = ([0-9]+)',text).group(1))
    result['prediction_mapper_equal']='joint_scheduling_prediction_mapper_equal = true' in text
    argv=[str(args.optimizer),str(mapped),'--verify-each',f'--architecture-spec={args.architecture}', *network_options,
          f'--orchestrate-tasks-on-accelerators=orchestration-strategy=analytical-based-task-orchestration scheduling-mode=spatial-temporal dispatch-policy={dispatch_policy} communication-mode=explicit exact-replay-timing=mapped','--mlir-print-op-generic','-o',str(native)]
    result['status']='native_running';write(d/'result.json',result)
    command=invoke(argv,d,'native');result['native_command']=command
    if command['exit_code']:
        result['status']='incomplete'
        result['blocker']='native_process_signal' if command['exit_code'] < 0 else ('production_scheduler_failed_under_real_mapper_durations' if production_scheduler else 'selected_exact_schedule_infeasible_under_real_mapper_durations');write(d/'result.json',result);return result
    costs={row['task']:row for row in score['task_costs']}
    candidate={'candidate_id':cid,'task_shapes':[{'task':entry['task'],'trip_count':costs[entry['task']]['trip_count'],
      'shape':{'rows':entry['rows'],'cols':entry['cols'],'cgra_count':entry['rows']*entry['cols'],
               'cgra_shape':str(entry['rows'])+'x'+str(entry['cols']),
               'mapper_tile_rows':costs[entry['task']]['mapper_tile_rows'],'mapper_tile_cols':costs[entry['task']]['mapper_tile_cols']}}
      for entry in score['task_schedule']]}
    try:
        text=native.read_text();trace=trace_validator.validate(text,candidate,selection['graph_variant_id'])
        actual=trace_validator.AttributeParser(trace_validator.extract_dictionary(text,'joint_scheduling_actual_trace')).document()
        selected={row['task']:row for row in score['task_schedule']}
        for row in actual['task_schedule']:
            expected=selected[row['task']]
            # Native cycles use actual mapped II; locations, dispatch and
            # deliberate idle remain compiler-selected. Timing drift is evidence.
            if not production_scheduler:
                assert {(p['row'],p['col']) for p in row['cgra_positions']}=={(r,c) for r in range(expected['row'],expected['row']+expected['rows']) for c in range(expected['col'],expected['col']+expected['cols'])}
        result.update(independent_trace=trace['status'],native_cycles=trace['native_cycles'],fixed_location_equality='scheduler-selected' if production_scheduler else 'pass', prediction_start_equality=all(row['start_cycle']==selected[row['task']]['start_cycle'] for row in actual['task_schedule']), replay_timing_policy='production-scheduler-with-mapped-durations' if production_scheduler else 'mapped-duration-preserve-location-dispatch-idle',status='native_replayed',scheduler_backend='orchestrate-tasks-on-accelerators' if production_scheduler else 'orbit-exact-enumerator')
        write(d/'independent-trace.json',trace)
    except (ValueError,KeyError,AssertionError) as error:
        result.update(status='incomplete',independent_trace='fail',blocker=str(error))
    if result['status'] == 'native_replayed':
        capacity = json.loads(args.sram_config.read_text())
        assert capacity['schema'] == 'orbit-vectorcgra-sram-configuration-v1'
        assert capacity['fabric_rows'] == capacity['fabric_columns'] == 4
        result['sram_capacity_config'] = str(args.sram_config)
        if capacity.get('per_cgra_capacity_bytes') is None:
            assert capacity.get('capacity_status') == 'pending'
            result.update(sram_gate='pending', sram_blocker='target_sram_capacity_unestablished',
                          sram_capacity_evaluated=False)
        else:
            gate = d/'sram-gate.json'
            result['sram_command'] = invoke([
                str(args.optimizer), str(native), '--verify-each',
                '--verify-production-sram-native-capacity-gate=capacity-bytes-per-cgra={} grid-rows={} grid-columns={} output={}'.format(
                    capacity['per_cgra_capacity_bytes'], capacity['fabric_rows'], capacity['fabric_columns'], gate),
                '-o', '/dev/null'], d, 'sram')
            if result['sram_command']['exit_code'] or not gate.is_file():
                result.update(sram_gate='pending', sram_blocker='native_sram_evidence_process_failed')
            else:
                evidence = json.loads(gate.read_text())
                assert evidence['schema'] == 'orbit-native-sram-capacity-gate-v1'
                assert evidence['status'] in ('pass','pending','fail')
                result.update(sram_gate=evidence['status'], sram_evidence=str(gate))
                if evidence['status'] != 'pass':
                    result['sram_blocker'] = evidence['reason']
    result['ended_utc']=datetime.now(timezone.utc).isoformat();write(d/'result.json',result);return result

def main():
    p=argparse.ArgumentParser(description=__doc__)
    for flag in ['global-top5','manifest','optimizer','architecture','mapping-cache','output-dir']:
        p.add_argument('--'+flag,type=Path,required=True)
    p.add_argument('--jobs',type=int,default=2);p.add_argument('--reuse-mapped-root',type=Path)
    p.add_argument('--graph-manifests',type=Path)
    p.add_argument('--sram-config',type=Path,default=ROOT/'config/architectures/amoeba_4x4_vectorcgra_sram.json')
    p.add_argument('--inter-task-network',type=Path)
    p.add_argument('--stage')
    p.add_argument('--workload')
    p.add_argument('--canonical',type=Path)
    p.add_argument('--function')
    p.add_argument('--protocol',type=Path)
    p.add_argument('--source-contract-file',type=Path)
    p.add_argument('--source-binding-file',type=Path)
    p.add_argument('--prepared-source-file',type=Path)
    p.add_argument('--max-partition-factor',type=int,default=8)
    p.add_argument('--max-fission-actions-per-task',type=int)
    a=p.parse_args()
    for key,value in vars(a).items():
        if isinstance(value,Path):setattr(a,key,value.resolve())
    rows=[json.loads(line) for line in a.global_top5.read_text().splitlines() if line.strip()]
    selected=[row for row in rows if row.get('record_type')=='selection']
    assert len(selected)==5 and len({(r['graph_variant_id'],r['candidate_id']) for r in selected})==5
    results=[]
    with ThreadPoolExecutor(max_workers=a.jobs) as pool:
        futures=[pool.submit(replay,r,a) for r in selected]
        for f in as_completed(futures):
            results.append(f.result());write(a.output_dir/'summary.json',{'status':'running','records':results,'selection_certified':rows[-1]['complete']})
            print(results[-1]['rank'],results[-1]['status'],results[-1].get('blocker',''),flush=True)
    results.sort(key=lambda r:r['rank'])
    write(a.output_dir/'summary.json',{'status':'native_replayed' if all(r['status']=='native_replayed' for r in results) else 'incomplete',
          'records':results,'selection_certified':rows[-1]['complete'],'numeric':'pending',
          'sram_gate':'pass' if all(r['sram_gate']=='pass' for r in results) else 'fail' if any(r['sram_gate']=='fail' for r in results) else 'pending','production_ready':False})

if __name__=='__main__':main()
