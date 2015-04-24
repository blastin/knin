//
// Created by jeff on 21/04/15.
//

#ifndef CINTERPOLATION_PERMUTATION_POINT_H
#define CINTERPOLATION_PERMUTATION_POINT_H
#include <stdbool.h>
struct Point
{
    long double * X;
    long double * Y;
    unsigned long size;
};
#define SIZE_INIT 20 + 1
extern bool double_search(long double* X,unsigned long size,long double Xnew);
extern void sort_point(long double * X,long double * Y,unsigned long size);
#endif //CINTERPOLATION_PERMUTATION_POINT_H
