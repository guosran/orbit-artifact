"""Fail-closed audit of the seven expected comparison validation items."""
def require_complete_validation(value):
    if value.get('numeric') != 'pass':
        raise ValueError('aggregate numerical gate did not pass')
    for block, selections, command, expected in (
        ('native_top5','top5','numeric_top5_command',set(range(5))),
        ('native_controls','controls','numeric_controls_command',{5,6}),
    ):
        native=value.get(block,{})
        rows=native.get('records',[]);chosen=value.get(selections,[])
        if (native.get('numeric') != 'pass' or native.get('status') != 'native_replayed'
                or value.get(command,{}).get('exit_code') != 0):
            raise ValueError(f'{block} aggregate native/numeric command did not pass')
        if (len(rows)!=len(expected) or len(chosen)!=len(expected)
                or {r.get('rank') for r in rows}!=expected
                or {r.get('rank') for r in chosen}!=expected):
            raise ValueError(f'{block} does not contain the distinct expected ranks')
        selected={r['rank']:r for r in chosen}
        if selections=='top5' and len({r.get('candidate_id') for r in chosen})!=5:
            raise ValueError('shortlist candidate IDs are not unique')
        if selections=='controls' and {r.get('control_role') for r in chosen}!={'identity','search_anchor'}:
            raise ValueError('control roles are missing or repeated')
        for row in rows:
            selection=selected[row['rank']]
            if (row.get('candidate_id')!=selection.get('candidate_id')
                    or row.get('control_role')!=selection.get('control_role')):
                raise ValueError('native validation item differs from its selected rank/role')
            if any(row.get(key)!=expected_status for key,expected_status in (
                ('status','native_replayed'),('numeric','pass'),
                ('mapper_equality','pass'),('independent_trace','pass'))):
                raise ValueError('a selected native/numeric/mapper/trace gate failed')
    return True
