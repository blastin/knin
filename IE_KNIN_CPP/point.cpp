//
// Created by lisboa on 20/04/2015.
//

#include "point.h"

bool  search_value_eqX(std::vector<long double> X,long double Xnew)
{
    for(auto objects : X)
    {
        if(Xnew == objects)
            return true;
    }
    return false;
}