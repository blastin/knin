cmake_minimum_required(VERSION 3.1)
project(Cinterpolation_permutation)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c11" -lm )

set(SOURCE_FILES main.c)
add_executable(Cinterpolation_permutation ${SOURCE_FILES}  main.h main.c math/type_operator.h math/type_operator.c math/macros.h math/fatorial.h math/fatorial.c math/combinatoria.h math/combinatoria.c data_type/macro_data_type.h Permutation/permutation.h Permutation/permutation.c Interpolation/interpolation.h Interpolation/interpolation.c Interpolation/pdy.h Interpolation/pdy.c math/Point.h Interpolation/Px_Assembly/Assembly.h Interpolation/Px_Assembly/Assembly.c Interpolation/Px.h Interpolation/Px.c math/pow.h math/pow.c)