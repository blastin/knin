//
// Created by jeff on 21/04/15.
//

#ifndef CINTERPOLATION_PERMUTATION_FOREACH_H
#define CINTERPOLATION_PERMUTATION_FOREACH_H

#define IE_I(objects) _i ## objects
#define IE_SHORT(objects) ie_ib ## objects

#define foreach(_OBJECTS,_POINTER,_SIZE)\
unsigned long IE_I(_OBJECTS) = 0;\
for(_OBJECTS = _POINTER[IE_I(_OBJECTS)]; IE_I(_OBJECTS)++ < _SIZE;_OBJECTS = _POINTER[IE_I(_OBJECTS)])

#define foreach_invert(_OBJECTS,_POINTER,_SIZE)\
unsigned long IE_I(_OBJECTS) = _SIZE - 1;\
short IE_SHORT(_OBJECTS) = 1;\
for(_OBJECTS = _POINTER[IE_I(_OBJECTS)];IE_I(_OBJECTS) > 0 ? IE_I(_OBJECTS)-- : IE_SHORT(_OBJECTS)-- ;_OBJECTS = _POINTER[IE_I(_OBJECTS)])

#endif //CINTERPOLATION_PERMUTATION_FOREACH_H