# -*- coding: utf-8 -*-
from math import pow
from Px_assembly import PAssembly


class ClassPx:

    def __init__(self, coefficients, x0):
        self.coefficients = coefficients
        self.x0 = x0

        self.assembly = None
        self.assembly = PAssembly(coefficients, x0)

        self.coefficients_degrees = self.assembly.assembly()
        del self.assembly

        self.px = []
        print("classe coeficiente_alfa[%d] = " % (self.coefficients.__len__())),
        print self.coefficients

    def px_general(self, x):
        """
        :param x:
        :return:
        """
        object_px = 0.0
        object_x0 = 1.0
        for i in range(self.coefficients.__len__()):
            object_coefficient = self.coefficients[i]
            for y in range(i):
                if not object_x0:
                    continue
                elif not self.x0[y]:
                    object_x0 *= x
                """elif self.x0[y] < 0:
                    object_x0 *= (x - self.x0[y])
                else:
                    object_x0 *= (x - self.x0[y])
                """
                object_x0 *= (x - self.x0[y])
            else:
                object_px += object_coefficient * object_x0
                object_x0 = 1
        return object_px

    def px_simplified(self, x):
        """

        :param x:
        :return:
        """
        px = 0
        degree = self.coefficients_degrees.__len__() - 1
        for objects in self.coefficients_degrees[::-1]:
            px += objects * pow(x, degree)
            degree -= 1
        else:
            return px

    def pxgprint(self):
        """
        Imprime Px de forma extensa

        """
        print("Função normal P(x) ~ %f" % (self.coefficients[0])),
        for i in range(1, self.coefficients.__len__()):
            if self.coefficients[i]:
                if self.coefficients[i] < 0:
                    print("- %.6f" % -self.coefficients[i]),
                else:
                    print("+ %.6f" % self.coefficients[i]),

                for j in range(i):
                    if not self.x0[j]:
                        print("*x"),
                    elif self.x0[j] < 0:
                        print("*(x + %.1f)" % -self.x0[j]),
                    else:
                        print("*(x - %.1f)" % self.x0[j]),
        else:
            print

    def pxsprint(self):
        """
        Imprime Px de forma simplificada. TODO: Ainda não inteiramente funcional já que Px_assembly contém problemas
        """

        print("Função simplificada P(x) = "),
        x = self.coefficients_degrees.__len__() - 1
        for objects in self.coefficients_degrees[::-1]:
            if objects:
                print("%c %f*x**%d" % ('+' if objects > 0 else ' ', objects, x)),
            x -= 1
        else:
            print

