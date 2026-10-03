#include "Evaluation/Harris/harris_func.cpp"
#include "input0_reference_runtime.h"
static void invokeIndependentReference() {
  if (numericProgram != 2 || numericArgumentCount != 27) std::abort();
  harris_func(numericScalar, buffer2<128>(1), buffer2<128>(2), buffer2<128>(3),
              buffer2<128>(4), buffer2<128>(5), buffer2<128>(6), buffer2<128>(7),
              buffer2<128>(8), buffer2<128>(9), buffer2<128>(10), buffer2<128>(11),
              buffer2<128>(12), buffer2<128>(13), buffer2<128>(14), buffer2<128>(15),
              buffer2<128>(16), buffer2<128>(17), buffer2<128>(18), buffer2<128>(19),
              buffer2<128>(20), buffer2<128>(21), buffer2<128>(22), buffer2<128>(23),
              buffer2<128>(24), buffer2<128>(25), buffer2<128>(26), buffer2<128>(27));
}
