//
// Created by jeff on 04/04/15.
//
#include <stdio.h>
#include <stdlib.h>
#include "interpolation.h"
#include "assembly.h"
#include "fpx.h"

int main(int argc,char * argv[])
{
    struct Point pares;

    unsigned long size;
    unsigned long count;

    long double x;
    long double y;

    long double *degrees;
    long double *coefficients;

    FILE * outfile;

    degrees = NULL;
    coefficients = NULL;

    pares.X = (long double*)calloc(SIZE_INIT,sizeof(long double));
    pares.Y = (long double*)calloc(SIZE_INIT,sizeof(long double));
    pares.size = 0;
    size = SIZE_INIT;

    count = 0;
    while(true)
    {
        printf("Pares<%lu> : insira os pares x,y separados por virgula: ",count);
        if(scanf("%Lf,%Lf",&x,&y) != 2)
        {
            if(pares.size >= 2)
            {
                size = pares.size;
                break;
            }else
                printf("\nPontos insuficientes.\n\n");
        }else
        {
            if(! search_value_eqX(pares.X,pares.size,x))
            {
                if(count >= size)
                {
                    size += SIZE_INIT;
                    pares.X = (long double *) realloc(pares.X, size * sizeof(long double));
                    pares.Y = (long double *) realloc(pares.Y, size * sizeof(long double));
                }

                pares.X[count] = x;
                pares.Y[count] = y;
                ++count;
                pares.size = count;

            } else
                printf("\nErrorValue : <%Lf> duplicado\n\n",x);
        }
    }

    outfile = fopen("PX.txt","w");

    print_objects("X",pares.X,size,outfile);
    print_objects("Y",pares.Y,size,outfile);

    coefficients = interpolation_mount(&pares);
    print_objects("coefficients",coefficients,size,outfile);
    px_cfuncao(coefficients,pares.X,size,outfile);

    degrees = assembly_px(pares.X,coefficients,size);
    print_objects("degrees",degrees,size,outfile);
    px_sfuncao(degrees,size,outfile);

    fclose(outfile);

    while(true)
    {
        printf("x= ");
        if(scanf("%Lf",&x) != 1)
            break;
        else
            printf("Ps(x) ~ %Lf\n",px_simplificada(degrees,size,x));
    }

    return 0;
}