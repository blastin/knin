//
// Created by lisboa on 19/04/2015.
//

#include "interpolation.h"

struct Pdy
{
    std::vector<long double> Y;
    unsigned long size;
};

std::vector<long double> interpolation_mount(struct Point* Pares)
{

    struct Pdy *pdy;

    unsigned long N;
    unsigned long i, j;

    long double temp1;
    long double temp2;

    std::vector<long double> coefficients;

    N = Pares->X.size();
    pdy = new struct Pdy[N];
    pdy[0].Y.reserve(Pares->Y.size());
    pdy[0].Y = Pares->Y;
    pdy[0].size = Pares->Y.size();

    for (i = 1, j = N - 1; i < N; i++, j--)
    {
        pdy[i].Y.reserve(j + 1);
        pdy[i].size = j;
    }

    for (i = 1; i < N; i++)
    {
        for (j = 0; j < pdy[i].size; j++)
        {
            /*
            Formula geral :
            P(i)->Y(j) = ( P(i-1)->Y(j+1) - P(i-1)->Y(j)) / ( X(i+j) - X(j) )
            */
            temp1 = pdy[i - 1].Y.at(j + 1) - pdy[i - 1].Y.at(j);
            temp2 = Pares->X.at(i + j) - Pares->X.at(j);
            pdy[i].Y.push_back(temp1 / temp2);
        }
        coefficients.push_back(pdy[i-1].Y[0]);
    }
    coefficients.push_back(pdy[i-1].Y[0]);
    return coefficients;
}