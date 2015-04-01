# -*- coding: utf-8 -*-
class Interpolation:

    def __init__(self, x0, pdy):
        self.x0 = x0
        self.pdy = pdy

    def interpolation(self,):
        """


        :return degrees:
        """
        n = self.x0.__len__()
        px = []
        degrees = []

        # Criar a quantidade de objetos em lista pdy com quantidade de n-1
        for x in range(1,n)[::-1]:
            self.pdy.extend([x * [0]])

        for x in range(1, n):
            for y in range(self.pdy[x].__len__()):
                """
                Formula geral :
                P(i)->Y(j) = ( P(i-1)->Y(j+1) - P(i-1)->Y(j)) / ( X(i+j) - X(j) )
                """
                temp1 = self.pdy[x - 1][y + 1] - self.pdy[x - 1][y]
                temp2 = self.x0[x + y] - self.x0[y]
                self.pdy[x][y] = temp1 / temp2
        else:
            print("X[%d] = " % n),
            print self.x0
            for x in range(n):
                degrees.append(self.pdy[x][0])
            del temp1, temp2, x, y

            return degrees
