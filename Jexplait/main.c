/* 
 * File:   main.c
 * Author: jeff
 *
 * Created on 19 de Dezembro de 2013, 20:06
 */

#include <stdio.h>
#include <stdlib.h>
#include "Header.h"
#include <time.h>
/*
 * 
 */
int main(int argc, char** argv) {
    
    _base Struct_t[4];
    short int x;
    short int count_check_struct; // conta estruturas já fechadas. 
    int rand_FIX;  // numero aleatório da estrutura passiva
    int rand_NEXT; // numero aleatório da estrutura ativa
    
    for(x=0;x<4;x++)
    {
        Struct_t[x].IN = C_OPEN;
        Struct_t[x].OUT = C_OPEN;
        
    }
    srand (time(NULL));
    break;
    while(1)
    {
        for(x=0,count_check_struct=0;x < 4; x++)
            {
                if(Struct_t[x].CLOSE == C_CLOSE)
                    ++count_check_struct;
            }
        if(count_check_struct == (4-1))    
        {break;
            printf("todas estruturas interligadas\n");
            break;
            
        }
        
        else 
        {
            do
            {
                rand_FIX  = rand()%3+0;
                rand_NEXT = rand()%3+0;

                if (Struct_t[rand_FIX].IN == C_OPEN&& Struct_t[rand_NEXT].OUT == C_OPEN )
                    break;

            }while(1);


            Struct_t[rand_FIX].IN = C_CLOSE;
            Struct_t[rand_NEXT].OUT = C_CLOSE;
            Struct_t[rand_FIX].FS = rand_NEXT;

            if (Struct_t[rand_FIX].IN == C_CLOSE && Struct_t[rand_FIX].OUT == C_CLOSE )
                Struct_t[rand_FIX].CLOSE = C_CLOSE;
            if (Struct_t[rand_NEXT].IN == C_CLOSE && Struct_t[rand_NEXT].OUT == C_CLOSE )
                Struct_t[rand_NEXT].CLOSE = C_CLOSE;

          
        }
        
    };

    return (EXIT_SUCCESS);
}

