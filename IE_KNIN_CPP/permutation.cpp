//
// Created by lisboa on 18/04/2015.
//

#include "permutation.h"
#define W_INIT (-1)


std::vector<long double> permutation(std::vector<long double> U,const long N,const unsigned long K,macros_operator Operator)
{
    // Unsigned
    unsigned long CNK;
    unsigned long cnk;
    unsigned long indice;

    // Signed
    long n;
    long k;
    long uindice;
    long nindice;
    long windice,windice_backup;
    long j; // iterações

    // vector
    std::vector<long double>v;
    std::vector<long> w;

    //inicializações
    j = k = (K-1);
    windice_backup = W_INIT;
    CNK = combinatoria(N,K);
    if(Operator == MUL || Operator == DIV)
        v.assign(CNK,1.0);
    else
        v.assign(CNK,0);
    w.assign(CNK,W_INIT);

    while(j >= 0)
    {
        uindice = 0;
        nindice = 2;
        indice = 0;

        do {
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
            cnk = combinatoria(n,k);

            for (unsigned long z = 0; z < cnk; z++,indice++,((!j) ? uindice++ : 1))
            {
                v[indice] = deftype(v[indice], U[uindice], Operator);
                w[indice] = uindice;
            }
        }while(indice < CNK);
        j--;
        k = j;
    }
    return (v);
}


