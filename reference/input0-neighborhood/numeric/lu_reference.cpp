#include "Evaluation/LU/lu_func.cpp"
#include "input0_reference_runtime.h"
static void invokeIndependentReference() {
  if (numericProgram != 4 || numericArgumentCount != 9) std::abort();
  lu_func(numericScalar, buffer2<100>(1), buffer1(2), buffer2<100>(3),
          buffer2<100>(4), buffer2<100>(5), buffer1(6), buffer1(7),
          buffer2<100>(8), buffer1(9));
}
