//
// Created by jeff on 22/04/15.
//

#include <stdio.h>
#include <string.h>
#include "gnu_script.h"
#define MAX_BUFFER 1000

static char * prints(long double * degrees,unsigned long size);
void gnuplot_script(long double* X, long double * degrees,unsigned long size,FILE * outfile)
{
    char script[MAX_BUFFER];
    char * function;

    function = prints(degrees,size);
    sprintf(script,"reset\nset grid\nset xrange[%.3Lf:%.3Lf]\nf(x) = %splot f(x) with lines",X[0],X[size-1],function);
    fprintf(outfile,script);
}

static char * prints(long double * degrees,unsigned long size)
{
    unsigned long i;

    char buffer[MAX_BUFFER] = "";
    char trash[100];

    char * return_function;

    if(degrees[size-1] != 0)
    {
        sprintf(trash,"%.3Lf*x**%lu",degrees[size-1],size-1);
        strcat(buffer,trash);
    }
    for(i = size-2 ; i > 0 ; i--)
    {
        if(degrees[i] != 0)
        {
            sprintf(trash,"%s%.3Lf",((degrees[i] < 0) ? " - " : " + "),((degrees[i] < 0) ? -degrees[i] : degrees[i]));
            strcat(buffer,trash);
            if(i != 1)
                sprintf(trash,"*x**%lu",i);
            else
                sprintf(trash,"*x");
            strcat(buffer,trash);
        }
    }
    if(degrees[i] != 0)
        sprintf(trash,"%s%.3Lf\n",((degrees[i] < 0) ? " - " : " + "),((degrees[i] < 0) ? -degrees[i] : degrees[i]));
    else
        sprintf(trash,"\n");
    strcat(buffer,trash);

    return_function = buffer;

    return return_function;
}