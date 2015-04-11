//
// Created by jeff on 08/04/15.
//

#include "Px.h"
#include <stdio.h>
#include "./../math/pow.h"

double px_simplificada(double * degrees,unsigned long N, double x)
{
    unsigned long i;
    double values;
    for(i = 0 ,values = 0.0; i <= N; i++)
    {
        if(!degrees[i])
            continue;
        //printf("N = %lu, x = %lf , degrees[%lu] = %lf,pow_d(%lf,%lu) = %lf,values = %lf -> values += %lf\n",
        // N,x,i,degrees[i],x,i,pow_d(x,i),values,degrees[i] * pow_d(x,i));
        values += degrees[i] * pow_d(x,i);
    }
    return values;
}