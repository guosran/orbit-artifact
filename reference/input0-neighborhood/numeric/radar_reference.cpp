#include "Evaluation/Radar/radar_func.cpp"
#include "input0_reference_runtime.h"
static void invokeIndependentReference() {
  if (numericProgram != 3 || numericArgumentCount != 30) std::abort();
  radar_func(numericScalar, buffer2<256>(1), buffer2<256>(2), buffer2<256>(3),
             buffer2<256>(4), buffer2<32>(5), buffer2<32>(6), buffer1(7), buffer1(8),
             buffer2<256>(9), buffer2<256>(10), buffer2<256>(11), buffer2<256>(12),
             buffer2<256>(13), buffer2<256>(14), buffer1(15), buffer1(16),
             buffer2<256>(17), buffer2<256>(18), buffer2<256>(19), buffer2<256>(20),
             buffer2<256>(21), buffer2<256>(22), buffer2<256>(23), buffer2<256>(24),
             buffer2<256>(25), buffer2<256>(26), buffer2<256>(27), buffer2<256>(28),
             buffer2<256>(29), buffer1(30));
}
