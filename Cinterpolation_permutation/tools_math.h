//
// Created by jeff on 21/04/15.
//

#ifndef CINTERPOLATION_PERMUTATION_TOOLS_MATH_H
#define CINTERPOLATION_PERMUTATION_TOOLS_MATH_H
#include "type_macro.h"

long double pow_d(long double x,unsigned long exp);
long double deftype(long double x,long double value,enum macros_operator operator);
unsigned long fatorial(unsigned long n,unsigned long l);
unsigned long combinatoria(unsigned long n,unsigned long k);
#define fatorialn(n) fatorial(n,n);

#endif //CINTERPOLATION_PERMUTATION_TOOLS_MATH_H
