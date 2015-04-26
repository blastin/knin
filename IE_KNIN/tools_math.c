//
// Created by jeff on 21/04/15.
//

#include "tools_math.h"

long double pow_d(long double x,unsigned long exp)
{
    long double base;

    base = x;
    if(!exp)
        return 1;
    else if(x == 0.000000)
        return 0;
    while(--exp)
        x *= base;
    return x;
}

unsigned long fatorial(unsigned long n,unsigned long l)
{
    unsigned long i;
    unsigned long y;

    if (!n)
        return 1;
    else
        for(i = 0,y = 1;i < l;i++)
            y *= n - i;
    return y;
}

unsigned long combinatoria(unsigned long n,unsigned long k)
{
    unsigned long x;
    unsigned long y;

    if( n < k )
        return 0;

    else if(n == k || !k)
        return 1;

    else if((n - k) == 1 || k == 1)
        return n;

    else
    {
        x = n - k;
        y =  fatorial(n, x);
        y /= fatorialn(n - k);
    }
    return y;
}

long double deftype(long double x,long double value,enum macros_operator operator)
{

    switch(operator)
    {
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

void swap(long double * a, long double * b)
{
    long double temp;
    temp = *a;
    *a   = *b;
    *b   = temp;
}