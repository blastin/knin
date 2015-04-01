from permutacao import Permutation


class PAssembly:

    def __init__(self, coefficients, vector):
        self.vector = vector
        self.vector_modified = []
        self.coefficients = coefficients
        self.coefficient = None
        self.perm = None
        self.vector_mod()

    def vector_mod(self):
        """
        :rtype : object
        """
        for objects in self.vector:
                self.vector_modified.append(-objects)

    def assembly(self):
        n = self.coefficients.__len__()
        self.coefficient = n * [0]
        self.perm = Permutation(self.vector_modified)
        """
            invertendo o sinal da biblioteca px0

        """
        self.coefficient[0] = self.coefficients[0]
        print("Px inicial = "),
        print self.coefficient
        print("----------------------------")
        for x in range(1, n):
            if not self.coefficients[x]:
                continue
            else:
                self.assembly_mount(self.coefficients[x], x)
            print("Px[%d] = " % (self.coefficient.__len__())),
            print self.coefficient
            print("----------------------------")
        else:
            return self.coefficient

    def assembly_mount(self, coefficient, n):

        """
        :param self:
        :param coefficient:
        :param n:
        """
        vector_permutation = []
        coefficient_parcial = n * [0]
        for k in range(1, n + 1):
            vector_permutation = self.perm.permutation(n, k, '*')
            soma = 0
            for x in range(vector_permutation.__len__()):
                soma += vector_permutation[x]
            self.coefficient[n - k] += (coefficient * soma)
            coefficient_parcial[n - k] = coefficient * soma
            print("n=%d||k=%d||vectorperm[%d] = " % (n, k, vector_permutation.__len__())),
            print vector_permutation
            print ("coefficient_parcial[%d] = " % (coefficient_parcial.__len__())),
            print coefficient_parcial
        else:
            self.coefficient[n] += coefficient