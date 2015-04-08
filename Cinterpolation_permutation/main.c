//
// Created by jeff on 04/04/15.
//

#include "main.h"
#include "math/pow.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc,char * argv[])
{
    unsigned long size = X_Y_SIZE_INIT;
    unsigned long i = 0;

    double x,y;
    double *degrees,*coefficients;

    struct Point pares;


    degrees = NULL;
    coefficients = NULL;
    pares.X = (double*)calloc(X_Y_SIZE_INIT,sizeof(double));
    pares.Y = (double*)calloc(X_Y_SIZE_INIT,sizeof(double));

    printf("2^10 = %lf\n",pow_d(3,3));
    while(true)
    {
        if (i == size)
        {
            size += X_Y_SIZE_INIT;
            pares.X = realloc(pares.X, size*sizeof(double));
            pares.Y = realloc(pares.Y, size*sizeof(double));
        }

        printf("Insira os pontos x,y: ");
        if ((scanf("%lf,%lf", &x, &y) != 2)) {
            pares.X[i] = pares.Y[i] = '\0';
            break;
        }
        else {
            pares.X[i] = x;
            pares.Y[i] = y;
            pares.size = i+1;
            i++;
        }
    }

    printf("X[%ld] = [",pares.size);
    for(i = 0; i < pares.size; i++)
        printf("%lf%c",pares.X[i],((i+1) < pares.size) ? ',' : ']');
    putchar('\n');

    coefficients = interpolation_mount(&pares);
    size = pares.size;

    printf("coefficients[%ld] = [",size);
    for(i = 0; i < size; i++)
        printf("%lf%c",coefficients[i],((i+1) < size) ? ',' : ']');
    putchar('\n');

    degrees = assembly_px(pares.X,coefficients,size);

    printf("degrees[%ld] = [",size);
    for(i = 0; i < size; i++)
        printf("%lf%c",degrees[i],((i+1) < size) ? ',' : ']');
    putchar('\n');

    while(true)
    {
        printf("Psx(x) = ");
        if(scanf("%lf",&x) != 1)
            break;
        else
            printf("%lf\n",px_simplificada(degrees,pares.size,x));
    }
    return 0;
}