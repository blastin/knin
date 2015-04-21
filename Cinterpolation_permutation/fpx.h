//
// Created by jeff on 21/04/15.
//

#ifndef CINTERPOLATION_PERMUTATION_FPX_H
#define CINTERPOLATION_PERMUTATION_FPX_H
long double px_simplificada(long double*degrees,unsigned long size,long double x);
void px_sfuncao(long double*degrees,unsigned long size,FILE * outfile);
void px_cfuncao(long double* coefficients,long double* X,unsigned long size,FILE* outfile);
void print_objects(char* Name,long double* vector,unsigned long size,FILE* outfile);
#endif //CINTERPOLATION_PERMUTATION_FPX_H