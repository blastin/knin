//
// Created by jeff on 04/04/15.
//

#include <stddef.h>
#include "interpolation.h"
#include "pdy.h"
#include <stdlib.h>
#include <stdio.h>

double * interpolation_mount(struct Point * Pares)
{
    unsigned long N;
    unsigned long i,j;

    double temp1,temp2;

    double *coefficients = NULL;

    struct Pdy_ *pdy = NULL;

    if(!(N = Pares->size))
        return NULL;

    pdy = (struct Pdy_*)malloc(N*sizeof(spdy));
    coefficients = (double*)malloc(N*sizeof(double));
    pdy[0].Y = Pares->Y;
    pdy[0].size = N;

    for (i = 1, j = N - 1; i < N; i++, j--) {
        pdy[i].Y = (double *) malloc((j+1)*sizeof(temp1));
        pdy[i].Y[j] = '\0';
        pdy[i].size = j;
    }
    printf("--------------------\n");

    for(i = 1 ; i < N; i++)
        for(j = 0 ; j < pdy[i].size; j++)
        {
            /*
            Formula geral :
            P(i)->Y(j) = ( P(i-1)->Y(j+1) - P(i-1)->Y(j)) / ( X(i+j) - X(j) )
            */
            temp1 = pdy[i-1].Y[j+1] - pdy[i-1].Y[j];
            temp2 = Pares->X[i+j] - Pares->X[j];
            printf("temp = %lf\n",temp1/temp2);
            pdy[i].Y[j] = temp1/temp2;
        }
    for(i = 0 ; i < N ; i++)
        coefficients[i] = pdy[i].Y[0];
    coefficients[i] = '\0';
    printf("--------------------\n");
    return coefficients;
}