// LU decomposition benchmark for AMOEBA evaluation.
//
// Reference:
// - Streaming-Bench, commit 333782f78d5475c8b33b11ff2b9ba9d75c93ca49:
//   lu/application/lu.cpp and lu/{init,decompose,solver0,solver1,invert,
//   determinant}.
//
// The original Streaming-Bench LU code uses LUP decomposition with pivoting.
// This affine-friendly proxy instead uses no-pivot Doolittle factorization
// with Q10 fixed-point arithmetic and a static matrix bound. Benchmark inputs
// must be small, strictly diagonally dominant matrices, which guarantees
// nonzero pivots without row permutations and keeps intermediate products in
// signed 32-bit range. Removing pivot search makes the loop bounds affine while
// preserving the defining recursive L/U data dependences.
//
// All matrix, vector, inverse, solution, and determinant values use Q10.
// Products are requantized to Q10 after multiplication.
//
// Expected task count after affine-to-taskflow: 9 top-level loop nests.

#define MAX_MATRIX 100
#define FIXED_SCALE 1024

void lu_func(int matrix_size, const int input[MAX_MATRIX][MAX_MATRIX],
             const int rhs[MAX_MATRIX],
             int working_matrix[MAX_MATRIX][MAX_MATRIX],
             int lower[MAX_MATRIX][MAX_MATRIX],
             int upper[MAX_MATRIX][MAX_MATRIX],
             int forward_solution[MAX_MATRIX], int solution[MAX_MATRIX],
             int inverse[MAX_MATRIX][MAX_MATRIX], int determinant_out[1]) {
  // Stage outputs are caller-provided scratch buffers, matching the GCN and
  // Harris benchmark style. This keeps the generated affine IR from carrying
  // large function-local memref.alloca objects.
  //
  // The caller zero-initializes all scratch buffers before invoking this
  // function; predicated fixed-bound loops may read inactive entries before
  // masking them.

  // Task 0: Copy the input matrix into the working matrix.
  for (int row = 0; row < matrix_size; ++row) {
    for (int col = 0; col < matrix_size; ++col) {
      working_matrix[row][col] = input[row][col];
    }
  }

  // Task 1: Initialize L/U storage.
  for (int row = 0; row < matrix_size; ++row) {
    for (int col = 0; col < matrix_size; ++col) {
      lower[row][col] = row == col ? FIXED_SCALE : 0;
      upper[row][col] = 0;
      inverse[row][col] = row == col ? FIXED_SCALE : 0;
    }
  }

  // Task 2: Compact no-pivot Doolittle factorization.
  //
  // `working_matrix` stores unit-diagonal L below the diagonal and U on/above
  // it. Row-major order makes every L/U value available before it is consumed.
  //
  // The benchmark input contract guarantees every diagonal pivot is nonzero.
  for (int row = 0; row < matrix_size; ++row) {
    for (int col = 0; col < matrix_size; ++col) {
      for (int red = 0; red < matrix_size; ++red) {
        int before_row = red < row ? 1 : 0;
        int before_col = red < col ? 1 : 0;
        int active = before_row * before_col;
        int value = working_matrix[row][col];
        int product = working_matrix[row][red] * working_matrix[red][col];
        working_matrix[row][col] = value - active * (product / FIXED_SCALE);
      }
      int below_diagonal = row > col ? 1 : 0;
      int pivot = working_matrix[col][col];
      int divisor =
          FIXED_SCALE + below_diagonal * (pivot - FIXED_SCALE);
      working_matrix[row][col] =
          working_matrix[row][col] * FIXED_SCALE / divisor;
    }
  }

  // Task 3: Materialize separate unit-diagonal L and upper-triangular U.
  for (int row = 0; row < matrix_size; ++row) {
    for (int col = 0; col < matrix_size; ++col) {
      int below_diagonal = row > col ? 1 : 0;
      int on_diagonal = row == col ? 1 : 0;
      int on_or_above_diagonal = 1 - below_diagonal;
      int compact_value = working_matrix[row][col];
      lower[row][col] = below_diagonal * compact_value +
                        on_diagonal * FIXED_SCALE;
      upper[row][col] = on_or_above_diagonal * compact_value;
    }
  }

  // Task 4: Forward substitution, L * y = rhs.
  for (int row = 0; row < matrix_size; ++row) {
    forward_solution[row] = rhs[row];
    for (int col = 0; col < matrix_size; ++col) {
      int active = col < row ? 1 : 0;
      int value = forward_solution[row];
      int product = lower[row][col] * forward_solution[col];
      forward_solution[row] = value - active * (product / FIXED_SCALE);
    }
  }

  // Task 5: Backward substitution, U * x = y.
  for (int rev = 0; rev < matrix_size; ++rev) {
    int row = matrix_size - 1 - rev;
    solution[row] = forward_solution[row];
    for (int col = 0; col < matrix_size; ++col) {
      int active = col > row ? 1 : 0;
      int value = solution[row];
      int product = upper[row][col] * solution[col];
      solution[row] = value - active * (product / FIXED_SCALE);
    }
    solution[row] = solution[row] * FIXED_SCALE / upper[row][row];
  }

  // Task 6: Invert L by solving each identity column.
  for (int col = 0; col < matrix_size; ++col) {
    for (int row = 0; row < matrix_size; ++row) {
      inverse[row][col] = row == col ? FIXED_SCALE : 0;
      for (int red = 0; red < matrix_size; ++red) {
        int active = red < row ? 1 : 0;
        int value = inverse[row][col];
        int product = lower[row][red] * inverse[red][col];
        inverse[row][col] = value - active * (product / FIXED_SCALE);
      }
    }
  }

  // Task 7: Apply the U inverse to finish A^-1.
  for (int col = 0; col < matrix_size; ++col) {
    for (int rev = 0; rev < matrix_size; ++rev) {
      int row = matrix_size - 1 - rev;
      for (int red = 0; red < matrix_size; ++red) {
        int active = red > row ? 1 : 0;
        int value = inverse[row][col];
        int product = upper[row][red] * inverse[red][col];
        inverse[row][col] = value - active * (product / FIXED_SCALE);
      }
      inverse[row][col] = inverse[row][col] * FIXED_SCALE / upper[row][row];
    }
  }

  // Task 8: Q10 determinant from the product of U's diagonal.
  determinant_out[0] = FIXED_SCALE;
  for (int idx = 0; idx < matrix_size; ++idx) {
    determinant_out[0] = determinant_out[0] * upper[idx][idx] / FIXED_SCALE;
  }
}
