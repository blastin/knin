//
// Created by jeff on 04/04/15.
//

#ifndef CINTERPOLATION_PERMUTATION_INVERT_ARRAY_H
#define CINTERPOLATION_PERMUTATION_INVERT_ARRAY_H

void Invertarray_double(double * Ptr);
void Invertarray_int(int * Ptr);
void Invertarray_long(long * Ptr);

#define Invert_array(type) void Invertarray_##type(type * Ptr)

#endif //CINTERPOLATION_PERMUTATION_INVERT_ARRAY_H
