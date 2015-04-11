//
// Created by jeff on 04/04/15.
//

#include "type_operator.h"
#include "macros.h"

double deftype(double x, double value, char operator) {

    switch(operator) {
        case SUM:
            x += value;
            break;
        case SUB:
            x -= value;
            break;
        case MUL:
            x *= value;
            break;
        case DIV:
            if(value != 0)
                x/=value;
        default:
            break;
    }
    return x;
}