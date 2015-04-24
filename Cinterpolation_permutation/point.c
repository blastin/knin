//
// Created by jeff on 21/04/15.
//
#include "point.h"
#include "foreach.h"
#include "tools_math.h"
bool double_search(long double * X,unsigned long size,long double Xnew)
{
    long double objects;

    foreach(objects,X,size)
    {
        if(Xnew == objects)
            return true;
    }
    return false;
}


void sort_point(long double * X,long double * Y,unsigned long size)
{
    bool check;
    unsigned long i;

    check = true;
    while(check)
    {
        for(i = 0 , check = false ; i < (size-1); i++)
        {
            if(X[i+1] < X[i])
            {
                change(X+i,X+i+1);
                change(Y+i,Y+i+1);
                check = true;
            }
        }
    }
}