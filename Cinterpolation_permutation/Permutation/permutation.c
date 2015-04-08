//
// Created by jeff on 04/04/15.
//

#include "permutation.h"
#include "./../math/combinatoria.h"
#include "./../math/macros.h"
#include "./../math/type_operator.h"
#include <stdlib.h>

double * permutation(const double * U, const unsigned long N,const unsigned long K,const char operator)
{
    // Constantes
    const short W_INIT = -1;
    //

    // Variáveis unsigned
    unsigned long CNK;
    unsigned long z; // para iteração
    unsigned long n,cnk;
    //

    //variáveis signed
    signed int uindice,indice,nindice;
    signed int windice,windice_backup;
    signed int j,k;
    //

    // Ponteiros double
    double *v = NULL;
    //

    //Ponteiro int
    signed int *w = NULL;
    //

    //inicialização signed e unsigned
    j = k = (K - 1);
    windice_backup = W_INIT;
    CNK = combinatoria(N,K);
    //

    // Alocação de espaço
    v = (double*)malloc(CNK*sizeof(double));
    w = (signed int*)malloc(CNK*sizeof(signed int));

    // Laço para inicialização dos valores para v,w
    for(z = 0; z < CNK ;z++)
    {
        if(operator == MUL || operator == DIV)
            v[z] = 1.0;
        else
            v[z] = 0.0;
        w[z] = W_INIT;
    }

    while (j >= 0) {
        uindice = 0;
        nindice = 2;
        indice = 0;

        while (indice < CNK)
        {
            windice = w[indice];
            if (j > 0)
            {
                if (indice > 0) {
                    if (windice == windice_backup) {
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

            for (z = 0; z < cnk; z++,indice++,((!j) ? uindice++ : 1)) {
                v[indice] = deftype(v[indice], U[uindice], operator);
                w[indice] = uindice;
            }
        }
        j -= 1;
        k = j;
    }
    return v;
}