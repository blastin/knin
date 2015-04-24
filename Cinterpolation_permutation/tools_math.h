//
// Created by jeff on 21/04/15.
//

#ifndef CINTERPOLATION_PERMUTATION_TOOLS_MATH_H
#define CINTERPOLATION_PERMUTATION_TOOLS_MATH_H

#include "type_macro.h"
extern long double pow_d(long double x,unsigned long exp);
extern long double deftype(long double x,long double value,enum macros_operator operator);
extern unsigned long fatorial(unsigned long n,unsigned long l);
extern unsigned long combinatoria(unsigned long n,unsigned long k);
extern void change(long double * a, long double * b);
#define fatorialn(n) fatorial(n,n);

#endif //CINTERPOLATION_PERMUTATION_TOOLS_MATH_H
