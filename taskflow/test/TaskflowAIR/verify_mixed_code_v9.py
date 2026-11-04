#!/usr/bin/env python3
"""Static package/code binding for mixed FP32 experiments. Never executes code.

A PASS covers the checks listed in summary.json, not numerical equivalence,
rounding-mode equivalence, measured lane utilization, cycles, or DDR traffic.
Helper byte differences fail closed; disassembly is retained for relocation review.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import struct
import subprocess


def sha(data):
    return hashlib.sha256(data).hexdigest()


def elf32(data):
    h = struct.unpack_from('<16sHHIIIIIHHHHHH', data)
    if h[0][:6] != b'\x7fELF\x01\x01':
        raise ValueError('expected little-endian ELF32 core')
    sections = [struct.unpack_from('<IIIIIIIIII', data, h[6]+i*h[11]) for i in range(h[12])]
    names = data[sections[h[13]][4]:sections[h[13]][4]+sections[h[13]][5]]
    named = {names[s[0]:].split(b'\0', 1)[0].decode(): s for s in sections}
    text = named['.text']
    helpers = {}
    for s in sections:
        if s[1] != 2:  # SHT_SYMTAB
            continue
        strings = sections[s[6]]
        strings = data[strings[4]:strings[4]+strings[5]]
        for p in range(s[4], s[4]+s[5], s[9]):
            name, address, size, info, other, index = struct.unpack_from('<IIIBBH', data, p)
            name = strings[name:].split(b'\0', 1)[0].decode()
            if name in ('__mulsf3', '__divsf3', '__mulsi3', '__muldi3') and size:
                sec = sections[index]
                body = data[sec[4]+address-sec[3]:sec[4]+address-sec[3]+size]
                helpers[name] = dict(address=address, bytes=size, sha256=sha(body))
    return data[text[4]:text[4]+text[5]], helpers


def llvm_check(path):
    """Recognize explicit accumulator phi -> ordered add chain -> phi backedge.

    This checks the final optimized LLVM recurrence, not arbitrary equivalence.
    Keep complete LLVM for manual mapping to the source K loop.
    """
    text = path.read_text()
    forbidden = []
    for line in text.splitlines():
        if re.search(r'\b(?:fmul|fdiv)\b[^\n]*<\d+ x float>', line):
            forbidden.append(line.strip())
        if re.search(r'\b(?:fast|reassoc|contract|afn|arcp|nnan|ninf|nsz)\b', line) and re.search(r'\b(?:fadd|fsub|fmul|fdiv|call)\b', line):
            forbidden.append(line.strip())
        if re.search(r'@llvm\.(?:fma|fmuladd)|\bbfloat\b|\bbf16\b', line):
            forbidden.append(line.strip())
    defs = dict(re.findall(r'^\s*(%[\w.]+) = (.+)$', text, re.M))
    # Track low 32-bit units through the installed target's bitcasts and
    # shuffles. Do not infer recurrence merely from the intrinsic's presence.
    def units(value, seen=()):
        if value in seen or value not in defs:
            raise ValueError('unsupported/cyclic target vector value '+value)
        expression = defs[value]
        seen = (*seen, value)
        phi = re.match(r'phi <(\d+) x float>', expression)
        if phi:
            return [(value, lane) for lane in range(int(phi[1]))]
        cast = re.fullmatch(r'bitcast <\d+ x (?:float|i64)> (%[\w.]+) to <\d+ x (?:float|i64)>', expression)
        if cast:
            return units(cast[1], seen)
        shuffle = re.fullmatch(r'shufflevector <(\d+) x (float|i64)> (%[\w.]+), <\d+ x (?:float|i64)> (poison|%[\w.]+), <\d+ x i32> <(.+)>', expression)
        if shuffle:
            count, dtype, first, second, mask = shuffle.groups()
            width = 1 if dtype == 'float' else 2
            a = units(first, seen)
            b = [None]*(int(count)*width) if second == 'poison' else units(second, seen)
            result = []
            for item in mask.split(','):
                index = item.strip().removeprefix('i32 ')
                if index == 'poison': result.extend([None]*width)
                else:
                    start = int(index)*width
                    result.extend((a+b)[start:start+width])
            return result
        product = re.fullmatch(r'insertelement <(\d+) x float> (poison|%[\w.]+), float (%[\w.]+), i64 (\d+)', expression)
        if product:
            count, previous, scalar, lane = product.groups()
            result = [None]*int(count) if previous == 'poison' else units(previous, seen)
            result[int(lane)] = ('scalar', scalar)
            return result
        intrinsic = re.fullmatch(r'(?:tail )?call <64 x float> @llvm\.aie2p?\.ACC2048\.accfloat\.add\.conf\(<64 x float> (%[\w.]+), <64 x float> (%[\w.]+), i32 60\)', expression)
        if intrinsic:
            a, b = (units(x, seen) for x in intrinsic.groups())
            return [('add', x, y) for x, y in zip(a, b)]
        raise ValueError('unsupported target vector expression: '+expression)
    intrinsic_chains = []
    for name, expression in defs.items():
        phi = re.match(r'phi <(\d+) x float>', expression)
        if not phi: continue
        for back in re.findall(r'\[\s*(%[\w.]+),\s*%[\w.]+\s*\]', expression):
            try:
                lanes = units(back)
            except ValueError:
                continue
            count = int(phi[1])
            if len(lanes) == count and all(isinstance(unit, tuple) and len(unit) == 3 and
                    unit[0] == 'add' and unit[1] == (name, lane) and
                    unit[2] is not None for lane, unit in enumerate(lanes)):
                intrinsic_chains.append(dict(phi=name, backedge=back, lanes=count,
                    config=60, ordered_lane_recurrences=lanes,
                    scope='Bitcast/shuffle low-lane provenance and one target add per phi backedge; intrinsic FP mode still requires target contract review.'))
    chains = []
    for name, expression in defs.items():
        if not re.match(r'phi (?:float|<\d+ x float>) ', expression):
            continue
        incoming = re.findall(r'\[\s*(%[\w.]+),\s*%[\w.]+\s*\]', expression)
        for back in incoming:
            chain, current, seen = [], back, set()
            while current != name and current in defs and current not in seen:
                seen.add(current)
                op = defs[current]
                match = re.match(r'fadd (?:float|<\d+ x float>) (%[\w.]+), (%[\w.]+)', op)
                if not match:
                    break
                left, right = match.groups()
                # The recurrence must be one operand; its partner is preserved verbatim.
                chain.append(dict(result=current, expression=op))
                current = left
                if current == name:
                    chains.append(dict(phi=name, expression=expression, backedge=back,
                                       ordered_adds=list(reversed(chain))))
    return dict(path=str(path), sha256=sha(path.read_bytes()), forbidden=forbidden,
                accumulator_recurrences=chains,
                target_intrinsic_accumulator_recurrences=intrinsic_chains,
                k_order_scope='Explicit optimized-LLVM left-fold recurrence only; source K-index mapping requires review.',
                vector_add_count=len(re.findall(r'\bfadd <\d+ x float>', text)),
                target_vector_add_intrinsics=[line.strip() for line in text.splitlines()
                    if 'call ' in line and re.search(r'@llvm\.aie2p?\.(?:ACC\d+\.accfloat\.add\.conf|vadd)', line)],
                vector_memory_operations=[line.strip() for line in text.splitlines()
                    if re.search(r'\b(?:load|store) <\d+ x (?:float|i64)>', line)],
                scalar_mul_calls=len(re.findall(r'call[^\n]*@__mulsf3\(', text)))


def inspect(directory, output, objdump):
    directory = directory.resolve()
    if not (directory/'program.elf').is_file():
        directory = directory/'hardware'
    program = (directory/'program.elf').read_bytes()
    record = json.loads((directory/'compile.json').read_text())
    air = (directory/'input.air.mlir').read_bytes()
    if sha(program) != record['elf_sha256'] or sha(air) != record['source_sha256']:
        raise ValueError('program ELF or input AIR differs from compile.json')
    if record.get('bf16_emulation') is not False:
        raise ValueError('compile.json does not explicitly disable BF16 emulation')
    project = directory/'air_project'
    rows = []
    for core in sorted(project.glob('elfs_*_core_*/*.elf')):
        stage = re.fullmatch(r'elfs_(.+)_core_\d+_\d+', core.parent.name).group(1)
        data = core.read_bytes()
        text, helpers = elf32(data)
        pdi = (project/(stage+'.pdi')).read_bytes()
        if not text or pdi.find(text) < 0 or program.find(pdi) < 0:
            raise ValueError('complete core text/PDI/program byte binding failed: '+str(core))
        proc = subprocess.run([str(objdump), '-d', str(core)], text=True, capture_output=True)
        (output/(core.stem+'.disassembly.txt')).write_text(proc.stdout+proc.stderr)
        if proc.returncode:
            raise ValueError('llvm-objdump failed: '+str(core))
        for helper in helpers.values():
            instructions = []
            for line in proc.stdout.splitlines():
                match = re.match(r'\s*([0-9a-f]+):\s+((?:[0-9a-f]{2}\s+)+)\s*(.*)', line)
                if match and helper['address'] <= int(match[1], 16) < helper['address']+helper['bytes']:
                    assembly = match[3].strip()
                    # Only branch immediates become relative; data constants stay exact.
                    assembly = re.sub(r'(\b(?:j|jl|jz|jnz|jlt|jge|jgt|jle)\s+(?:[^;#]*?,\s*)?)#0x([0-9a-f]+)',
                        lambda m: m[1]+'helper_relative_'+str(int(m[2], 16)-helper['address']), assembly)
                    instructions.append(assembly)
            helper['branch_relative_disassembly'] = instructions
        # Integer compiler-rt mac is deliberately excluded from floating MAC checks.
        bad = [line for line in proc.stdout.splitlines()
               if re.search(r'\b(?:v?mul\.f|v?mac\.f|v?msc\.f|v?fma\w*|\w*bf16\w*)\b', line)]
        rows.append(dict(stage=stage, core=str(core), elf_sha256=sha(data),
                         text_sha256=sha(text), text_bytes=len(text), helpers=helpers,
                         pdi_sha256=sha(pdi), text_offset_in_pdi=pdi.find(text),
                         pdi_offset_in_program=program.find(pdi), forbidden_instructions=bad,
                         native_vector_add_static_sites=len(re.findall(r'\bvadd\.f\b', proc.stdout))))
    if not rows:
        raise ValueError('no final elfs_*_core_* core ELF found')
    llvm = [llvm_check(p) for p in sorted(project.glob('peano-opted*.ll'))]
    if not llvm:
        raise ValueError('no final optimized LLVM artifacts found')
    return dict(directory=str(directory), program_elf_sha256=sha(program), air_sha256=sha(air),
                cores=rows, llvm=llvm)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--baseline', required=True, type=Path)
    parser.add_argument('--candidate', type=Path)
    parser.add_argument('--output', required=True, type=Path)
    parser.add_argument('--llvm-bin', type=Path, default=Path(os.environ.get('LLVM_AIE_BIN',
        '/home/shiran/project/aie-toy/.venv/lib/python3.12/site-packages/llvm-aie/bin')))
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    summary = dict(status='failed', scope='Static code/package checks; no execution or performance measurement.',
                   command_line=__import__('sys').argv,
                   verifier_sha256=sha(Path(__file__).read_bytes()),
                   objdump_path=str(args.llvm_bin/'llvm-objdump'),
                   objdump_sha256=sha((args.llvm_bin/'llvm-objdump').read_bytes()),
                   limitations=['No numerical/rounding-mode equivalence proof.',
                                'Retained optimized LLVM is compiler evidence; byte inclusion binds ELF text, not LLVM provenance.',
                                'Native vadd.f alone does not prove independent SIMD lane utilization.',
                                'LLVM recurrence evidence does not by itself map K addresses to the source.',
                                'No DDR transactions, cycles, trace progress, stack high-water or throughput measured.'])
    try:
        for label, directory in [('baseline', args.baseline), ('candidate', args.candidate)]:
            if directory is not None:
                out = args.output/label
                out.mkdir()
                summary[label] = inspect(directory, out, args.llvm_bin/'llvm-objdump')
        if args.candidate is None:
            summary['status'] = 'baseline_static_only'
        else:
            baseline_hashes, baseline_helpers = {}, {}
            for core in summary['baseline']['cores']:
                for name, helper in core['helpers'].items():
                    baseline_hashes.setdefault(name, set()).add(helper['sha256'])
                    baseline_helpers.setdefault(name, []).append(helper)
            comparisons = []
            candidate = summary['candidate']
            for core in candidate['cores']:
                for name, helper in core['helpers'].items():
                    candidates = baseline_helpers.get(name, [])
                    same_relative = [b for b in candidates if b['branch_relative_disassembly'] and
                                     b['branch_relative_disassembly'] == helper['branch_relative_disassembly']]
                    comparisons.append(dict(core=core['core'], helper=name,
                        exact_baseline_bytes=helper['sha256'] in baseline_hashes.get(name, set()),
                        baseline_symbol_addresses=[b['address'] for b in candidates],
                        branch_relative_disassembly_matches=bool(same_relative),
                        difference_policy='Different bytes require explicit relocation review even if branch-relative disassembly matches.',
                        **helper))
            summary['helper_comparisons'] = comparisons
            issues = []
            if not any(c['helper'] == '__mulsf3' for c in comparisons):
                issues.append('candidate lacks sized __mulsf3 symbol')
            if any(not c['exact_baseline_bytes'] for c in comparisons):
                issues.append('helper bytes differ: inspect retained disassemblies/addresses; relocation equivalence is NOT assumed')
            if any(c['forbidden_instructions'] for c in candidate['cores']):
                issues.append('forbidden floating multiply/FMA/BF16 ISA pattern')
            if any(x['forbidden'] for x in candidate['llvm']):
                issues.append('forbidden vector product/fastmath/FMA/BF16 LLVM')
            if not any((x['vector_add_count'] and x['accumulator_recurrences']) or
                       x['target_intrinsic_accumulator_recurrences'] for x in candidate['llvm']):
                issues.append('no recognized optimized vector accumulator left-fold recurrence; K-order review required')
            if not any(c['native_vector_add_static_sites'] for c in candidate['cores']):
                issues.append('no native vadd.f in final candidate cores')
            summary['issues'] = issues
            summary['status'] = 'needs_review' if issues else 'static_checks_pass_source_k_review_required'
    except (OSError, ValueError, KeyError, struct.error) as exc:
        summary['error'] = str(exc)
    (args.output/'summary.json').write_text(json.dumps(summary, indent=2)+'\n')
    print(summary['status'])
    return 0 if summary['status'] in ('baseline_static_only', 'static_checks_pass_source_k_review_required') else 1


if __name__ == '__main__':
    raise SystemExit(main())
