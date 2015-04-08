//
// Created by jeff on 08/04/15.
//

#include "pow.h"

double pow_d(double x,unsigned long exp)
{
    unsigned long i;
    double values;
    for(i = 0,values = 1; i < exp ; i++)
        values *= x;
    return values;
}