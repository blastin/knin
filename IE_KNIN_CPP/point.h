//
// Created by lisboa on 19/04/2015.
//

#ifndef IE_KNIN_CPP_POINT_H
#define IE_KNIN_CPP_POINT_H

#include <vector>
struct Point
{
     std::vector<long double>X;
     std::vector<long double>Y;
};

bool  search_value_eqX(std::vector<long double> X,long double Xnew);

#endif //IE_KNIN_CPP_POINT_H
