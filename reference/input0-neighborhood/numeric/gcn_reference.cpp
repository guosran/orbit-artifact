#include "Evaluation/GCN/gcn_func.cpp"
#include "input0_reference_runtime.h"
static void invokeIndependentReference() {
  if (numericProgram != 1 || numericArgumentCount != 14) std::abort();
  gcn_func(numericScalar, buffer2<256>(1), buffer2<256>(2), buffer2<256>(3),
           buffer2<256>(4), buffer2<16>(5), buffer2<16>(6), buffer2<16>(7),
           buffer2<16>(8), buffer2<256>(9), buffer3<256,256>(10),
           buffer3<256,16>(11), buffer3<256,16>(12), buffer3<256,16>(13), buffer1(14));
}
