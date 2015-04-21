//
// Created by lisboa on 19/04/2015.
//

#include <fstream>
#include "fpx.h"
#include "tools_math.h"

long double px_simplificada(std::vector<long double> degrees,long double x)
{
    long double y = 0.0;
    unsigned long i = 0;
    for (auto objects : degrees) {
        y += objects * pow_d(x, i);
        i++;
    }
    return y;
}

void px_sfuncao(std::vector<long double> degrees,std::ofstream& outfile)
{
    unsigned long size;
    unsigned long i;

    size = degrees.size();
    outfile << "Função Simplificada P(x)~ ";
    if(degrees[size-1] != 0)
        outfile << degrees[size-1] << "*x^" << size-1;
    for(i = size-2 ; i > 0 ; i--)
    {
        if(degrees[i] != 0)
        {
            outfile <<  ((degrees[i] < 0) ? " - " : " + ") << ((degrees[i] < 0) ? -degrees[i] : degrees[i]);
            if(i != 1)
                outfile << "*x^" << i;
            else
                outfile << "*x";
        }
    }
    if(degrees[i] != 0)
        outfile <<  ((degrees[i] < 0) ? " - " : " + ") << ((degrees[i] < 0) ? -degrees[i] : degrees[i]) << "\n";
    else
        outfile << "\n";
}

void px_cfuncao(std::vector<long double> coefficients, std::vector<long double> X,std::ofstream& outfile)
{
    outfile << "Função normal P(x) ~ " << coefficients[0];
    for(unsigned long i = 1 ; i < coefficients.size() ; i++)
    {
        if(coefficients[i])
        {
            if(coefficients[i] < 0)
                outfile << " - " << -coefficients[i];
            else
                outfile << " + " << coefficients[i];

            for(unsigned long j = 0 ; j < i ; j++)
            {
                if(! X[j])
                    outfile << "*x";
                else if(X[j] < 0)
                    outfile << "*(x + " << -X[j] << ")";
                else
                    outfile << "*(x - " <<  X[j] << ")";
            }
        }
    }
    outfile << "\n";
}

void print_objects(const char* Name,std::vector<long double> vector,std::ofstream& outfile)
{
    unsigned long i;
    unsigned long size;

    size = vector.size();
    i = 0;
    outfile << Name << "[" << size << "] = [";
    for(auto objects : vector)
    {
        outfile << objects;
        if(++i < size )
            outfile << ",";
        else
            outfile << "]" << "\n";
    }

}