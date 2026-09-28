# Evidence classes and capability states

Every candidate result uses one `evidence_class`:

| Value | Meaning |
|---|---|
| `host_semantic_execution` | Generated Taskflow IR JIT run against numeric references; correctness only |
| `analytical_estimate` | Formula/model estimate without a native mapper run |
| `predictor_estimate` | Pinned learned task cost predictor output |
| `native_mapper_replay` | Measured native backend/mapper execution for a selected candidate |
| `rtl_cycle_measurement` | RTL testbench cycle observation under its declared memory model |

Four independent capability flags are required: `semantic_legal`, `backend_legal`, `artifact_available`, and `measurement_available`. Results may be `accepted`, `semantic_rejected`, `backend_unsupported`, `artifact_missing`, `measurement_censored`, `execution_failed`, `not_selected`, or `selected`. An unavailable, censored, failed, or rejected result has `cost: null`; zero is a valid measured value only when explicitly available. Ranking excludes null costs and uses stable candidate IDs for ties.

Semantic legality does not imply backend lowering support. Mapper failure does not invalidate semantic legality. `modules/contracts.py` enforces these distinctions for layered candidate records. Existing source-owned graph IDs remain unchanged.

