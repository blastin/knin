package sample.IPKnin;

/**
 * Created by lisboa on 03/04/2015.
 */

public class Math_ {

    public final char SUM = '+';
    public final char SUB = '-';
    public final char MULT = '*';
    public final char DIV = '/';

    public int factoriall(int n) {
        return factoriall(n, n);
    }

    public int factoriall(int n, int l) {
        int i = 0;
        int y = 1;
        if (n == 0)
            return 1;
        else {
            while (i < l) {
                y *= n - i;
                i += 1;
            }
        }
        return y;
    }

    public int combinatorial(int n, int k) {
        int x = n - k;
        int y;
        if(n<k || n < 0 || k < 0)
            return 0;
        else if(n ==k)
            return 1;
        else if((n-k)==1)
            return n;
        else {
            y =  factoriall(n, x);
            y /= factoriall(n - k);
        }
        return y;
    }
    public double type_operator(double x,double value,char operator)
    {
        switch(operator) {
            case SUM:
                x += value;
                break;
            case SUB:
                x -= value;
                break;
            case MULT:
                x *= value;
                break;
            case DIV:
                try {
                    x /= value;
                } catch (ArithmeticException except) {
                    System.out.print("Exceção : divisão por zero");
                }
                break;
        }
        return x;
    }
}
