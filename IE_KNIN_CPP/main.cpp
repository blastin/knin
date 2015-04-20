#include <iostream>
#include <stdio.h>
#include <fstream>
#include "interpolation.h"
#include "assembly.h"
#include "fpx.h"
using namespace std;

int main()
{
    Point pares;

    long double x;
    long double y;

    char lixo;

    vector<long double> coefficients;
    vector<long double> degrees;

    ofstream outfile;

    while(true)
    {
        cout << "Insira os pares x,y separados por virgula: ";
        if(! (cin >> x >> lixo >> y))
        {
            cin.clear();
            cin.get();
            break;
        }
        else
        {
            pares.X.push_back(x);
            pares.Y.push_back(y);
        }
    }

    outfile.open("PX.txt");

    print_objects("X",pares.X,outfile);
    print_objects("Y",pares.Y,outfile);

    coefficients = interpolation_mount(&pares);
    print_objects("coefficients",coefficients,outfile);

    degrees = assembly_px(pares.X,coefficients);
    print_objects("degrees",degrees,outfile);

    px_sfuncao(degrees,outfile);
    px_cfuncao(coefficients,pares.X,outfile);
    outfile.close();

    while(true)
    {
        cout << "x: ";
        if(!(cin >> x))
        {
            cin.clear();
            cin.get();
            break;
        }
        else
            cout << "P(" << x << ") = " << px_simplificada(degrees,x) << endl;
    }
    return 0;
}