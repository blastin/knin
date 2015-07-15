package sample.IPKnin;

/**
 * Created by lisboa on 03/04/2015.
 */

public class Permutation {
    double[] u;
    Math_ math = new Math_();

    public Permutation(double[] u) {
        this.u = u;
    }

    public double[] permutation(int n_, int k_, char operator) {

        final int cnk_ = math.combinatorial(n_, k_);
        final int w_init = -1;

        int j = k_ - 1;
        int k = k_ - 1;
        int uindice;
        int nindice;
        int indice;
        int windice;
        int w_backup = w_init;
        int n;
        int cnk;

        double[] v = new double[cnk_];
        int[] w = new int[cnk_];

        for (int i = 0; i < cnk_; i++) {
            if (operator == math.MULT || operator == math.DIV) {
                v[i] = 1.0;
            } else
                v[i] = 1.0;
            w[i] = w_init;
        }
        while (j >= 0) {
            uindice = 0;
            nindice = 2;
            indice = 0;

            while (indice < cnk_) {

                windice = w[indice];

                if (j > 0) {
                    if (indice > 0)
                        if (windice == w_backup) {
                            if (windice == w_init || (n_ - (uindice + 1)) > j)
                                nindice += 1;
                        } else
                            nindice = 2;
                    uindice = windice + nindice - 1;

                } else {
                    nindice = 1;
                    k = 1;
                    uindice = windice + nindice;
                }
                w_backup = windice;
                n = n_ - (windice + nindice);
                cnk = math.combinatorial(n, k);

                for (int z = 0; z < cnk; z++) {
                    v[indice] = math.type_operator(v[indice], this.u[uindice], operator);
                    w[indice] = uindice;
                    indice += 1;
                    if (j == 0)
                        uindice += 1;
                }
            }
            j -= 1;
            k = j;

        }
        return v;
    }
}