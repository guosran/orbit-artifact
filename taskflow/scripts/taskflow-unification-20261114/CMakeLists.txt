cmake_minimum_required(VERSION 3.24)
project(OrbitGemmArtifact LANGUAGES C CXX)
# This experiment consumes the public ORBIT library. Its target stays outside
# the compiler repository; configure into a separate build directory.
set(ORBIT_SOURCE_DIR "" CACHE PATH "ORBIT checkout containing public Taskflow")
if(NOT EXISTS "${ORBIT_SOURCE_DIR}/include/Taskflow/ProgramBeamSearch.h")
  message(FATAL_ERROR "Set ORBIT_SOURCE_DIR to the compiler checkout")
endif()
find_package(LLVM REQUIRED CONFIG)
find_package(MLIR REQUIRED CONFIG)
add_subdirectory("${ORBIT_SOURCE_DIR}" "${CMAKE_BINARY_DIR}/orbit" EXCLUDE_FROM_ALL)
add_executable(taskflow-gemm-operator-search gemm-operator-search.cpp)
target_compile_features(taskflow-gemm-operator-search PRIVATE cxx_std_17)
target_include_directories(taskflow-gemm-operator-search PRIVATE
  "${ORBIT_SOURCE_DIR}/include" "${CMAKE_BINARY_DIR}/orbit/include"
  ${LLVM_INCLUDE_DIRS} ${MLIR_INCLUDE_DIRS})
target_link_libraries(taskflow-gemm-operator-search PRIVATE
  MLIRTaskflowStructured LLVMSupport)
