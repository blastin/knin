//
// Created by jeff on 08/04/15.
//

#include "length.h"



unsigned long length_d(double * Ptr)
{
    unsigned long length_;
    for(length_ = 0; *(Ptr+length_); length_++)
        ;
    return length_;
}