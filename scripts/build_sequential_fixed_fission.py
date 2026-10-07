#!/usr/bin/env python3
"""Relink the matched controller against an unchanged accepted repaired build."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import time

DIRECTORY = "lib/Backend/Neura/Orchestration/JointScheduling"
OWNED = {f"{DIRECTORY}/{name}.cpp" for name in (
    "JointNeighborhoodSearchPass", "MapJointSchedulingTasksPass", "PredictAnalyticalTaskCostCatalogPass")}
LIBRARY = f"{DIRECTORY}/libMLIRAmoebaNeuraJointScheduling.a"
TARGET = "tools/mlir-amoeba-opt/mlir-amoeba-opt"


def binding(path):
    path = Path(path)
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return {"path": str(path.resolve()), "size": path.stat().st_size, "sha256": digest.hexdigest()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline-build", type=Path, required=True)
    parser.add_argument("--baseline-contract", type=Path, required=True)
    parser.add_argument("--source-root", type=Path, required=True)
    parser.add_argument("--work-dir", type=Path, required=True)
    parser.add_argument("--optimizer", type=Path, required=True)
    args = parser.parse_args()
    build, contract_path, source, work, optimizer = (p.resolve() for p in (
        args.baseline_build, args.baseline_contract, args.source_root, args.work_dir, args.optimizer))
    if optimizer.exists() or work.exists():
        raise ValueError("choose fresh build work and optimizer pin paths")
    cache = (build / "CMakeCache.txt").read_text().splitlines()
    original = Path(next(line.split("=", 1)[1] for line in cache if line.startswith("CMAKE_HOME_DIRECTORY:")))
    contract = json.loads(contract_path.read_text())
    for row in contract["sources"]:
        if (original / row["path"]).read_text() != row["text"]:
            raise ValueError("accepted repaired baseline source changed: " + row["path"])
    changed = []
    for scope in ("include", "lib", "thirdparty/neura/include", "thirdparty/neura/lib"):
        for path in (original / scope).rglob("*"):
            if not path.is_file() or path.suffix not in {".cpp", ".h", ".td", ".inc", ".txt", ".cmake"}:
                continue
            relative = path.relative_to(original)
            if not (source / relative).is_file() or (source / relative).read_bytes() != path.read_bytes():
                changed.append(str(relative))
    if not changed or set(changed) - OWNED or f"{DIRECTORY}/JointNeighborhoodSearchPass.cpp" not in changed:
        raise ValueError("only matched controller/accounting sources may differ: " + str(changed))
    commands = subprocess.check_output(["ninja", "-C", str(build), "-t", "commands", TARGET], text=True).splitlines()
    work.mkdir(parents=True)
    optimizer.parent.mkdir(parents=True, exist_ok=True)
    library = work / "libMLIRAmoebaNeuraJointScheduling.a"
    original_library = binding(build / LIBRARY)
    shutil.copyfile(build / LIBRARY, library)
    subprocess.run(["strip", "--strip-debug", str(library)], check=True)
    compile_commands = []
    started = time.monotonic()
    for relative in sorted(changed):
        line = next(line for line in commands if relative in line and " -c " in line)
        argv = [word.replace(str(original) + '/', str(source) + '/') for word in shlex.split(line)]
        obj = work / (Path(relative).name + ".o")
        for flag, value in (("-o", str(obj)), ("-MF", str(obj) + ".d"), ("-MT", str(obj))):
            argv[argv.index(flag) + 1] = value
        argv.extend(["-g0", "-fmax-errors=8", "-fno-diagnostics-color"])
        print("Compile " + relative, flush=True)
        log_path = work / (Path(relative).name + '.compile.log')
        with log_path.open('w') as log:
            process = subprocess.run(argv, cwd=build, stdout=log, stderr=subprocess.STDOUT)
        if process.returncode:
            print(log_path.read_text()[:12000], flush=True)
            raise RuntimeError('compile failed; complete diagnostics: ' + str(log_path))
        subprocess.run(["ar", "r", str(library), str(obj)], check=True)
        compile_commands.append(argv)
    words = shlex.split(commands[-1])
    begin = words.index("&&") + 1 if "&&" in words else 0
    end = words.index("&&", begin) if "&&" in words[begin:] else len(words)
    argv = [str(library) if word == LIBRARY else word for word in words[begin:end]]
    if str(library) not in argv:
        raise ValueError("link command lacks the owned archive")
    partial_optimizer = Path(str(optimizer) + '.link-partial')
    argv[argv.index("-o") + 1] = str(partial_optimizer)
    argv.append("-Wl,--strip-debug")
    print("Link repaired-source matched immutable pin", flush=True)
    with (work / 'link.log').open('w') as log:
        process = subprocess.run(argv, cwd=build, stdout=log, stderr=subprocess.STDOUT)
    if process.returncode:
        raise RuntimeError('link failed; diagnostics: ' + str(work / 'link.log'))
    os.replace(partial_optimizer, optimizer)
    optimizer.chmod(0o555)
    if binding(build / LIBRARY) != original_library:
        raise ValueError("baseline archive changed during incremental compilation")
    record = {"schema": "orbit-sequential-fixed-fission-build-v1", "baseline_build": str(build),
        "baseline_contract": binding(contract_path), "source_root": str(source),
        "source_files_changed": sorted(changed), "compile_argv": compile_commands, "link_argv": argv,
        "baseline_archive": original_library, "baseline_build_modified": False,
        "optimizer_binding": binding(optimizer), "wall_seconds": time.monotonic() - started}
    (optimizer.parent.parent / "build-provenance.json").write_text(json.dumps(record, indent=2) + "\n")
    print(json.dumps({k: v for k, v in record.items() if k not in {"compile_argv", "link_argv"}}), flush=True)


if __name__ == "__main__":
    main()
