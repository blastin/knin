# -*- coding: utf-8 -*-
from permutacao import Permutation
from interpolacao import Interpolation
from Px import ClassPx

__author__ = 'lisboa'

if __name__ == '__main__':

    u = [1, 3, 5, 7]
    nu_ = u.__len__()
    k_ = 2
    #x0 = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0]
    #pdy = [[3000, 2700, 2500, 2000, 1300, 800]]

    x0 = []
    pdy = [[]]


    operator = '*'

    px = []
    degrees = []

    while True:
        try:
            x, y = input("Insira x,y separados por virgula : ")
            x0.append(x)
            pdy[0].append(y)
        except TypeError:
            break
        finally:
            nx_ = pdy[0].__len__()

    perm = Permutation(u)
    inter = Interpolation(x0, pdy)

    degrees = inter.interpolation()
    v = perm.permutation(nu_, k_, operator)

    print("sai : coeficiente_alfa[%d] = " % (degrees.__len__())),
    print degrees

    #testando permutacao
    for values in v:
        print(values),
    else:
        print

    print("P(x) = "),

    x = px.__len__() - 1
    for objects in px[::-1]:
        if objects:
            print("%c %f*x**%d" % ('+' if objects > 0 else ' ', objects, x)),
        x -= 1
    else:
        print

    px = ClassPx(degrees, x0)

    px.pxgprint()
    px.pxsprint()
    while True:
        try:
            values = input("Insira valor de x: ")
            print("P_geral(%.2f) = %.4f" % (values, px.px_general(values)))
            print("P_aproximada(%.2f) = %.4f" % (values, px.px_simplified(values)))
            print("------------------------------")
        except TypeError:
            print("Fim do programa")
            break