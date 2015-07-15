package sample.IPKnin;

/**
 * Created by lisboa on 03/04/2015.
 */

public class Pxassembly {

    private double[] vector;
    private double[] coefficients;

    private double[] vector_mod;
    private double[] degrees;
    private Permutation perm;

    public Pxassembly(double[] coefficients, double[] vector) {
        this.coefficients = coefficients;
        this.vector = vector;

        vector_mod = new double[this.vector.length];
        Vector_invert();
        this.perm = new Permutation(this.vector_mod);
    }

    private void Vector_invert() {
        for (int x = 0; x < this.vector.length; x++) {
            vector_mod[x] = -vector[x];
        }
    }

    public double[] assembly() {
        int n = this.coefficients.length;
        this.degrees = new double[n];
        this.degrees[0] = this.coefficients[0];

       /* System.out.print("Px inicial = [");
        for (double objects : this.degrees)
            System.out.print(objects + ",");
        System.out.print("]\n----------------------------\n");
*/
        for (int x = 1; x < n; x++) {
            if (this.coefficients[x] != 0)
                this.assembly_mount(this.coefficients[x], x);
            /*System.out.print("Px["+(this.degrees.length)+"] = [");
            for (double objects : this.degrees) {
                System.out.print(objects+",");
            }
            System.out.print("]\n----------------------------\n");
            */
        }
        return this.degrees;
    }

    private void assembly_mount(double coefficient, int n) {

        double[] vector_permutation;
        //double[] coefficient_parcial = new double[n];

        double soma;

        for(int  k = 1 ; k < (n+1);k++) {
            vector_permutation = this.perm.permutation(n, k, '*');
            soma = 0;

            for (int x = 0; x < vector_permutation.length; x++) {
                soma += vector_permutation[x];
            }

            this.degrees[n - k] += (coefficient * soma);
            //coefficient_parcial[n - k] = coefficient * soma;
            /*
            System.out.print("n="+n+"||k="+k+"||vectorperm["+vector_permutation.length+"]=[");
            for (double objects : vector_permutation) {
                System.out.print(objects+",");
            }
            System.out.print("]\n");

            System.out.print("coefficient_parcial["+coefficient_parcial.length+"] = [");
            for (double objects : coefficient_parcial) {
                System.out.print(objects+",");
            }
            System.out.print("]\n");
            */
        }
        this.degrees[n] += coefficient;
    }
}
