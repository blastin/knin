package sample.IPKnin;
/**
 * Created by lisboa on 03/04/2015.
 */

public class Px {

    double[] coefficients= null;
    double[] x0 = null;
    double [] degrees = null;

    public Px(double[] coefficients,double[] x0)
    {
        this.coefficients = coefficients;
        this.x0 = x0;

        Pxassembly assembly = new Pxassembly(this.coefficients,this.x0);

        double[] degree_backup = assembly.assembly();
        assembly = null;

        this.degrees = new double[degree_backup.length];

        for(int x = 0 ; x < degree_backup.length ; x++)
        {
            this.degrees[x] = degree_backup[degree_backup.length - (1+x)];
        }
    }

    public String pxsprint()
    {
        String parsers = "P(x) = ";
        int n = this.degrees.length - 1;

        for(double objects : this.degrees)
        {
            parsers = parsers.concat(Double.toString(objects)+"*x**"+Integer.toString(n)+" + ");
            n--;
        }
        return parsers;
    }

    public double px_simplified(double x) {

        double px = 0;
        int n = this.degrees.length - 1;
        for(double objects :this.degrees){
            px += objects * Math.pow(x,n);
            n -= 1;
        }
        return px;
    }
}

