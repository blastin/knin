//
// Created by jeff on 21/04/15.
//
#include <stdlib.h>
#include "assembly.h"
#include "permutation.h"
#include "foreach.h"
#include "tools_math.h"
long double* assembly_px(long double* X,long double* coefficients,unsigned long size)
{
    unsigned long i;
    unsigned long j;
    unsigned long size_vector;

    long double * degrees;
    long double * Xmod;
    long double * vector_permutation;;

    long double sum;
    long double objects;

    vector_permutation = NULL;
    Xmod = (long double*)calloc(size,sizeof(long double));

    i = 0;
    foreach(objects,X,size)
    {
        Xmod[i] = (objects * (-1.0));
        i++;
    }

    degrees = (long double*)calloc(size,sizeof(long double));
    degrees[0] = coefficients[0];

    for(i = 1; i < size;i++)
    {
        if(coefficients[i] != 0)
        {
            for(j = 1; j <= i; j++)
            {
                vector_permutation = permutation(Xmod,i,j,MUL);
                sum = 0.0;
                size_vector = combinatoria(i,j);
                foreach(objects,vector_permutation,size_vector)
                    sum += objects;

                free(vector_permutation);
                vector_permutation = NULL;

                degrees[i-j] += coefficients[i]*sum;
            }
            degrees[i] += coefficients[i];
        }
    }
    free(Xmod);
    return degrees;
}