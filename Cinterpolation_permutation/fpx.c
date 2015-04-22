//
// Created by jeff on 21/04/15.
//

#include <stdio.h>
#include "fpx.h"
#include "tools_math.h"
#include "foreach.h"

long double px_simplificada(long double*degrees,unsigned long size,long double x)
{
    long double y;
    long double objects;
    unsigned long i;

    y = 0;
    i = 0;

    foreach(objects,degrees,size)
    {
        y += objects * pow_d(x, i);
        i++;
    }
    return y;
}

void px_sfuncao(long double*degrees,unsigned long size,FILE * outfile)
{

    unsigned long i;

    fprintf(outfile,"Função Simplificada P(x)~ ");
    if(degrees[size-1] != 0)
        fprintf(outfile,"%Lf*x^%lu",degrees[size-1],size-1);

    for(i = size-2 ; i > 0 ; i--)
    {
        if(degrees[i] != 0)
        {
        fprintf(outfile,"%s%Lf",((degrees[i] < 0) ? " - " : " + "),((degrees[i] < 0) ? -degrees[i] : degrees[i]));
        if(i != 1)
            fprintf(outfile,"*x^%lu",i);
        else
            fprintf(outfile,"*x");
        }
    }
    if(degrees[i] != 0)
        fprintf(outfile,"%s%Lf\n",((degrees[i] < 0) ? " - " : " + "),((degrees[i] < 0) ? -degrees[i] : degrees[i]));
    else
        fprintf(outfile,"\n");
}

void px_cfuncao(long double* coefficients,long double* X,unsigned long size,FILE* outfile)
{
    unsigned long i;
    unsigned long j;
    fprintf(outfile,"Função normal P(x) ~  %Lf",coefficients[0]);
    for(i = 1 ; i <size ; i++)
    {
        if(coefficients[i])
        {
            if(coefficients[i] < 0)
                fprintf(outfile," - %Lf",-coefficients[i]);
            else
                fprintf(outfile," + %Lf",coefficients[i]);
            for(j = 0 ; j < i ; j++)
            {
                if(! X[j])
                    fprintf(outfile,"*x");
                else if(X[j] < 0)
                    fprintf(outfile,"*(x + %Lf)",-X[j]);
                else
                    fprintf(outfile,"*(x - %Lf)",X[j]);
            }
        }
    }
    fprintf(outfile,"\n");
}

void print_objects(char* Name,long double* vector,unsigned long size,FILE* outfile)
{
    long double objects;
    unsigned long i;

    i = 0;
    fprintf(outfile,"%s[%lu] = [",Name,size);

    foreach(objects,vector,size)
    {
        fprintf(outfile,"%Lf",objects);
        if(++i < size)
            fprintf(outfile,"%c",',');
        else
            fprintf(outfile,"]\n");
    }
}