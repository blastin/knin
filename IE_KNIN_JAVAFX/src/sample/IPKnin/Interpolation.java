package sample.IPKnin;

import java.util.ArrayList;

/**
 * Created by lisboa on 03/04/2015.
 */

public class Interpolation {

    ArrayList<Double> X = null;
    ArrayList<Double> Y = null;

    public Interpolation(ArrayList<Double> x, ArrayList<Double> y) {
        this.X = x;
        this.Y = y;
    }

    public double[] mount()
    {
        int N = this.X.size();
        double[] degrees = new double[N];
        double temp1,temp2;

        Pdy[] pdy = new Pdy[N];
        pdy[0] = new Pdy();
        pdy[0].y = this.Y;

        for (int i = 1, j = N - 1; i < N; i++, j--)
        {
            pdy[i] = new Pdy();
            pdy[i].setsize(j);
        }
        for(int i = 1 ; i < N; i++)
            for(int j = 0 ; j < pdy[i].getsize(); j++)
            {
                /*
                Formula geral :
                P(i)->Y(j) = ( P(i-1)->Y(j+1) - P(i-1)->Y(j)) / ( X(i+j) - X(j) )
                */
                temp1 = pdy[i - 1].y.get(j + 1) - pdy[i - 1].y.get(j);
                temp2 = this.X.get(i + j) - this.X.get(j);
                pdy[i].y.add(temp1 / temp2);
            }
        for(int i = 0 ; i < N ; i++)
        {
            degrees[i] = pdy[i].y.get(0);
        }
        return degrees;
    }

}
