#!/usr/bin/env python3
"""Independently check a source-owned Neura native replay trace embedded in MLIR."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
from typing import Any

TOKEN = re.compile(r'\s*(?:("(?:\\.|[^"\\])*")|(-?[0-9]+)|([A-Za-z_][A-Za-z0-9_.-]*)|([{}\[\],=:]))')


def extract_dictionary(ir: str, name: str) -> str:
    marker = name + ' = {'
    location = ir.find(marker)
    if location < 0 or ir.find(marker, location + 1) >= 0:
        raise ValueError(f'exactly one {name} dictionary is required')
    begin = location + len(name) + 3
    depth = 0
    quoted = False
    escaped = False
    for end in range(begin, len(ir)):
        char = ir[end]
        if quoted:
            if escaped:
                escaped = False
            elif char == '\\':
                escaped = True
            elif char == '"':
                quoted = False
        elif char == '"':
            quoted = True
        elif char == '{':
            depth += 1
        elif char == '}':
            depth -= 1
            if depth == 0:
                return ir[begin:end + 1]
    raise ValueError(f'{name} dictionary is not closed')


class AttributeParser:
    def __init__(self, raw: str):
        self.tokens: list[str] = []
        position = 0
        while position < len(raw):
            match = TOKEN.match(raw, position)
            if match is None:
                raise ValueError(f'unsupported MLIR attribute at offset {position}')
            self.tokens.append(next(part for part in match.groups() if part is not None))
            position = match.end()
        self.index = 0

    def take(self, expected: str | None = None) -> str:
        if self.index >= len(self.tokens):
            raise ValueError('unexpected end of MLIR attribute')
        token = self.tokens[self.index]
        self.index += 1
        if expected is not None and token != expected:
            raise ValueError(f'expected {expected!r}, found {token!r}')
        return token

    def parse(self) -> Any:
        token = self.take()
        if token == '{':
            result: dict[str, Any] = {}
            while self.tokens[self.index] != '}':
                key = self.take()
                if key in result:
                    raise ValueError(f'duplicate MLIR attribute key {key}')
                self.take('=')
                result[key] = self.parse()
                if self.tokens[self.index] != '}':
                    self.take(',')
            self.take('}')
            return result
        if token == '[':
            result_list: list[Any] = []
            while self.tokens[self.index] != ']':
                result_list.append(self.parse())
                if self.tokens[self.index] != ']':
                    self.take(',')
            self.take(']')
            return result_list
        if token.startswith('"'):
            return json.loads(token)
        if re.fullmatch(r'-?[0-9]+', token):
            if self.index < len(self.tokens) and self.tokens[self.index] == ':':
                self.take(':')
                integer_type = self.take()
                if integer_type not in ('i1', 'i8', 'i16', 'i32', 'i64', 'index'):
                    raise ValueError(f'unsupported MLIR integer type {integer_type}')
            return int(token)
        if token in ('true', 'false'):
            return token == 'true'
        raise ValueError(f'unsupported MLIR attribute value {token!r}')

    def document(self) -> dict[str, Any]:
        result = self.parse()
        if self.index != len(self.tokens) or not isinstance(result, dict):
            raise ValueError('native trace is not a complete MLIR dictionary')
        return result


def load_candidate(path: Path, candidate_id: str, graph_variant_id: str) -> dict[str, Any]:
    header = None
    footer = None
    selected = None
    count = 0
    with path.open() as stream:
        for line in stream:
            row = json.loads(line)
            kind = row.get('record_type')
            if kind == 'header' and header is None and count == 0:
                header = row
            elif kind == 'candidate' and header is not None and footer is None:
                count += 1
                if row.get('candidate_id') == candidate_id:
                    if selected is not None:
                        raise ValueError('candidate ID occurs more than once')
                    selected = row
            elif kind == 'footer' and header is not None and footer is None:
                footer = row
            else:
                raise ValueError('candidate manifest record order is invalid')
    if (header is None or footer is None or selected is None or
            header.get('graph_variant_id') != graph_variant_id or
            footer.get('candidate_count') != count):
        raise ValueError('candidate manifest incomplete or graph identity differs')
    return selected


def validate(ir: str, candidate: dict[str, Any], graph_variant_id: str) -> dict[str, Any]:
    candidate_id = candidate['candidate_id']
    if (f'joint_scheduling_candidate_id = "{candidate_id}"' not in ir or
            f'joint_scheduling_graph_variant_id = "{graph_variant_id}"' not in ir or
            'joint_scheduling_replay_verified' not in ir):
        raise ValueError('native replay candidate or graph identity differs')
    cycles_matches = re.findall(r'joint_scheduling_actual_makespan\s*=\s*([0-9]+)', ir)
    if len(cycles_matches) != 1 or int(cycles_matches[0]) <= 0:
        raise ValueError('unique positive native makespan is required')
    cycles = int(cycles_matches[0])
    trace = AttributeParser(extract_dictionary(ir, 'joint_scheduling_actual_trace')).document()
    if trace.get('candidate_id') != candidate_id or trace.get('communication_mode') != 'explicit':
        raise ValueError('embedded trace candidate or communication mode differs')
    shapes = {row['task']: row['shape'] for row in candidate['task_shapes']}
    schedule = trace.get('task_schedule')
    dependencies = trace.get('dependencies')
    routes = trace.get('routes')
    if not all(isinstance(value, list) for value in (schedule, dependencies, routes)):
        raise ValueError('native trace lacks schedule, dependencies, or routes')
    if len(schedule) != len(shapes) or ir.count('amoeba.mapper_replay_verified') != len(shapes):
        raise ValueError('mapped task count differs from candidate manifest')
    task_intervals: dict[str, tuple[int, int]] = {}
    task_cells: dict[str, set[tuple[int, int]]] = {}
    occupancy: dict[tuple[int, int], list[tuple[int, int, str]]] = {}
    for entry in schedule:
        name = entry.get('task')
        start, end = entry.get('start_cycle'), entry.get('end_cycle')
        if (name not in shapes or name in task_intervals or type(start) is not int or
                type(end) is not int or start < 0 or end <= start):
            raise ValueError('invalid or duplicate task interval')
        task_intervals[name] = (start, end)
        shape = shapes[name]
        positions = entry.get('cgra_positions')
        if not isinstance(positions, list) or len(positions) != shape['cgra_count']:
            raise ValueError(f'{name}: placement size differs from candidate shape')
        cells = set()
        for position in positions:
            row, col = position.get('row'), position.get('col')
            if type(row) is not int or type(col) is not int or not (0 <= row < 4 and 0 <= col < 4):
                raise ValueError(f'{name}: placement is outside 4x4 fabric')
            cells.add((row, col))
            occupancy.setdefault((row, col), []).append((start, end, name))
        task_cells[name] = cells
        if len(cells) != len(positions):
            raise ValueError(f'{name}: duplicate occupied cell')
        rows = {cell[0] for cell in cells}
        cols = {cell[1] for cell in cells}
        if (len(rows) != shape['rows'] or len(cols) != shape['cols'] or
                cells != {(row, col) for row in rows for col in cols} or
                max(rows) - min(rows) + 1 != len(rows) or
                max(cols) - min(cols) + 1 != len(cols)):
            raise ValueError(f'{name}: placement is not the declared rectangle')
    if set(task_intervals) != set(shapes) or max(end for _, end in task_intervals.values()) != cycles:
        raise ValueError('task intervals do not cover manifest or end at makespan')
    for intervals in occupancy.values():
        ordered = sorted(intervals)
        if any(first[1] > second[0] for first, second in zip(ordered, ordered[1:])):
            raise ValueError('two tasks overlap on one physical CGRA')
    data_edges = set()
    for edge in dependencies:
        producer, consumer = edge.get('producer'), edge.get('consumer')
        if producer not in task_intervals or consumer not in task_intervals:
            raise ValueError('dependency has an unknown task')
        if task_intervals[producer][1] > task_intervals[consumer][0]:
            raise ValueError(f'dependency {producer}->{consumer} violates schedule order')
        if edge.get('kind') == 'raw' and type(edge.get('payload_bits')) is int:
            data_edges.add((producer, consumer))
    link_intervals: dict[tuple[Any, ...], list[tuple[int, int]]] = {}
    for route in routes:
        producer, consumer = route.get('producer'), route.get('consumer')
        if (producer, consumer) not in data_edges:
            raise ValueError('route has no data dependency')
        payload = route.get('payload_bits')
        ready = route.get('ready_cycle')
        transfer = route.get('transfer_cycles')
        if (type(payload) is not int or payload <= 0 or type(transfer) is not int or
                transfer <= 0 or type(ready) is not int or ready > task_intervals[consumer][0]):
            raise ValueError('invalid route payload, transfer, or arrival time')
        source_cell = (route.get('source_row'), route.get('source_col'))
        destination_cell = (route.get('destination_row'), route.get('destination_col'))
        if source_cell not in task_cells[producer] or destination_cell not in task_cells[consumer]:
            raise ValueError('route endpoints differ from task placements')
        bandwidth = route.get('bottleneck_bandwidth_bits_per_cycle')
        if type(bandwidth) is not int or bandwidth <= 0 or transfer < (payload + bandwidth - 1) // bandwidth:
            raise ValueError('route transfer is shorter than payload/bandwidth bound')
        links = route.get('links')
        if not isinstance(links, list) or not links:
            raise ValueError('data route has no occupied link')
        for link in links:
            begin, end = link.get('start_cycle'), link.get('end_cycle')
            if type(begin) is not int or type(end) is not int or begin < 0 or end <= begin:
                raise ValueError('invalid link interval')
            kind = link.get('resource_kind')
            if kind == 'network_link':
                identity = (kind, link.get('link_index'))
            elif kind == 'local_channel':
                identity = (kind, link.get('row'), link.get('col'))
            else:
                raise ValueError('unknown route resource kind')
            link_intervals.setdefault(identity, []).append((begin, end))
    for identity, intervals in link_intervals.items():
        ordered = sorted(intervals)
        if any(first[1] > second[0] for first, second in zip(ordered, ordered[1:])):
            raise ValueError(f'overlapping transfers on route resource {identity}')
    return {'schema': 'orbit-embedded-native-trace-validation-v1', 'status': 'pass',
            'graph_variant_id': graph_variant_id, 'candidate_id': candidate_id,
            'native_cycles': cycles, 'task_count': len(schedule),
            'dependency_count': len(dependencies), 'route_count': len(routes),
            'occupied_cell_count': len(occupancy), 'route_resource_count': len(link_intervals)}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mlir', type=Path, required=True)
    parser.add_argument('--manifest', type=Path, required=True)
    parser.add_argument('--candidate-id', required=True)
    parser.add_argument('--graph-variant-id', required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    try:
        candidate = load_candidate(args.manifest, args.candidate_id, args.graph_variant_id)
        result = validate(args.mlir.read_text(), candidate, args.graph_variant_id)
        result['mlir'] = str(args.mlir.resolve())
        result['manifest'] = str(args.manifest.resolve())
    except (OSError, ValueError, KeyError, TypeError) as error:
        result = {'schema': 'orbit-embedded-native-trace-validation-v1', 'status': 'fail',
                  'error': str(error), 'mlir': str(args.mlir.resolve()),
                  'manifest': str(args.manifest.resolve())}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + '\n')
    print(args.output)
    return 0 if result['status'] == 'pass' else 1


if __name__ == '__main__':
    raise SystemExit(main())
