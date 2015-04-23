//
// Created by jeff on 04/04/15.
//

#include "permutation.h"
#include "tools_math.h"
#include <stdlib.h>
#include <string.h>

long double * permutation(long double * U,unsigned long N,unsigned long K,enum macros_operator operator)
{
    //Constant
    const short W_INIT = -1;

    //unsigned
    unsigned long CNK;
    unsigned long cnk;
    unsigned long n;
    unsigned long z;


    //signed
    long uindice;
    long indice;
    long nindice;
    long windice;
    long windice_backup;
    long j;
    long k;


    //Pointer long double
    long double *v = NULL;


    //Point long
    long *w = NULL;

    //inicialization
    j = k = (K - 1);
    windice_backup = W_INIT;
    CNK = combinatoria(N,K);

    //Alloc memory and values
    v = (long double*)malloc(CNK*sizeof(long double));
    w = (long*)malloc(CNK*sizeof(long));

    /*if(operator == MUL || operator == DIV)
        memset(v,1,CNK*sizeof(long double));
    else
        memset(v,0,CNK*sizeof(long double));
    memset(w,W_INIT,CNK*sizeof(long));
*/
    //inicialization 2
    for(z = 0; z < CNK ;z++)
    {
        if(operator == MUL || operator == DIV)
            v[z] = 1.0;
        else
            v[z] = 0.0;
        w[z] = W_INIT;
    }

    while (j >= 0)
    {
        uindice = 0;
        nindice = 2;
        indice = 0;

        while (indice < CNK)
        {
            windice = w[indice];
            if (j > 0)
            {
                if (indice > 0)
                {
                    if (windice == windice_backup)
                    {
                        if (windice == W_INIT || (N - (uindice + 1)) > j)
                            nindice += 1;
                    } else
                        nindice = 2;
                }
                uindice = windice + nindice - 1;
            } else
            {
                nindice = 1;
                k = 1;
                uindice = windice + nindice;
            }

            windice_backup = windice;
            n = N - (windice + nindice);
            cnk = combinatoria(n, k);

            for (z = 0; z < cnk; z++,indice++,((!j) ? uindice++ : 1))
            {
                v[indice] = deftype(v[indice], U[uindice], operator);
                w[indice] = uindice;
            }
        }
        j -= 1;
        k = j;
    }
    return v;
}