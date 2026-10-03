// Harris corner detection benchmark for AMOEBA evaluation.
//
// Reference:
// - Harris and Stephens, "A Combined Corner and Edge Detector", Alvey
//   Vision Conference, 1988.
//
// This benchmark is not present in the referenced Streaming-Bench commit. It
// models a standard streaming Harris detector: grayscale conversion, Gaussian
// smoothing, Sobel gradients, second-moment tensor construction, tensor
// smoothing, Harris response, thresholding, and non-maximum suppression.
//
// Expected task count after affine-to-taskflow: 24 top-level loop nests.

#define MAX_HEIGHT 256
#define IMAGE_WIDTH 128

void harris_func(
    int image_height, const int image_r[MAX_HEIGHT][IMAGE_WIDTH],
    const int image_g[MAX_HEIGHT][IMAGE_WIDTH],
    const int image_b[MAX_HEIGHT][IMAGE_WIDTH],
    int gray[MAX_HEIGHT][IMAGE_WIDTH],
    int gray_clamped[MAX_HEIGHT][IMAGE_WIDTH],
    int blur_h[MAX_HEIGHT][IMAGE_WIDTH], int blur[MAX_HEIGHT][IMAGE_WIDTH],
    int grad_x[MAX_HEIGHT][IMAGE_WIDTH], int grad_y[MAX_HEIGHT][IMAGE_WIDTH],
    int grad_mag[MAX_HEIGHT][IMAGE_WIDTH], int ixx[MAX_HEIGHT][IMAGE_WIDTH],
    int iyy[MAX_HEIGHT][IMAGE_WIDTH], int ixy[MAX_HEIGHT][IMAGE_WIDTH],
    int ixx_h[MAX_HEIGHT][IMAGE_WIDTH], int iyy_h[MAX_HEIGHT][IMAGE_WIDTH],
    int ixy_h[MAX_HEIGHT][IMAGE_WIDTH], int sxx[MAX_HEIGHT][IMAGE_WIDTH],
    int syy[MAX_HEIGHT][IMAGE_WIDTH], int sxy[MAX_HEIGHT][IMAGE_WIDTH],
    int response_raw[MAX_HEIGHT][IMAGE_WIDTH],
    int response[MAX_HEIGHT][IMAGE_WIDTH],
    int candidate[MAX_HEIGHT][IMAGE_WIDTH],
    int local_max_h[MAX_HEIGHT][IMAGE_WIDTH],
    int local_max[MAX_HEIGHT][IMAGE_WIDTH], int nms[MAX_HEIGHT][IMAGE_WIDTH],
    int strength[MAX_HEIGHT][IMAGE_WIDTH],
    int corner_map[MAX_HEIGHT][IMAGE_WIDTH]) {
  // Stage outputs are caller-provided scratch buffers, matching the GCN
  // benchmark style. Keeping them at the function boundary forces cgeist to
  // materialize each stage as a real memref instead of expanding previous-stage
  // expressions into later kernels.

  // Task 0: RGB to fixed-point grayscale.
  for (int row = 0; row < image_height; ++row) {
    for (int col = 0; col < IMAGE_WIDTH; ++col) {
      gray[row][col] = 30 * image_r[row][col] + 59 * image_g[row][col] +
                       11 * image_b[row][col];
    }
  }

  // Task 1: Clamp grayscale values before filtering.
  for (int row = 0; row < image_height; ++row) {
    for (int col = 0; col < IMAGE_WIDTH; ++col) {
      int value = gray[row][col];
      value = value < 0 ? 0 : value;
      gray_clamped[row][col] = value > 25500 ? 25500 : value;
    }
  }

  // Task 2: Horizontal Gaussian blur, kernel [1 2 1].
  for (int row = 0; row < image_height; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      blur_h[row][col] = gray_clamped[row][col - 1] +
                         2 * gray_clamped[row][col] +
                         gray_clamped[row][col + 1];
    }
  }

  // Task 3: Vertical Gaussian blur.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      blur[row][col] =
          blur_h[row - 1][col] + 2 * blur_h[row][col] + blur_h[row + 1][col];
    }
  }

  // Task 4: Sobel x-gradient.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      grad_x[row][col] = -blur[row - 1][col - 1] + blur[row - 1][col + 1] -
                         2 * blur[row][col - 1] + 2 * blur[row][col + 1] -
                         blur[row + 1][col - 1] + blur[row + 1][col + 1];
    }
  }

  // Task 5: Sobel y-gradient.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      grad_y[row][col] = -blur[row - 1][col - 1] - 2 * blur[row - 1][col] -
                         blur[row - 1][col + 1] + blur[row + 1][col - 1] +
                         2 * blur[row + 1][col] + blur[row + 1][col + 1];
    }
  }

  // Task 6: Gradient magnitude used as an edge-strength side channel.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      int gx = grad_x[row][col];
      int gy = grad_y[row][col];
      gx = gx < 0 ? -gx : gx;
      gy = gy < 0 ? -gy : gy;
      grad_mag[row][col] = gx + gy;
    }
  }

  // Tasks 7-9: Second-moment tensor products.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      ixx[row][col] = grad_x[row][col] * grad_x[row][col];
    }
  }
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      iyy[row][col] = grad_y[row][col] * grad_y[row][col];
    }
  }
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      ixy[row][col] = grad_x[row][col] * grad_y[row][col];
    }
  }

  // Tasks 10-12: Horizontal smoothing of tensor components.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      ixx_h[row][col] = ixx[row][col - 1] + ixx[row][col] + ixx[row][col + 1];
    }
  }
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      iyy_h[row][col] = iyy[row][col - 1] + iyy[row][col] + iyy[row][col + 1];
    }
  }
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      ixy_h[row][col] = ixy[row][col - 1] + ixy[row][col] + ixy[row][col + 1];
    }
  }

  // Tasks 13-15: Vertical smoothing of tensor components.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      sxx[row][col] =
          ixx_h[row - 1][col] + ixx_h[row][col] + ixx_h[row + 1][col];
    }
  }
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      syy[row][col] =
          iyy_h[row - 1][col] + iyy_h[row][col] + iyy_h[row + 1][col];
    }
  }
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      sxy[row][col] =
          ixy_h[row - 1][col] + ixy_h[row][col] + ixy_h[row + 1][col];
    }
  }

  // Task 16: Harris response, R = det(M) - k * trace(M)^2.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      int determinant =
          sxx[row][col] * syy[row][col] - sxy[row][col] * sxy[row][col];
      int tensor_trace = sxx[row][col] + syy[row][col];
      int trace_square = tensor_trace * tensor_trace;
      response_raw[row][col] = determinant - trace_square / 25;
    }
  }

  // Task 17: Clamp negative responses.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      int value = response_raw[row][col];
      response[row][col] = value > 0 ? value : 0;
    }
  }

  // Task 18: Threshold corner candidates.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      candidate[row][col] = response[row][col] > 4096 ? response[row][col] : 0;
    }
  }

  // Task 19: Horizontal local maximum.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      int local = candidate[row][col - 1];
      int center = candidate[row][col];
      int right = candidate[row][col + 1];
      if (center > local) {
        local = center;
      }
      if (right > local) {
        local = right;
      }
      local_max_h[row][col] = local;
    }
  }

  // Task 20: Vertical local maximum.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      int local = local_max_h[row - 1][col];
      int center = local_max_h[row][col];
      int bottom = local_max_h[row + 1][col];
      if (center > local) {
        local = center;
      }
      if (bottom > local) {
        local = bottom;
      }
      local_max[row][col] = local;
    }
  }

  // Task 21: Non-maximum suppression.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      int center = candidate[row][col];
      nms[row][col] = center != 0 && center == local_max[row][col] ? center : 0;
    }
  }

  // Task 22: Combine corner response with gradient magnitude for ranking.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      strength[row][col] = nms[row][col] + grad_mag[row][col] / 16;
    }
  }

  // Task 23: Emit binary corner map.
  for (int row = 1; row < image_height - 1; ++row) {
    for (int col = 1; col < IMAGE_WIDTH - 1; ++col) {
      corner_map[row][col] = strength[row][col] > 4096 ? 1 : 0;
    }
  }
}
