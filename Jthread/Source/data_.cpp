
#include "data_.h"

long int length_module(long double* tpp)
{
    long int x;
    
    for(x=0;*tpp++;)
        x++;
    
    return x;
    
}