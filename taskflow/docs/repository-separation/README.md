# Repository separation acceptance

Compiler base: `bd84364345631ac76369fe2d30f0e75d2fab59d8`. The split changes paths and ownership, not production C++ semantics. Existing artifact input-0 material is preserved.

- Fresh independent Core build and 16 compiler test groups passed without backend/runtime dependencies.
- Complete v8 CPU reproduction in `.work/repository-split/v8-reproduce-r3` passed, including original Amoeba/search, direct AIR code generation, channel/storage checks, two-round joint data search and eight existing CGRA model contracts. See `cpu-integration.log`.
- Earlier r1/r2 path integration failures remain in ignored local archives; r3 fixes Python-venv air-opt discovery and fixture roots.
- All 80 pre-migration identity anchors and offline numerical audits of original v7/v8 candidate/M128 outputs remained unchanged. Frozen long FFN tests were not repeated for this file-ownership change.
- Migration receipts retain original/new paths and source hashes. Full raw results and 47GB-scale archives are local under `results/taskflow/` and `.work/`, excluded from Git. These small receipts and reports are published; they do not imply that raw binary archives have been uploaded.

Clean reproduction from sibling checkouts:

```sh
cd orbit-artifact
bash taskflow/scripts/run_taskflow_data_organization_v8.sh cpu results/taskflow/repository-split-NEW
```

The machine's installed LLVM/AIR environment is required as described by the entry points. `ORBIT_SRC`, `ORBIT_BUILD_ROOT` and `ORBIT_RESULTS_ROOT` override defaults. Old absolute-path aliases preserve frozen historical execution, not relocatable CMake caches.
