# Public mechanism timing and NPU whole-invocation validation (v16)

The production architecture is documented in the companion ORBIT repository,
`docs/taskflow-mechanism-program-v16.md` and `docs/taskflow-program-timing-v16.md`.

The complete evidence and reproduction commands are in
[RESULTS](../../results/taskflow/mechanism-program-v16/RESULTS.md), with
[independent review](../../results/taskflow/mechanism-program-v16/independent-complete-review-r1/REPORT.md).

Frozen heldout:7/8,MAPE5.586689%; same-parameter new process:6/8,MAPE9.759001%.
Automatic candidate differences remain below measurement resolution, so the
conditional two-round performance search is not resumed. Public resource timing
is implemented; device-internal overlap, pure DMA and physical bandwidth remain
unknown. Original v15 parameters fail the genuine same-model new-session check
(0/9,MAPE62.608429%). No recalibration replaces that failure.

Entry: `taskflow/scripts/run_program_mechanisms_v16.sh --help`.
CPU mode requires built native test targets and never opens a device. Hardware
mode validates explicit frozen packages, acquires the existing lock inside the
runner, records host/API spans and independently checks numerical outputs.
