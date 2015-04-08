//
// Created by jeff on 04/04/15.
//

#include "fatorial.h"


unsigned long fatorial(unsigned long n,unsigned long l)
{
    unsigned long i = 0;
    unsigned long y = 1;

    if (n == 0)
        return 1;

    else {
        while (i < l) {
            y *= n - i;
            i += 1;
        }
    }
    return y;
}
