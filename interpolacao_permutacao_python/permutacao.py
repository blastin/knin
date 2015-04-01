# -*- coding: utf-8 -*-

from math_ import combinatorial
from math_ import type_operator


class Permutation:

    def __init__(self, u):
        """
        :argument u -> array list contendo valores para a combinação conforme Cn,k e operacao.
        :param u:
        """
        self.u = u

    def permutation(self, n_, k_, operator):
        """

        :rtype : object
        :param n_:
        :param k_:
        :return:
        """
        cnk_ = combinatorial(n_, k_)
        v = []
        w = []

        w_init = -1
        j = k_ - 1
        k = k_ - 1

        w_backup = w_init

        if operator == '*' or operator == '/':
            v = cnk_*[1]
        else:
            v = cnk_*[0]
        w = cnk_*[w_init]

        while j >= 0:

            uindice = 0
            nindice = 2
            indice  = 0

            while indice < cnk_:
            #for indice in range(cnk_):
                windice = w[indice]

                if j > 0:
                    if indice > 0:
                        if windice == w_backup:
                            if windice == w_init or (n_ - (uindice + 1)) > j:
                                nindice += 1
                        else:
                            nindice = 2
                    uindice = windice + nindice - 1

                else:
                    nindice = 1
                    k = 1
                    uindice = windice + nindice
                w_backup = windice
                n = n_ - (windice + nindice)
                cnk = combinatorial(n, k)

                for z in range(cnk):
                    v[indice] = type_operator(v[indice], self.u[uindice], operator)
                    w[indice] = uindice
                    indice += 1
                    if not j:
                        uindice += 1
            j -= 1
            k = j
        else:
            return v