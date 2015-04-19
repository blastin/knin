//
// Created by lisboa on 19/04/2015.
//

#include "assembly.h"
#include "permutation.h"

std::vector<long double> assembly_px(std::vector<long double> X,std::vector<long double>coefficients)
{
    unsigned long i;
    unsigned long j;
    unsigned long N;

    std::vector<long double> degrees;
    std::vector<long double> Xmod;
    std::vector<long double> vector_permutation;

    long double sum;

    N = coefficients.size();
    for(auto objects: X)
        Xmod.push_back(objects*(-1.0));
    degrees.assign(N,0);
    degrees[0] = coefficients[0];

    for(i = 1; i < N;i++)
    {
        if(coefficients[i] != 0)
        {
            for(j = 1; j <= i; j++)
            {
                vector_permutation = permutation(Xmod,i,j,MUL);
                sum = 0.0;
                for(auto objects: vector_permutation)
                    sum += objects;
                degrees[i-j] += coefficients[i]*sum;
            }
            degrees[i] += coefficients[i];
        }
    }
    return degrees;
}