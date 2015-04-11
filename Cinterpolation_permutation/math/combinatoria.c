//
// Created by jeff on 04/04/15.
//

#include "combinatoria.h"
#include "fatorial.h"

unsigned long combinatoria(unsigned long n,unsigned long k)
{
    unsigned long x;
    unsigned long y;

    if(n<k)
        return 0;

    else if(n==k)
        return 1;

    else if((n-k)==1)
        return n;

    else {
        x = n - k;
        y =  fatorial(n, x);
        y /= fatorialn(n - k);
    }
    return y;
}