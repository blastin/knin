//
// Created by jeff on 21/04/15.
//

#ifndef CINTERPOLATION_PERMUTATION_FPX_H
#define CINTERPOLATION_PERMUTATION_FPX_H
extern long double px_simplificada(long double*degrees,unsigned long size,long double x);
extern void px_sfuncao(long double*degrees,unsigned long size,FILE * outfile);
extern void px_cfuncao(long double* coefficients,long double* X,unsigned long size,FILE* outfile);
extern void print_objects(const char* Name,long double* vector,unsigned long size,FILE* outfile);
#endif //CINTERPOLATION_PERMUTATION_FPX_H
