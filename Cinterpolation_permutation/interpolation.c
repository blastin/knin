//
// Created by jeff on 04/04/15.
//


#include "interpolation.h"
#include <stdlib.h>

long double * interpolation_mount(struct Point * Pares)
{
    struct Pdy_ { long double * Y;unsigned long size; }pdy[Pares->size];

    unsigned long N;
    unsigned long i;
    unsigned long j;

    long double temp1;
    long double temp2;

    long double *coefficients;

    N = Pares->size;

    pdy[0].Y = Pares->Y;
    pdy[0].size = N;

    coefficients = (long double*)malloc(N*sizeof(long double));

    for (i = 1, j = N - 1; i < N; i++, j--)
    {
        pdy[i].Y = (long double *) malloc((j+1)*sizeof(long double));
        pdy[i].Y[j] = '\0';
        pdy[i].size = j;
    }

    for (i = 1; i < N; i++)
    {
        for (j = 0; j < pdy[i].size; j++)
        {
            /*
            Formula geral :
            P(i)->Y(j) = ( P(i-1)->Y(j+1) - P(i-1)->Y(j)) / ( X(i+j) - X(j) )
            */
            temp1 = pdy[i - 1].Y[j + 1] - pdy[i - 1].Y[j];
            temp2 = Pares->X[i +j ] - Pares->X[j];
            pdy[i].Y[j] = (temp1 / temp2);
        }
        coefficients[i-1] = pdy[i-1].Y[0];
        free(pdy[i-1].Y);
    }

    coefficients[i-1] = pdy[i-1].Y[0];
    free(pdy[i-1].Y);

    return coefficients;
}