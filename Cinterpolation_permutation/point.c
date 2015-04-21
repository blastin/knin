//
// Created by jeff on 21/04/15.
//
#include "point.h"
#include "foreach.h"
bool search_value_eqX(long double* X,unsigned long size,long double Xnew)
{
    long double objects;

    foreach(objects,X,size)
    {
        if(Xnew == objects)
            return true;
    }
    return false;
}