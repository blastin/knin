//
// Created by jeff on 04/04/15.
//

#include "pdy.h"
#include <stdlib.h>

void pdy_add(struct Pdy_ * pdy,double value)
{
    if(pdy) {
        if ((pdy->begin) < pdy->size) {
            pdy->Y[pdy->begin] = value;
            pdy->Y[pdy->begin + 1] = '\0';
            pdy->begin++;
        }
        else
        {
            pdy->Y = (double*)realloc(pdy->Y,(2*(pdy->begin+1))*sizeof(double));
        }
    }
}

double pdy_get(struct Pdy_ * pdy,unsigned long indice)
{
    if(pdy) {
        if (pdy->Y[indice]) {
            return pdy->Y[indice];
        }
    }
    return 0;
}