#define HIDDEN_DIM 256
#define MAX_SEQ_LEN 512
#define SOFTMAX_SCALE 1024

void llama_func(int seq_len, const int x[MAX_SEQ_LEN][HIDDEN_DIM],
                const int wq[HIDDEN_DIM][HIDDEN_DIM],
                const int wk[HIDDEN_DIM][HIDDEN_DIM],
                const int wv[HIDDEN_DIM][HIDDEN_DIM],
                const int w_gate[HIDDEN_DIM][HIDDEN_DIM],
                const int w_up[HIDDEN_DIM][HIDDEN_DIM],
                const int w_down[HIDDEN_DIM][HIDDEN_DIM],
                int output[MAX_SEQ_LEN][HIDDEN_DIM]) {
  int q[MAX_SEQ_LEN][HIDDEN_DIM];
  int k[MAX_SEQ_LEN][HIDDEN_DIM];
  int v[MAX_SEQ_LEN][HIDDEN_DIM];
  int scores[MAX_SEQ_LEN][MAX_SEQ_LEN];
  int probs[MAX_SEQ_LEN][MAX_SEQ_LEN];
  int denom[MAX_SEQ_LEN];
  int attn_out[MAX_SEQ_LEN][HIDDEN_DIM];
  int gate[MAX_SEQ_LEN][HIDDEN_DIM];
  int up[MAX_SEQ_LEN][HIDDEN_DIM];
  int act[MAX_SEQ_LEN][HIDDEN_DIM];

  // Task 0: Q projection, Q = X * Wq.
  for (int row = 0; row < seq_len; ++row) {
    for (int col = 0; col < HIDDEN_DIM; ++col) {
      q[row][col] = 0;
      for (int red = 0; red < HIDDEN_DIM; ++red) {
        q[row][col] += x[row][red] * wq[red][col];
      }
    }
  }

  // Task 1: K projection, K = X * Wk.
  for (int row = 0; row < seq_len; ++row) {
    for (int col = 0; col < HIDDEN_DIM; ++col) {
      k[row][col] = 0;
      for (int red = 0; red < HIDDEN_DIM; ++red) {
        k[row][col] += x[row][red] * wk[red][col];
      }
    }
  }

  // Task 2: V projection, V = X * Wv.
  for (int row = 0; row < seq_len; ++row) {
    for (int col = 0; col < HIDDEN_DIM; ++col) {
      v[row][col] = 0;
      for (int red = 0; red < HIDDEN_DIM; ++red) {
        v[row][col] += x[row][red] * wv[red][col];
      }
    }
  }

  // Task 3: Attention score, S = Q * K^T.
  for (int q_row = 0; q_row < seq_len; ++q_row) {
    for (int k_row = 0; k_row < seq_len; ++k_row) {
      scores[q_row][k_row] = 0;
      for (int dim = 0; dim < HIDDEN_DIM; ++dim) {
        scores[q_row][k_row] += q[q_row][dim] * k[k_row][dim];
      }
    }
  }

  // Task 4: Softmax approximation numerator and denominator.
  for (int row = 0; row < seq_len; ++row) {
    denom[row] = 0;
    for (int col = 0; col < seq_len; ++col) {
      int score = scores[row][col];
      int approx_exp = score * score + 1;
      probs[row][col] = approx_exp;
      denom[row] += approx_exp;
    }
  }

  // Task 5: Softmax normalization, P = softmax(S).
  for (int row = 0; row < seq_len; ++row) {
    int row_denom = denom[row] + 1;
    for (int col = 0; col < seq_len; ++col) {
      // Keep probabilities in Q10 fixed point so fractional values are not
      // truncated to zero by integer division.
      probs[row][col] =
          (probs[row][col] * SOFTMAX_SCALE) / row_denom;
    }
  }

  // Task 6: Attention value aggregation, A = P * V (P is Q10).
  for (int row = 0; row < seq_len; ++row) {
    for (int col = 0; col < HIDDEN_DIM; ++col) {
      attn_out[row][col] = 0;
      for (int red = 0; red < seq_len; ++red) {
        attn_out[row][col] += probs[row][red] * v[red][col];
      }
      attn_out[row][col] /= SOFTMAX_SCALE;
    }
  }

  // Task 7: FFN gate and up projections.
  for (int row = 0; row < seq_len; ++row) {
    for (int col = 0; col < HIDDEN_DIM; ++col) {
      gate[row][col] = 0;
      up[row][col] = 0;
      for (int red = 0; red < HIDDEN_DIM; ++red) {
        int input = attn_out[row][red];
        gate[row][col] += input * w_gate[red][col];
        up[row][col] += input * w_up[red][col];
      }
    }
  }

  // Task 8: FFN activation, Act = SiLU(Gate) * Up.
  for (int row = 0; row < seq_len; ++row) {
    for (int col = 0; col < HIDDEN_DIM; ++col) {
      int gate_val = gate[row][col];
      int up_val = up[row][col];
      int silu_approx = gate_val * (gate_val + 1);
      act[row][col] = silu_approx * up_val;
    }
  }

  // Task 9: FFN down projection, Output = Act * Wdown.
  for (int row = 0; row < seq_len; ++row) {
    for (int col = 0; col < HIDDEN_DIM; ++col) {
      output[row][col] = 0;
      for (int red = 0; red < HIDDEN_DIM; ++red) {
        output[row][col] += act[row][red] * w_down[red][col];
      }
    }
  }
}
