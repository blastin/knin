cmake_minimum_required(VERSION 3.1)
project(IE_KNIN_CPP)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES main.cpp)
add_executable(IE_KNIN_CPP ${SOURCE_FILES} tools_math.h tools_math.cpp enum.h permutation.h permutation.cpp interpolation.h interpolation.cpp point.h assembly.h assembly.cpp fpx.h fpx.cpp point.cpp)