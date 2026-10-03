#include "Evaluation/LLaMA/llama_func.cpp"

#include <cstdint>
#include <cstdio>
#include <cstdlib>

struct MemRef2 {
  int32_t *allocated;
  int32_t *aligned;
  int64_t offset;
  int64_t sizes[2];
  int64_t strides[2];
};

static inline int32_t load2(const MemRef2 *memref, int64_t row,
                            int64_t column) {
  return memref->aligned[memref->offset + row * memref->strides[0] +
                         column * memref->strides[1]];
}

static inline void store2(MemRef2 *memref, int64_t row, int64_t column,
                          int32_t value) {
  memref->aligned[memref->offset + row * memref->strides[0] +
                  column * memref->strides[1]] = value;
}

static inline bool shape2(const MemRef2 *memref, int64_t rows) {
  return memref != nullptr && memref->sizes[0] >= rows &&
         memref->sizes[1] == 256 && memref->strides[1] == 1 &&
         memref->strides[0] >= 256;
}

// The input activation is a signed one-hot pattern and every weight is an
// identity-like matrix.  The value projection is scaled so the Q10 divide in
// Task 6 remains nonzero.  Each matrix is still nonuniform and all values are
// bounded, avoiding both all-zero and all-one degeneracies.
static int32_t nonuniformValue(int mode, int64_t row, int64_t column) {
  if (mode == 0)
    return column == row % 256 ? ((row & 1) ? -1 : 1) : 0;
  if (row != column)
    return 0;
  return mode == 3 ? 256 : 1;
}

extern "C" void _mlir_ciface_fill_llama_nonuniform(MemRef2 *memref,
                                                    int32_t mode) {
  if (mode < 0 || mode > 7 || !shape2(memref, mode == 0 ? 512 : 256))
    return;
  const int64_t rows = memref->sizes[0];
  for (int64_t row = 0; row < rows; ++row)
    for (int64_t column = 0; column < 256; ++column)
      store2(memref, row, column,
             mode == 7 ? static_cast<int32_t>(-123456789)
                       : nonuniformValue(mode, row, column));
}

// The return value packs three independently measured quantities:
//   mismatches * 1e12 + actual_nonzero * 1e6 + expected_nonzero.
// A zero mismatch field is required for a positive result; the nonzero counts
// demonstrate that the positive case did not pass through an all-zero output.
extern "C" int64_t _mlir_ciface_check_llama_nonuniform(
    int32_t seq_len, MemRef2 *x, MemRef2 *wq, MemRef2 *wk, MemRef2 *wv,
    MemRef2 *w_gate, MemRef2 *w_up, MemRef2 *w_down, MemRef2 *output) {
  if (seq_len < 0 || seq_len > 512 || !shape2(x, 512) ||
      !shape2(output, 512) || !shape2(wq, 256) || !shape2(wk, 256) ||
      !shape2(wv, 256) || !shape2(w_gate, 256) || !shape2(w_up, 256) ||
      !shape2(w_down, 256))
    return -1;

  static int x_local[512][256];
  static int wq_local[256][256];
  static int wk_local[256][256];
  static int wv_local[256][256];
  static int gate_local[256][256];
  static int up_local[256][256];
  static int down_local[256][256];
  static int expected[512][256];
  for (int row = 0; row < 512; ++row)
    for (int column = 0; column < 256; ++column) {
      x_local[row][column] = load2(x, row, column);
      expected[row][column] = -123456789;
    }
  for (int row = 0; row < 256; ++row)
    for (int column = 0; column < 256; ++column) {
      wq_local[row][column] = load2(wq, row, column);
      wk_local[row][column] = load2(wk, row, column);
      wv_local[row][column] = load2(wv, row, column);
      gate_local[row][column] = load2(w_gate, row, column);
      up_local[row][column] = load2(w_up, row, column);
      down_local[row][column] = load2(w_down, row, column);
    }

  llama_func(seq_len, x_local, wq_local, wk_local, wv_local, gate_local,
             up_local, down_local, expected);

  if (std::getenv("ORBIT_NUMERIC_NEGATIVE_CONTROL"))
    store2(output, 0, 0, load2(output, 0, 0) + 1);
  int64_t mismatches = 0;
  int64_t actualNonzero = 0;
  int64_t expectedNonzero = 0;
  for (int row = 0; row < 512; ++row)
    for (int column = 0; column < 256; ++column) {
      const int32_t actual = load2(output, row, column);
      mismatches += actual != expected[row][column];
      if (row < seq_len) {
        actualNonzero += actual != 0;
        expectedNonzero += expected[row][column] != 0;
      }
    }
  std::fprintf(stderr, "ORBIT_NUMERIC_RESULT mismatches=%lld comparisons=131072 actual_nonzero=%lld expected_nonzero=%lld\n", static_cast<long long>(mismatches), static_cast<long long>(actualNonzero), static_cast<long long>(expectedNonzero));
  return mismatches * 1000000000000LL + actualNonzero * 1000000LL +
         expectedNonzero;
}
