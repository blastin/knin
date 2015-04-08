//
// Created by jeff on 04/04/15.
//

#ifndef CINTERPOLATION_PERMUTATION_PDY_H
#define CINTERPOLATION_PERMUTATION_PDY_H

struct Pdy_{
    double * Y;
    unsigned long size;
    unsigned long begin;
}spdy;

void pdy_add(struct Pdy_ * pdy,double value);
double pdy_get(struct Pdy_ * pdy,unsigned long indice);

#define pget pdy_get
#define padd pdy_add


#endif //CINTERPOLATION_PERMUTATION_PDY_H
