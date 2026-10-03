// Radar signal-processing benchmark for AMOEBA evaluation.
//
// Reference:
// - Richards, "Fundamentals of Radar Signal Processing", McGraw-Hill, 2005.
// - Rohling, "Radar CFAR Thresholding in Clutter and Multiple Target
//   Situations", IEEE Transactions on Aerospace and Electronic Systems, 1983.
//
// This benchmark is not present in the referenced Streaming-Bench commit. It
// models a compact FMCW radar pipeline: ADC preprocessing, range transform,
// static-clutter removal, Doppler transform, range-Doppler magnitude, CFAR
// thresholding, target detection, and peak refinement.
//
// Expected task count after affine-to-taskflow: 21 top-level loop nests.

#define MAX_CHIRPS 32
#define MAX_RANGE_BINS 256
#define DOPPLER_BINS 16

void radar_func(int range_bins, const int adc_i[MAX_CHIRPS][MAX_RANGE_BINS],
                const int adc_q[MAX_CHIRPS][MAX_RANGE_BINS],
                const int range_twiddle_r[MAX_RANGE_BINS][MAX_RANGE_BINS],
                const int range_twiddle_i[MAX_RANGE_BINS][MAX_RANGE_BINS],
                const int doppler_twiddle_r[DOPPLER_BINS][MAX_CHIRPS],
                const int doppler_twiddle_i[DOPPLER_BINS][MAX_CHIRPS],
                int dc_i[MAX_CHIRPS], int dc_q[MAX_CHIRPS],
                int centered_i[MAX_CHIRPS][MAX_RANGE_BINS],
                int centered_q[MAX_CHIRPS][MAX_RANGE_BINS],
                int windowed_i[MAX_CHIRPS][MAX_RANGE_BINS],
                int windowed_q[MAX_CHIRPS][MAX_RANGE_BINS],
                int range_fft_r[MAX_CHIRPS][MAX_RANGE_BINS],
                int range_fft_i[MAX_CHIRPS][MAX_RANGE_BINS],
                int clutter_r[MAX_RANGE_BINS], int clutter_i[MAX_RANGE_BINS],
                int moving_r[MAX_CHIRPS][MAX_RANGE_BINS],
                int moving_i[MAX_CHIRPS][MAX_RANGE_BINS],
                int doppler_r[DOPPLER_BINS][MAX_RANGE_BINS],
                int doppler_i[DOPPLER_BINS][MAX_RANGE_BINS],
                int magnitude[DOPPLER_BINS][MAX_RANGE_BINS],
                int range_noise[DOPPLER_BINS][MAX_RANGE_BINS],
                int doppler_noise[DOPPLER_BINS][MAX_RANGE_BINS],
                int cfar_noise[DOPPLER_BINS][MAX_RANGE_BINS],
                int threshold[DOPPLER_BINS][MAX_RANGE_BINS],
                int candidate[DOPPLER_BINS][MAX_RANGE_BINS],
                int range_peak_score[DOPPLER_BINS][MAX_RANGE_BINS],
                int peak_score[DOPPLER_BINS][MAX_RANGE_BINS],
                int detection_map[DOPPLER_BINS][MAX_RANGE_BINS],
                int target_score[MAX_RANGE_BINS]) {
  // Stage outputs are caller-provided scratch buffers. Keeping each one named
  // at the function boundary preserves the intended radar pipeline stages in
  // the generated affine IR.

  // Task 0: Estimate per-chirp I-channel DC offset.
  for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
    int sum = 0;
    for (int range = 0; range < range_bins; ++range) {
      sum += adc_i[chirp][range];
    }
    dc_i[chirp] = sum / range_bins;
  }

  // Task 1: Estimate per-chirp Q-channel DC offset.
  for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
    int sum = 0;
    for (int range = 0; range < range_bins; ++range) {
      sum += adc_q[chirp][range];
    }
    dc_q[chirp] = sum / range_bins;
  }

  // Task 2: Remove ADC DC offsets.
  for (int range = 0; range < range_bins; ++range) {
    for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
      centered_i[chirp][range] = adc_i[chirp][range] - dc_i[chirp];
      centered_q[chirp][range] = adc_q[chirp][range] - dc_q[chirp];
    }
  }

  // Task 3: Apply a triangular range window.
  for (int range = 0; range < range_bins; ++range) {
    for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
      int left = range;
      int right = range_bins - 1 - range;
      int weight = (left < right ? left : right) + 1;
      windowed_i[chirp][range] = centered_i[chirp][range] * weight;
      windowed_q[chirp][range] = centered_q[chirp][range] * weight;
    }
  }

  // Task 4: Range transform real component.
  for (int out_range = 0; out_range < range_bins; ++out_range) {
    for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
      int sum = 0;
      for (int in_range = 0; in_range < range_bins; ++in_range) {
        sum +=
            windowed_i[chirp][in_range] * range_twiddle_r[out_range][in_range];
        sum -=
            windowed_q[chirp][in_range] * range_twiddle_i[out_range][in_range];
      }
      range_fft_r[chirp][out_range] = sum;
    }
  }

  // Task 5: Range transform imaginary component.
  for (int out_range = 0; out_range < range_bins; ++out_range) {
    for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
      int sum = 0;
      for (int in_range = 0; in_range < range_bins; ++in_range) {
        sum +=
            windowed_i[chirp][in_range] * range_twiddle_i[out_range][in_range];
        sum +=
            windowed_q[chirp][in_range] * range_twiddle_r[out_range][in_range];
      }
      range_fft_i[chirp][out_range] = sum;
    }
  }

  // Task 6: Static-clutter estimate, real component.
  for (int range = 0; range < range_bins; ++range) {
    int sum = 0;
    for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
      sum += range_fft_r[chirp][range];
    }
    clutter_r[range] = sum / MAX_CHIRPS;
  }

  // Task 7: Static-clutter estimate, imaginary component.
  for (int range = 0; range < range_bins; ++range) {
    int sum = 0;
    for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
      sum += range_fft_i[chirp][range];
    }
    clutter_i[range] = sum / MAX_CHIRPS;
  }

  // Task 8: Static-clutter removal.
  for (int range = 0; range < range_bins; ++range) {
    for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
      moving_r[chirp][range] = range_fft_r[chirp][range] - clutter_r[range];
      moving_i[chirp][range] = range_fft_i[chirp][range] - clutter_i[range];
    }
  }

  // Task 9: Doppler transform real component.
  for (int range = 0; range < range_bins; ++range) {
    for (int doppler = 0; doppler < DOPPLER_BINS; ++doppler) {
      int sum = 0;
      for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
        sum += moving_r[chirp][range] * doppler_twiddle_r[doppler][chirp];
        sum -= moving_i[chirp][range] * doppler_twiddle_i[doppler][chirp];
      }
      doppler_r[doppler][range] = sum;
    }
  }

  // Task 10: Doppler transform imaginary component.
  for (int range = 0; range < range_bins; ++range) {
    for (int doppler = 0; doppler < DOPPLER_BINS; ++doppler) {
      int sum = 0;
      for (int chirp = 0; chirp < MAX_CHIRPS; ++chirp) {
        sum += moving_r[chirp][range] * doppler_twiddle_i[doppler][chirp];
        sum += moving_i[chirp][range] * doppler_twiddle_r[doppler][chirp];
      }
      doppler_i[doppler][range] = sum;
    }
  }

  // Task 11: Range-Doppler magnitude.
  for (int range = 0; range < range_bins; ++range) {
    for (int doppler = 0; doppler < DOPPLER_BINS; ++doppler) {
      int real = doppler_r[doppler][range];
      int imag = doppler_i[doppler][range];
      int real_negative = real < 0;
      int imag_negative = imag < 0;
      int real_abs = real + real_negative * (0 - real - real);
      int imag_abs = imag + imag_negative * (0 - imag - imag);
      magnitude[doppler][range] = real_abs + imag_abs;
    }
  }

  // Task 12: CFAR range-neighborhood noise.
  for (int range = 2; range < range_bins - 2; ++range) {
    for (int doppler = 0; doppler < DOPPLER_BINS; ++doppler) {
      range_noise[doppler][range] =
          magnitude[doppler][range - 2] + magnitude[doppler][range - 1] +
          magnitude[doppler][range + 1] + magnitude[doppler][range + 2];
    }
  }

  // Task 13: CFAR Doppler-neighborhood noise.
  for (int range = 2; range < range_bins - 2; ++range) {
    for (int doppler = 1; doppler < DOPPLER_BINS - 1; ++doppler) {
      doppler_noise[doppler][range] =
          magnitude[doppler - 1][range] + magnitude[doppler + 1][range];
    }
  }

  // Task 14: Combine CFAR noise estimates.
  for (int range = 2; range < range_bins - 2; ++range) {
    for (int doppler = 1; doppler < DOPPLER_BINS - 1; ++doppler) {
      cfar_noise[doppler][range] =
          range_noise[doppler][range] + doppler_noise[doppler][range];
    }
  }

  // Task 15: CFAR threshold.
  for (int range = 2; range < range_bins - 2; ++range) {
    for (int doppler = 1; doppler < DOPPLER_BINS - 1; ++doppler) {
      threshold[doppler][range] = cfar_noise[doppler][range] / 6 * 3;
    }
  }

  // Task 16: Detection candidate mask.
  for (int range = 2; range < range_bins - 2; ++range) {
    for (int doppler = 1; doppler < DOPPLER_BINS - 1; ++doppler) {
      int is_candidate = magnitude[doppler][range] > threshold[doppler][range];
      candidate[doppler][range] = is_candidate;
    }
  }

  // Task 17: Range-local peak refinement.
  for (int range = 2; range < range_bins - 2; ++range) {
    for (int doppler = 1; doppler < DOPPLER_BINS - 1; ++doppler) {
      int center = magnitude[doppler][range];
      int left_peak = center > magnitude[doppler][range - 1];
      int right_peak = center > magnitude[doppler][range + 1];
      int range_peak = left_peak * right_peak;
      range_peak_score[doppler][range] =
          candidate[doppler][range] * range_peak * center;
    }
  }

  // Task 18: Doppler-local peak refinement.
  for (int range = 2; range < range_bins - 2; ++range) {
    for (int doppler = 1; doppler < DOPPLER_BINS - 1; ++doppler) {
      int center = range_peak_score[doppler][range];
      int active = center > 0;
      int lower_peak = center > magnitude[doppler - 1][range];
      int upper_peak = center > magnitude[doppler + 1][range];
      int doppler_peak = active * lower_peak * upper_peak;
      peak_score[doppler][range] = doppler_peak * center;
    }
  }

  // Task 19: Emit range-Doppler detection map.
  for (int range = 2; range < range_bins - 2; ++range) {
    for (int doppler = 1; doppler < DOPPLER_BINS - 1; ++doppler) {
      int detected = peak_score[doppler][range] > 0;
      detection_map[doppler][range] = detected;
    }
  }

  // Task 20: Per-range target score.
  for (int range = 2; range < range_bins - 2; ++range) {
    int sum = 0;
    for (int doppler = 1; doppler < DOPPLER_BINS - 1; ++doppler) {
      sum += peak_score[doppler][range];
    }
    target_score[range] = sum;
  }
}
