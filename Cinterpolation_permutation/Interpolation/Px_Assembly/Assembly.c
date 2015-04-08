//
// Created by jeff on 08/04/15.
//

#include <stddef.h>
#include <stdlib.h>
#include "Assembly.h"
#include "./../../Permutation/permutation.h"
#include "./../../math/combinatoria.h"
#include <stdio.h>
static void assembly_mount(double * degrees, double * X_mod,double coefficient,unsigned long N);

static double * X_modsignal(double * X,unsigned long size);

double  * assembly_px(double * X, double * coefficients,unsigned long size)
{

    unsigned long i,j;
    double * X_mod  = NULL;
    double * degrees = NULL;

    degrees = (double*)malloc((size+1)*sizeof(double));
    degrees[0] = coefficients[0];
    X_mod = X_modsignal(X,size); // X_mod = alfa*X = (-a,-b,-c,-d,...,-N)

    printf("X_mod[%lu] = [",size);
    for(i = 0; i < size; i++)
    {
        printf("%lf%c",X_mod[i],((i+1) < size) ? ',' : ']');
    }
    putchar('\n');

    for(i = 1;i < size; i++)
    {
        if(coefficients[i] != 0)
            assembly_mount(degrees,X_mod,coefficients[i],i);
        printf("Px[%lu] = [" ,(size));
        for(j = 0; j < size; j++)
        {
           printf("%lf%c",degrees[j],((j+1) < size) ? ',' : ']');
        }
        putchar('\n');
        printf("---------------------------\n");
    }
    return degrees;
}

static double *  X_modsignal(double * X,unsigned long size)
{
    unsigned long i;
    double * X_mod;

    X_mod = (double*)malloc((size+1)*sizeof(double));

    for(i = 0 ; i < size ; i++)
    {
        X_mod[i]  = X[i]*(-1);
    }
    X_mod[i] = '\0';

    return X_mod;
}

static void assembly_mount(double * degrees, double * X_mod,double coefficient,unsigned long N)
{
    unsigned long i,j, z;
    unsigned long size;

    double * vector_permutation = NULL;
    double * vector_parcial = NULL;
    double soma;

    vector_parcial = (double*)malloc((N+1)*sizeof(double));


    for (i = 1; i <= N; i++) {
        vector_permutation = permutation(X_mod,N,i,'*');
        size = combinatoria(N,i);
        for(j = 0,soma = 0; j < size; j++) {
            soma += vector_permutation[j];
        }
        degrees[N - i] += (coefficient*soma*1.0);
        vector_parcial[N - i] = coefficient*soma*1.0;
        printf("N= %lu, K = %lu, vector_perm[%lu] = [",N,i,size);
        for(z = 0; z < size; z++)
        {
            printf("%lf%c",vector_permutation[z],((z +1) < size) ? ',' : ']');
        }
        putchar('\n');
        printf("Parcial[%lu] = [",N);
        for(z = 0; z < N; z++)
        {
            printf("%lf%c",vector_parcial[z],((z +1) < N) ? ',' : ']');
        }
        putchar('\n');

    }
    degrees[N] += coefficient;
}