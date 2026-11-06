# Installed BO sync API audit, v14

This audit traces the installed host API without opening an XRT device or
submitting a kernel. It does not revise v13 measurements, coefficients, runtime,
or acceptance results. Evidence is in
[`api-audit-r1`](../../results/taskflow/sync-state-v14/api-audit-r1/metadata.json).
Statements below distinguish installed-file facts, previous observations, and
unverified explanations.

## Installed identity and source limits

| Component | Identified installation |
|---|---|
| Python binding | `python3-xrt 1:2.21.75-1~noble1`; `/usr/lib/python3/dist-packages/pyxrt.cpython-312-x86_64-linux-gnu.so`, SHA `c35a762a…` |
| XRT core and NPU shim | `libxrt2/libxrt-npu2 1:2.21.75-1~noble1`; coreutil and driver libraries under `/usr/lib/x86_64-linux-gnu` |
| NPU shim | `libxrt_driver_xdna.so.2.21.75`, SHA `e1250451844744149420986ba707f9f1e301530e92663c69e534c7195cc1e9c1`, build ID `ddd2ee9860978ece67cb3f474dd7f4fb0bcc40dc` |
| Running kernel | Ubuntu `7.0.0-28-generic`; module file belongs to `linux-modules-7.0.0-28-generic 7.0.0-28.28~24.04.1` |
| Module correspondence | `modinfo` file and `/sys/module/amdxdna/srcversion` both report `E4FC5AFFF53D21BC6AFDAE3`; this is not a dump/hash of live kernel memory |
| Separately installed source | `/usr/src/amdxdna-7.0.0-rc1+git20260310.6b13cb8f4`; DKMS package version does **not** identify the loaded Ubuntu module build |

The installed XRT version header has empty Git branch/hash/date fields. Package
checksums, ELF build IDs, full SHA256s, command outputs and selected disassemblies
are retained. An available newer APT candidate is not the installed version.

Official upstream sources were browsed and pinned: [XRT tag 2.21.75,
`4eb1f439…`, Python binding](https://github.com/Xilinx/XRT/blob/4eb1f4392a012b4e6eca759762389c612537f7c7/src/python/pybind11/src/pyxrt.cpp)
and [AMD xdna-driver `1042eec2…`, buffer implementation](https://github.com/amd/xdna-driver/blob/1042eec224fe6e2755ffa3c72c881e8441988d7c/src/shim/buffer.cpp).
Their exact snapshots/hashes are retained. The latter is a current upstream
comparison, not the installed shim revision; it uses a newer delegated cache
policy. Neither source is asserted to be the exact packaged build input.

## Source- and binary-confirmed call path

1. `pyxrt.bo.sync(direction, size, offset)` invokes the size/range C++ API. The
   installed binding doc distinguishes synchronization from a guaranteed DMA.
   The installed `xrt_bo.h` one-argument overload calls
   `sync(direction, size(), 0)`. Full-range equivalence therefore requires the
   explicit requested size to equal `bo.size()`; Python overload dispatch and
   the size query remain different host work.
2. `xrt::bo::sync` in the installed core library dispatches through its BO
   implementation, with an optional profiling branch. It is distinct from
   asynchronous BO APIs and from kernel submission/completion.
3. Installed `shim_xdna::buffer::sync` at VMA `0x39350` has three paths. A
   cache-coherent provider returns immediately. Otherwise
   `Debug.force_driver_sync` selects the driver path; its compiled default is
   false. The alternative walks the mapped requested range using `CLFLUSH`
   (`0x393e8`). It performs that walk on every call; there is no per-BO
   dirty/previous-sync memoization in this routine. TO/FROM do not select
   different instructions within this userspace loop.
4. Installed KMQ's coherence query returns false; UMQ's returns true. These
   alternatives are visible in the same binary. Which provider/configuration
   v13 actually selected was not recorded, so the default/KMQ path is a
   conditional explanation until the separate path diagnostic observes it.
5. `sync_by_driver` range-checks and issues the driver request. The host shim
   encodes ioctl `0xc0186445`. Disassembly of the module file selected by
   `modinfo` confirms calls to GEM pinning and `drm_clflush_sg`,
   `drm_clflush_virt_range`, or `drm_clflush_pages`. The range branch uses the
   requested offset/size; imported/page-backed branches can cover the backing
   object rather than only the requested subrange. FROM has an additional
   debug-BO sync path. The separately identified DKMS source has corresponding
   cache-maintenance logic, but is not used as an exact loaded-source proof.

The mapped host view and device BO denote shared system storage in the current
execution binding. Cache synchronization is separate from `np.copyto` staging
and from compiled NPU system-memory-to-local tensor DMA. Requested byte counts
are not physical DDR traffic. A host return brackets API work; it does not mean
that an NPU program completed. The absence of an explicit fence in the shim's
userspace loop is a binary observation, **not** a claim of SDK incoherence or a
hardware drain-time measurement. Instruction ordering must not be inferred from
old manuals or one disassembled routine alone.

## Why v13 timings are not interchangeable

The direct microbench brackets a lambda calling the three-argument sync. The
program observer brackets a Python variadic wrapper calling the one-argument
sync; its end timestamp occurs after enum-to-string conversion. The latter span
therefore includes additional wrapper/formatting work. Neither timer measures
only a hardware cache operation. Their relationship needs a paired experiment,
not an assumed constant subtraction.

V13's sequence state is set once before its counted calls. Later syncs have no
explicit host read/write setup, but are not proven zero-work operations. A
host-read setup can populate cache lines again. The installed userspace path
also visits each line even after an earlier sync; a driver path may perform
pinning, cache work and ioctl overhead again. These facts invalidate a blanket
"repeat TO is a no-op" interpretation without identifying the path.

The preserved v13 [outlier analysis](../../results/taskflow/program-graph-heterogeneous-v13/mechanism-outlier-analysis-r1.json)
reports 504 post-TO training calls: median 450 ns, with one retained 714691 ns
span contributing 71.501% of the row's sum. Heldout median was 390 ns. This
explains sensitivity of that mean-based fit, not the physical cause of the long
span. OS scheduling, profiling/runtime work, cache state and maintenance remain
hypotheses; no trace identifies one as the cause. No outlier is deleted and no
heldout-driven coefficient replacement is justified by this audit.

## Separate path diagnostic and next experiment boundary

[`audit_sync_path_v14.py`](../scripts/audit_sync_path_v14.py) prepares a frozen
four-call probe: TO/FROM, each as full-buffer and explicit-region sync. It binds
the exact shim, core, Python binding, interpreter, kernel-module file, debugger,
tracer, generated scripts, cwd and configuration candidates. GDB classifies
coherent return, actual userspace `CLFLUSH`, or `sync_by_driver`; strace brackets
ioctls with explicit sync markers. It opens a BO only when the coordinator runs
the generated commands and creates no XRT run object. Debugger/strace wall time
is not calibration data. Historical v13 configuration is not reconstructed by a
new-process observation.

The coordinator subsequently ran a separate [first path probe](../../results/taskflow/sync-state-v14/path-probe-r1/).
Its GDB log observes five entries, each taking the userspace `CLFLUSH` path with
64-byte stride. Four explicit sync scopes in the separate strace log contain no
ioctl. One additional full-range TO entry is present; because setup markers and
GDB records were saved to separate streams, its setup/automatic origin is not
established. The [read-only review](../../results/taskflow/sync-state-v14/api-audit-r1/path-probe-r1-review.json)
binds the original logs and records that limit. A second diagnostic adds unified
stdout markers for device creation, BO construction, map and host fill, plus
shim `self` pointers and short entry stacks. This new-process branch evidence
does not establish the historical v13 branch or explain its timing outlier.

The [second coordinator probe](../../results/taskflow/sync-state-v14/path-probe-r2/gdb.merged.log)
resolves the extra entry. Between `BO_CREATE_BEGIN` and `BO_CREATE_END`,
`buffer::expand` calls full-range TO sync through the BO constructor. This is
before map and host fill, and uses the same C++ `self` pointer as the four later
manual calls. The mapped address matches the flush-loop address; the partial
calls start at mapped base plus 128. All five entries choose userspace CLFLUSH
with stride 64. The four marked manual strace scopes contain no ioctl. These
checks and full input hashes are preserved in
[path-probe-r2-review.json](../../results/taskflow/sync-state-v14/api-audit-r1/path-probe-r2-review.json).
The constructor's sync cannot synchronize host writes performed afterward.

The outer installed `xrt::bo::sync` wrapper was also examined: it dispatches
through a virtual implementation, optionally with profiling. The caller frame
in this probe resolves to internal VMA `0x132078`, followed by another virtual
dispatch. The shim's local instruction sequence therefore does not establish
the ordering semantics of the entire API or all callers. API return confirms
that the host call returned; it is not a measurement of cache writeback drain,
physical DDR traffic, device visibility latency, or NPU execution completion.
No missing-fence defect is asserted.

[`collect_sync_target_v14.py`](../scripts/collect_sync_target_v14.py) exports
CPU-only `collect_snapshot()`: canonical file hashes, package/kernel/module and
CPU facts, and cwd/config candidates. A separate observation binding references
the probe logs. The target key excludes probe/output paths and debug timing;
configuration candidates still do not prove which file XRT selected. A future
microbench can compare the same snapshot before and after measurement without
opening another device or rerunning the probe. The captured target is
[target-fingerprint-r1](../../results/taskflow/sync-state-v14/api-audit-r1/target-fingerprint-r1/target-fingerprint.json).

Before further timing, preregister the actual branch/configuration, complete
binary identities, same API overload and same observation boundary. Compare
`TO→TO`, `TO→host-read→TO`, and `TO→host-write→TO` as operational sequences,
with per-call position retained. Use repeated epochs and a noise policy fixed
before heldout labels; retain wall/CPU-time or scheduling evidence if collected.
Do not substitute sync coefficients for internal NPU DMA bandwidth or infer
cold-device behavior from first-in-process calls. Performance search remains
outside this audit.

## Evidence and model-domain boundary

| Claim | Evidence class and limit |
|---|---|
| Full-buffer overload uses BO extent and offset zero | Installed header and Python binding API; Python dispatch work differs from explicit-range form |
| TO/FROM in this new probe execute CLFLUSH with 64-byte stride | Actual GDB branch/arguments and merged markers, bound to installed shim bytes; not a reconstruction of v13 |
| BO construction performs an implicit full-range TO | Actual `buffer::expand` stack inside constructor markers, before map/fill; excluded from later manual API spans |
| Four manual sync scopes issue no ioctl | Actual strace scope check; alone this would not distinguish coherent return from userspace flush |
| Original runner sync timing differs from a prebound micro loop | Source-bound observation envelopes and actual ABI site; no constant overhead subtraction assumed |
| DDR bandwidth, full physical cache drain, or internal NPU DMA time | Not measured; requested cacheline count is a model feature, not a physical-byte counter |

The proposed primary post-TO batch model has the explicit form
`entry + count * (call + cacheline * requested_lines)`. Its domain must retain
post-TO/no-intervening-access sequence history, invocation form, observer boundary,
target fingerprint, and observed range/count limits. A first call after host
write/read or after device activity is a different operational prefix. Small
residuals do not establish a universal synchronization law.

The actual original-runner API-site model is a separate fixed-site domain,
limited to verified 1024–4096-byte BOs and its frozen detailed observer envelope.
Input-loop syncs include the runner's conservative TO of the output argument;
output readback occurs after successful wait. It must not silently reuse the
prebound-loop fit, extrapolate to an unmeasured BO extent, or turn a sync span
into compute/wait/launch cost. The model and independent checker are maintained
separately; this audit defines the required scope, not a claim that an unfinished
fit has passed heldout validation.

## Reproduction entry

[`run_sync_state_v14.sh`](../scripts/run_sync_state_v14.sh) is source-safe and
accepts a frozen protocol, a new output directory and the model-script path.
It performs no search or compilation. `validate-only` runs CPU checks and validates
both split invocations without opening a device. Explicit `all` measures micro
and unmodified `Prepared.one` calibration sets, fits once, records all model-file
hashes before either heldout measurement, verifies the model remains unchanged,
and invokes the independent audit with that pre-heldout gate.

```bash
bash taskflow/scripts/run_sync_state_v14.sh \
  --mode validate-only --protocol /absolute/frozen/protocol.json \
  --new-output /absolute/new/output \
  --model-script "$PWD/taskflow/test/TaskflowModels/fit_sync_cost_v14.py"
```

For coordinator-run measurement, use `--mode all` with the same frozen protocol
and a fresh output directory. Optional `--python` and `--aie-env` select the
existing compatible environment. Execution changes cwd to the artifact repository
because cwd/config lookup is part of the target fingerprint. Effective loader
variables are recorded. Installed-library file hashes are not a complete dump of
current process mappings or every transitive library; the separate probe's actual
loaded paths remain evidence for that probe. No v13 source, coefficient or raw
measurement is replaced.
