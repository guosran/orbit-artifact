#!/usr/bin/env python3
"""Losslessly archive closed, unbound checkpoints; retain exact restoration data."""
import argparse
import gzip
import hashlib
import json
import os
from pathlib import Path
import shutil
import time

R = Path(__file__).resolve().parent
B = R / 'diagnosis/search-regression-repair-20261010'
UNITS = ['tiling-chain-strict1-continuation1/runs/b256/gcn/fission']


def require(condition, message):
    if not condition:
        raise ValueError(message)


def digest(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for chunk in iter(lambda: stream.read(4 << 20), b''):
            h.update(chunk)
    return h.hexdigest()


def write_new(path, data):
    with path.open('x') as stream:
        json.dump(data, stream, indent=2)
        stream.write('\n')


def active_readers(unit):
    names = [str(unit), str(unit).split('/runs/')[0]]
    found = []
    for p in Path('/proc').iterdir():
        if not p.name.isdigit() or int(p.name) == os.getpid():
            continue
        try:
            cmd = (p / 'cmdline').read_bytes().decode(errors='replace')
        except OSError:
            continue
        if any(name in cmd for name in names):
            found.append(int(p.name))
    return found


def archive(output):
    require(not output.exists(), 'Preserve previous receipt; choose new output')
    output.mkdir(parents=True)
    bindings = [B / f'critical-positive-compute-v38-{s}256-continuation1/prepared-v2/pipeline-binding.json'
                for s in ('full', 'replica')]
    bindings.append(B / 'critical-positive-compute-v38-tiling256-continuation1/prepared-v1/pipeline-binding.json')
    binding_hashes = {str(p): digest(p) for p in bindings}
    protected = set()
    for p in bindings:
        protected.update(json.loads(p.read_text())['input_sha256'])
    rows = []
    before_free = shutil.disk_usage(B).free
    for relative in UNITS:
        unit = B / relative
        raw = unit / 'search/checkpoint.json'
        packed = raw.with_name(raw.name + '.gz')
        temporary = packed.with_name(packed.name + '.partial')
        require(str(raw) not in protected, 'Current run binds checkpoint: ' + str(raw))
        require(not active_readers(unit), 'A process still references old cohort')
        require(raw.is_file() and not raw.is_symlink() and not packed.exists()
                and not temporary.exists(), 'Unsafe/existing archive target')
        result_path = unit / 'result.json'
        completion_path = unit / 'completion.json'
        result_hash, completion_hash = digest(result_path), digest(completion_path)
        result = json.loads(result_path.read_text())
        completion = json.loads(completion_path.read_text())
        require(result['status'] == 'completed' and result['objective_evaluations'] == 256
                and completion['status'] == 'pass', 'Old cohort is not closed')
        expected = result['artifact_hashes'][str(raw)]
        initial = raw.stat()
        h, count = hashlib.sha256(), 0
        with raw.open('rb') as source, temporary.open('xb') as target:
            with gzip.GzipFile(filename='', mode='wb', fileobj=target, compresslevel=1, mtime=0) as compressed:
                for chunk in iter(lambda: source.read(4 << 20), b''):
                    h.update(chunk)
                    count += len(chunk)
                    compressed.write(chunk)
            target.flush()
            os.fsync(target.fileno())
        require(h.hexdigest() == expected and count == initial.st_size,
                'Raw checkpoint differs from original sealed bytes')
        restored, restored_count = hashlib.sha256(), 0
        with gzip.open(temporary, 'rb') as stream:
            for chunk in iter(lambda: stream.read(4 << 20), b''):
                restored.update(chunk)
                restored_count += len(chunk)
        require(restored.hexdigest() == expected and restored_count == count,
                'Compressed checkpoint does not restore exact original bytes')
        final = raw.stat()
        require((final.st_ino, final.st_size, final.st_mtime_ns) ==
                (initial.st_ino, initial.st_size, initial.st_mtime_ns), 'Raw file changed during capture')
        require(digest(result_path) == result_hash and digest(completion_path) == completion_hash
                and not active_readers(unit), 'Closed inputs changed or became active')
        for p, value in binding_hashes.items():
            require(digest(p) == value, 'Current prepared binding changed')
        temporary.rename(packed)
        row = dict(original_path=str(raw), original_bytes=count, original_sha256=expected,
                   original_mode=initial.st_mode & 0o7777, original_mtime_ns=initial.st_mtime_ns,
                   archive_path=str(packed), archive_bytes=packed.stat().st_size,
                   archive_sha256=digest(packed), decompressed_sha256_verified=True,
                   original_result_sha256=result_hash, original_completion_sha256=completion_hash,
                   current_binding_dependency=False)
        write_new(output / f'checkpoint-{len(rows)}.json', row)
        raw.unlink()
        rows.append(row)
        print(json.dumps(dict(archived=str(raw), raw_bytes=count, compressed_bytes=row['archive_bytes'])), flush=True)
    receipt = dict(schema='orbit-closed-checkpoint-lossless-archive-v2-tiling-headroom', status='pass',
                   entries=rows, source38_prepared_bindings_sha256=binding_hashes,
                   script_sha256=digest(__file__), protected_current_input_paths=len(protected),
                   free_bytes_before=before_free, free_bytes_after=shutil.disk_usage(B).free,
                   extra_objective_native_numeric_calls=0, epoch=time.time(),
                   restoration='Run this script with --restore RECEIPT.json; raw bytes restore at original paths. Compressed archives remain intact.')
    write_new(output / 'RECEIPT.json', receipt)
    print(json.dumps(dict(status='pass', receipt=str(output / 'RECEIPT.json'),
                         free_gib=receipt['free_bytes_after'] / 2**30)), flush=True)


def restore(receipt_path):
    receipt = json.loads(receipt_path.read_text())
    require(receipt['status'] == 'pass', 'Archive receipt is not complete')
    for row in receipt['entries']:
        raw, packed = Path(row['original_path']), Path(row['archive_path'])
        require(not raw.exists(), 'Original path already exists; preserve it')
        require(digest(packed) == row['archive_sha256'], 'Compressed archive differs')
        temporary = raw.with_name(raw.name + '.restore-partial')
        h, size = hashlib.sha256(), 0
        with gzip.open(packed, 'rb') as source, temporary.open('xb') as target:
            for chunk in iter(lambda: source.read(4 << 20), b''):
                h.update(chunk)
                size += len(chunk)
                target.write(chunk)
            target.flush()
            os.fsync(target.fileno())
        require(h.hexdigest() == row['original_sha256'] and size == row['original_bytes'],
                'Restored bytes differ from original sealed checkpoint')
        os.chmod(temporary, row['original_mode'])
        os.utime(temporary, ns=(row['original_mtime_ns'], row['original_mtime_ns']))
        temporary.rename(raw)
        print(json.dumps(dict(restored=str(raw), sha256=row['original_sha256'])), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--output', type=Path)
    group.add_argument('--restore', type=Path)
    args = parser.parse_args()
    archive(args.output) if args.output else restore(args.restore)


if __name__ == '__main__':
    main()
