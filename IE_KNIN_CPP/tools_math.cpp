//
// Created by lisboa on 18/04/2015.
//

#include "tools_math.h"

long double pow_d(long double x,unsigned long exp)
{
    unsigned long i;
    long double values;

    for(i = 0,values = 1; i < exp ; i++)
        values *= x;

    return values;
}

unsigned long fatorial(unsigned long n,unsigned long l = 0)
{
    unsigned long i = 0;
    unsigned long y = 1;

    if (n == 0 || n == 1)
        return 1;

    else
    {
        while (i < ((l == 0) ? n : l))
        {
            y *= n - i;
            i += 1;
        }
    }
    return y;
}

unsigned long combinatoria(unsigned long n,unsigned long k)
{
    unsigned long x;
    unsigned long y;

    if(n<k)
        return 0;

    else if(n == k || ! k)
        return 1;

    else if((n-k) == 1 || k == 1)
        return n;

    else
    {
        x = n - k;
        y =  fatorial(n, x);
        y /= fatorial(n - k);
    }

    return y;
}

long double deftype(long double x,long double value,macros_operator Operator) {

    switch(Operator) {
        case SUM:
            x += value;
            break;
        case SUB:
            x -= value;
            break;
        case MUL:
            x *= value;
            break;
        case DIV:
            if(value != 0)
                x/=value;
        default:
            break;
    }
    return x;
}