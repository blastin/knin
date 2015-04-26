//
// Created by jeff on 21/04/15.
//

#ifndef CINTERPOLATION_PERMUTATION_FOREACH_H
#define CINTERPOLATION_PERMUTATION_FOREACH_H
#define IE_I(objects) _i ## objects
#define foreach(_OBJECTS,_POINTER,_SIZE)\
unsigned long IE_I(objects);\
for(IE_I(objects) = 0,_OBJECTS = _POINTER[IE_I(objects)]; IE_I(objects)++ < _SIZE;_OBJECTS = _POINTER[IE_I(objects)])
#endif //CINTERPOLATION_PERMUTATION_FOREACH_H