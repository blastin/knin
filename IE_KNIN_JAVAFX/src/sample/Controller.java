package sample;

import javafx.event.ActionEvent;
import javafx.event.Event;
import javafx.scene.control.*;

import sample.IPKnin.Interpolation;

import sample.IPKnin.Px;

import java.util.ArrayList;

public class Controller {

    public TextField Xtext;  // valor de x para ser inserido
    public TextField Ytext;  // valor de y para ser inserido
    public TextField Px_return;
    public TextField valueX;

    public Button button1; // button de inserir x e y
    public Button button2; // button para criar pgx e px
    public Button button_Px;

    public TextArea Xfieldtext;
    public TextArea Yfieldtext;

    public TextArea Pgfieldtext; // função pgx saida
    public TextArea Pxfieldtext; // função px saida
    public Button button_graphic1;

    private boolean Px_check = false;
    Px px = null;

    protected ArrayList<Double> X = new ArrayList<>();
    protected ArrayList<Double> Y = new ArrayList<>();
    //ArrayList<Double> X = new ArrayList<Double>(Arrays.asList(0.5, 1.0, 1.5, 2.0, 2.5, 3.0));
    //ArrayList<Double> Y = new ArrayList<Double>(Arrays.asList(3000.0, 2700.0, 2500.0, 2000.0, 1300.0, 800.0));


    public void gerar(ActionEvent actionEvent) {

        double[] degrees;
        double[] Doublex = new double[X.size()];

        for(int x = 0 ; x < X.size(); x++)
        {
            Doublex[x] = X.get(x);
        }

        Interpolation inter = new Interpolation(X,Y);
        degrees = inter.mount();
        px = new Px(degrees,Doublex);
        Px_check = true;
        Pxfieldtext.setText(px.pxsprint());
    }

    private boolean search_value(double value)
    {
        for(double objects : X)
        {
            if(value == objects)
                return true;
        }

        return false;
    }

    public void inserir(ActionEvent actionevent) throws InterruptedException {

        if (Ytext.getLength() > 0 && Ytext.getLength() > 0) {

            if(! search_value(Double.parseDouble(Xtext.getText())))
            {
                X.add(Double.parseDouble(Xtext.getText()));
                Y.add(Double.parseDouble(Ytext.getText()));
                Xfieldtext.appendText(Xtext.getText()+'\n');
                Yfieldtext.appendText(Ytext.getText()+'\n');
            }

            if(X.size() > 1)
            {
                System.out.print("Quantidade de valores de x : " + X.size());

                button2.setDisable(false);
            }
        }
    }

    public void value_for_px(ActionEvent actionEvent) {
        if(Px_check && valueX.getLength() > 0)
        {
            Px_return.setText(Double.toString(px.px_simplified(Double.parseDouble(valueX.getText()))));
        }

    }

    public void xtext(ActionEvent actionEvent) {
    }

    public void ytext(ActionEvent actionEvent) {
    }

    public void Xtextmethod(Event event) {
    }

    public void Ytextmethod(Event event) {
    }

    public void bgraphicpx(ActionEvent actionEvent) {

    }
}
