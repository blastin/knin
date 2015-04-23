cmake_minimum_required(VERSION 3.1)
project(Cinterpolation_permutation)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c11")

set(SOURCE_FILES main.c)
add_executable(Cinterpolation_permutation ${SOURCE_FILES} main.c permutation.h permutation.c interpolation.h interpolation.c tools_math.h tools_math.c point.h point.c type_macro.h assembly.h assembly.c fpx.h fpx.c foreach.h gnu_script.h gnu_script.c)