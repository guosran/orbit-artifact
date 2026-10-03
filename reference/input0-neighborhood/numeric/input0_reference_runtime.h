#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <limits>
#include <vector>

struct UnrankedBuffer { int64_t rank; void *descriptor; };
struct DescriptorPrefix { int32_t *allocated; int32_t *aligned; int64_t offset; };
struct NumericBuffer {
  int32_t *actual = nullptr;
  std::vector<int64_t> shape;
  std::vector<int32_t> expected;
};
static NumericBuffer numericBuffers[48];
static int64_t numericProgram = 0, numericScalar = 0;
static unsigned numericArgumentCount = 0;
static void invokeIndependentReference();

static int32_t fixtureValue(int64_t tag, int64_t argument,
                            int64_t row, int64_t column, int64_t linear) {
  if (tag == 1) {
    if (argument <= 4) return row == column || column == (row + argument) % 5;
    if (argument == 5) return 64 + static_cast<int32_t>((row * 17 + column * 11) % 31);
    if (argument <= 8) return row == column ? 1024 : 0;
  } else if (tag == 2) {
    if (argument <= 3) return static_cast<int32_t>((row * 17 + column * 13 + argument * 41) % 256);
  } else if (tag == 3) {
    if (argument <= 2) return static_cast<int32_t>((row * 37 + column * 19 + argument * 11) % 401) - 200;
    if (argument == 3 || argument == 5) return row == column ? 1024 : 0;
  } else if (tag == 4) {
    if (argument == 1) return row == column ? 1024 : 32;
    if (argument == 2) return 1024 * static_cast<int32_t>(linear + 1);
  } else if (tag == 5) {
    if (argument == 1) return static_cast<int32_t>(linear - 4) * 64;
    if (argument == 2) return static_cast<int32_t>(linear % 3) * 32;
    if (argument == 3) return 512 + static_cast<int32_t>(linear) * 64;
    if (argument == 4) return 64;
    if (argument <= 7) return static_cast<int32_t>((linear * 31 + argument * 13) % 256);
    if (argument == 8) return static_cast<int32_t>(linear - 2) * 96;
    if (argument == 9) return 96;
    if (argument == 10) return 128 + static_cast<int32_t>(linear) * 64;
  }
  return 0;
}

extern "C" void _mlir_ciface_orbit_numeric_initialize(
    int64_t tag, int64_t argument, UnrankedBuffer *unranked) {
  if (!unranked || tag < 1 || tag > 5 || argument < 1 || argument >= 48 ||
      unranked->rank < 1 || unranked->rank > 3) std::abort();
  auto *descriptor = static_cast<DescriptorPrefix *>(unranked->descriptor);
  auto *sizes = reinterpret_cast<int64_t *>(descriptor + 1);
  auto *strides = sizes + unranked->rank;
  int64_t elements = 1;
  for (int64_t dimension = unranked->rank - 1; dimension >= 0; --dimension) {
    if (sizes[dimension] <= 0 || strides[dimension] != elements ||
        elements > std::numeric_limits<int32_t>::max() / sizes[dimension]) std::abort();
    elements *= sizes[dimension];
  }
  NumericBuffer &buffer = numericBuffers[argument];
  buffer.actual = descriptor->aligned + descriptor->offset;
  buffer.shape.assign(sizes, sizes + unranked->rank);
  numericArgumentCount = std::max(numericArgumentCount, static_cast<unsigned>(argument));
  for (int64_t linear = 0; linear < elements; ++linear) {
    int64_t row = unranked->rank == 1 ? linear : linear / sizes[unranked->rank - 1];
    int64_t column = unranked->rank == 1 ? 0 : linear % sizes[unranked->rank - 1];
    buffer.actual[linear] = fixtureValue(tag, argument, row, column, linear);
  }
  buffer.expected.assign(buffer.actual, buffer.actual + elements);
}

extern "C" void _mlir_ciface_orbit_numeric_snapshot(int64_t tag, int64_t scalar) {
  numericProgram = tag;
  numericScalar = scalar;
  invokeIndependentReference();
}

extern "C" int64_t _mlir_ciface_orbit_numeric_check(int64_t tag) {
  if (tag != numericProgram) std::abort();
  if (std::getenv("ORBIT_NUMERIC_NEGATIVE_CONTROL"))
    numericBuffers[numericArgumentCount].actual[0] ^= 1;
  int64_t mismatches = 0, comparisons = 0, actualNonzero = 0, expectedNonzero = 0;
  for (unsigned argument = 1; argument <= numericArgumentCount; ++argument) {
    NumericBuffer &buffer = numericBuffers[argument];
    if (!buffer.actual || buffer.expected.empty()) std::abort();
    for (size_t element = 0; element < buffer.expected.size(); ++element) {
      if (buffer.actual[element] != buffer.expected[element] && mismatches < 16)
        std::fprintf(stderr, "ORBIT_NUMERIC_MISMATCH argument=%u element=%zu actual=%d expected=%d\n",
                     argument, element, buffer.actual[element], buffer.expected[element]);
      mismatches += buffer.actual[element] != buffer.expected[element];
      ++comparisons;
      actualNonzero += buffer.actual[element] != 0;
      expectedNonzero += buffer.expected[element] != 0;
    }
  }
  std::fprintf(stderr, "ORBIT_NUMERIC_RESULT mismatches=%lld comparisons=%lld actual_nonzero=%lld expected_nonzero=%lld\n",
               static_cast<long long>(mismatches), static_cast<long long>(comparisons),
               static_cast<long long>(actualNonzero), static_cast<long long>(expectedNonzero));
  return mismatches;
}

static int *buffer1(unsigned index) { return numericBuffers[index].expected.data(); }
template <unsigned N> static int (*buffer2(unsigned index))[N] {
  return reinterpret_cast<int (*)[N]>(buffer1(index));
}
template <unsigned M, unsigned N> static int (*buffer3(unsigned index))[M][N] {
  return reinterpret_cast<int (*)[M][N]>(buffer1(index));
}
