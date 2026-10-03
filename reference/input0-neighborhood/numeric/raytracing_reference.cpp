#include "Evaluation/Raytracing/raytracing_func.cpp"
#include "input0_reference_runtime.h"
static void invokeIndependentReference() {
  if (numericProgram != 5 || numericArgumentCount != 45) std::abort();
  raytracing_func(numericScalar, buffer1(1), buffer1(2), buffer1(3), buffer1(4),
    buffer1(5), buffer1(6), buffer1(7), buffer1(8), buffer1(9), buffer1(10),
    buffer1(11), buffer1(12), buffer1(13), buffer1(14), buffer1(15), buffer1(16),
    buffer1(17), buffer1(18), buffer1(19), buffer2<8>(20), buffer1(21), buffer1(22),
    buffer1(23), buffer1(24), buffer1(25), buffer1(26), buffer1(27), buffer1(28),
    buffer1(29), buffer1(30), buffer1(31), buffer1(32), buffer1(33), buffer1(34),
    buffer1(35), buffer1(36), buffer1(37), buffer1(38), buffer1(39), buffer1(40),
    buffer1(41), buffer1(42), buffer1(43), buffer1(44), buffer1(45));
}
