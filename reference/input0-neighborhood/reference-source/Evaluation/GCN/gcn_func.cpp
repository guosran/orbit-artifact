// GCN benchmark for AMOEBA evaluation.
//
// Reference:
// - Streaming-Bench, commit 333782f78d5475c8b33b11ff2b9ba9d75c93ca49:
//   gcn/aggregate1, gcn/aggregate2, gcn/combine, gcn/combineRelu,
//   gcn/compress, and gcn/pooling.
// - Kipf and Welling, "Semi-Supervised Classification with Graph
//   Convolutional Networks", ICLR 2017.
// - Schlichtkrull et al., "Modeling Relational Data with Graph
//   Convolutional Networks", ESWC 2018.
//
// This is a fixed-shape, affine-friendly relational GCN pipeline. The task
// boundaries are algorithmic stages, not artificial feature chunks:
//   1. compute per-relation degrees
//   2. normalize each relation adjacency matrix
//   3. run three rounds of message passing
//   4. pool node embeddings into a graph embedding
//
// Expected task count after affine-to-taskflow: 28 top-level loop nests.
//
// The stage outputs are caller-provided scratch buffers. Keeping them at the
// function boundary forces cgeist to materialize each stage as a real memref
// instead of expanding previous-stage expressions into later aggregate
// kernels.

#define MAX_NODES 256
#define FEATURE_DIM 16
#define RELATION_COUNT 4
#define LAYER_COUNT 3
#define AGGREGATE_STAGE_COUNT (LAYER_COUNT * RELATION_COUNT)

void gcn_func(int node_count, const int relation0[MAX_NODES][MAX_NODES],
              const int relation1[MAX_NODES][MAX_NODES],
              const int relation2[MAX_NODES][MAX_NODES],
              const int relation3[MAX_NODES][MAX_NODES],
              const int feature[MAX_NODES][FEATURE_DIM],
              const int weight0[FEATURE_DIM][FEATURE_DIM],
              const int weight1[FEATURE_DIM][FEATURE_DIM],
              const int weight2[FEATURE_DIM][FEATURE_DIM],
              int degree[RELATION_COUNT][MAX_NODES],
              int norm[RELATION_COUNT][MAX_NODES][MAX_NODES],
              int self_transform[LAYER_COUNT][MAX_NODES][FEATURE_DIM],
              int aggregate[AGGREGATE_STAGE_COUNT][MAX_NODES][FEATURE_DIM],
              int hidden[LAYER_COUNT][MAX_NODES][FEATURE_DIM],
              int graph_output[FEATURE_DIM]) {
  // Task 0: Degree for relation 0.
  for (int dst = 0; dst < node_count; ++dst) {
    degree[0][dst] = 1;
    for (int src = 0; src < node_count; ++src) {
      degree[0][dst] += relation0[dst][src];
    }
  }

  // Task 1: Degree for relation 1.
  for (int dst = 0; dst < node_count; ++dst) {
    degree[1][dst] = 1;
    for (int src = 0; src < node_count; ++src) {
      degree[1][dst] += relation1[dst][src];
    }
  }

  // Task 2: Degree for relation 2.
  for (int dst = 0; dst < node_count; ++dst) {
    degree[2][dst] = 1;
    for (int src = 0; src < node_count; ++src) {
      degree[2][dst] += relation2[dst][src];
    }
  }

  // Task 3: Degree for relation 3.
  for (int dst = 0; dst < node_count; ++dst) {
    degree[3][dst] = 1;
    for (int src = 0; src < node_count; ++src) {
      degree[3][dst] += relation3[dst][src];
    }
  }

  // Task 4: Normalize relation 0.
  for (int dst = 0; dst < node_count; ++dst) {
    for (int src = 0; src < node_count; ++src) {
      norm[0][dst][src] = relation0[dst][src] * 1024 / degree[0][dst];
    }
  }

  // Task 5: Normalize relation 1.
  for (int dst = 0; dst < node_count; ++dst) {
    for (int src = 0; src < node_count; ++src) {
      norm[1][dst][src] = relation1[dst][src] * 1024 / degree[1][dst];
    }
  }

  // Task 6: Normalize relation 2.
  for (int dst = 0; dst < node_count; ++dst) {
    for (int src = 0; src < node_count; ++src) {
      norm[2][dst][src] = relation2[dst][src] * 1024 / degree[2][dst];
    }
  }

  // Task 7: Normalize relation 3.
  for (int dst = 0; dst < node_count; ++dst) {
    for (int src = 0; src < node_count; ++src) {
      norm[3][dst][src] = relation3[dst][src] * 1024 / degree[3][dst];
    }
  }

  // Task 8: Layer 0 self-feature transform.
  for (int node = 0; node < node_count; ++node) {
    for (int out = 0; out < FEATURE_DIM; ++out) {
      self_transform[0][node][out] = 0;
      for (int in = 0; in < FEATURE_DIM; ++in) {
        self_transform[0][node][out] += feature[node][in] * weight0[in][out];
      }
    }
  }

  // Tasks 9-12: Layer 0 relation-specific message aggregation.
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[0][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[0][dst][feat] += norm[0][dst][src] * feature[src][feat];
      }
    }
  }
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[1][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[1][dst][feat] += norm[1][dst][src] * feature[src][feat];
      }
    }
  }
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[2][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[2][dst][feat] += norm[2][dst][src] * feature[src][feat];
      }
    }
  }
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[3][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[3][dst][feat] += norm[3][dst][src] * feature[src][feat];
      }
    }
  }

  // Task 13: Layer 0 combine self/relation messages and activate.
  for (int node = 0; node < node_count; ++node) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      int value = self_transform[0][node][feat] + aggregate[0][node][feat] +
                  aggregate[1][node][feat] + aggregate[2][node][feat] +
                  aggregate[3][node][feat];
      hidden[0][node][feat] = value > 0 ? value : 0;
    }
  }

  // Task 14: Layer 1 self-feature transform.
  for (int node = 0; node < node_count; ++node) {
    for (int out = 0; out < FEATURE_DIM; ++out) {
      self_transform[1][node][out] = 0;
      for (int in = 0; in < FEATURE_DIM; ++in) {
        self_transform[1][node][out] += hidden[0][node][in] * weight1[in][out];
      }
    }
  }

  // Tasks 15-18: Layer 1 relation-specific message aggregation.
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[4][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[4][dst][feat] += norm[0][dst][src] * hidden[0][src][feat];
      }
    }
  }
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[5][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[5][dst][feat] += norm[1][dst][src] * hidden[0][src][feat];
      }
    }
  }
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[6][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[6][dst][feat] += norm[2][dst][src] * hidden[0][src][feat];
      }
    }
  }
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[7][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[7][dst][feat] += norm[3][dst][src] * hidden[0][src][feat];
      }
    }
  }

  // Task 19: Layer 1 combine with residual from layer 0 and activate.
  for (int node = 0; node < node_count; ++node) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      int value = self_transform[1][node][feat] + aggregate[4][node][feat] +
                  aggregate[5][node][feat] + aggregate[6][node][feat] +
                  aggregate[7][node][feat] + hidden[0][node][feat];
      hidden[1][node][feat] = value > 0 ? value : 0;
    }
  }

  // Task 20: Layer 2 self-feature transform.
  for (int node = 0; node < node_count; ++node) {
    for (int out = 0; out < FEATURE_DIM; ++out) {
      self_transform[2][node][out] = 0;
      for (int in = 0; in < FEATURE_DIM; ++in) {
        self_transform[2][node][out] += hidden[1][node][in] * weight2[in][out];
      }
    }
  }

  // Tasks 21-24: Layer 2 relation-specific message aggregation.
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[8][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[8][dst][feat] += norm[0][dst][src] * hidden[1][src][feat];
      }
    }
  }
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[9][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[9][dst][feat] += norm[1][dst][src] * hidden[1][src][feat];
      }
    }
  }
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[10][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[10][dst][feat] += norm[2][dst][src] * hidden[1][src][feat];
      }
    }
  }
  for (int dst = 0; dst < node_count; ++dst) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      aggregate[11][dst][feat] = 0;
      for (int src = 0; src < node_count; ++src) {
        aggregate[11][dst][feat] += norm[3][dst][src] * hidden[1][src][feat];
      }
    }
  }

  // Task 25: Layer 2 combine with residual from layer 1 and activate.
  for (int node = 0; node < node_count; ++node) {
    for (int feat = 0; feat < FEATURE_DIM; ++feat) {
      int value = self_transform[2][node][feat] + aggregate[8][node][feat] +
                  aggregate[9][node][feat] + aggregate[10][node][feat] +
                  aggregate[11][node][feat] + hidden[1][node][feat];
      hidden[2][node][feat] = value > 0 ? value : 0;
    }
  }

  // Task 26: Graph-level mean pooling.
  for (int feat = 0; feat < FEATURE_DIM; ++feat) {
    graph_output[feat] = 0;
    for (int node = 0; node < node_count; ++node) {
      graph_output[feat] += hidden[2][node][feat];
    }
    graph_output[feat] = graph_output[feat] / node_count;
  }

  // Task 27: Final graph embedding normalization.
  for (int feat = 0; feat < FEATURE_DIM; ++feat) {
    graph_output[feat] = graph_output[feat] / 1024;
  }
}
