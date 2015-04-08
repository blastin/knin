//
// Created by jeff on 04/04/15.
//

#include "invert_array.h"
#include "./../data_type/macro_data_type.h"
#include "length.h"

#define for_invert(Ptr,type) {\
 unsigned long indice;\
 for(indice = 0;indice < length_d(Ptr); indice++){\
 Ptr[indice] *= -1;\
 }\
 }

Invert_array(double) {
    for_invert(Ptr, double);
}