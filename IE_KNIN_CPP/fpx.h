//
// Created by lisboa on 19/04/2015.
//

#ifndef IE_KNIN_CPP_FPX_H
#define IE_KNIN_CPP_FPX_H
#include <vector>
long double px_simplificada(std::vector<long double> degrees,long double x);
void px_cfuncao(std::vector<long double> coefficients, std::vector<long double> X,std::ofstream& outfile);
void px_sfuncao(std::vector<long double> degrees,std::ofstream& outfile);
void print_objects(const char* Name,std::vector<long double> vector,std::ofstream& outfile);
#endif //IE_KNIN_CPP_FPX_H
