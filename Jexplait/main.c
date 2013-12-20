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
    
    _base Struct_t[3];
    short int x,increment;
    short int count_check_struct; // conta estruturas já fechadas. 
    int rand_FIX;  // numero aleatório da estrutura passiva
    int rand_NEXT; // numero aleatório da estrutura ativa
    
    for(x=0,increment=0;x<3;x++)
    {
        Struct_t[x].IN = C_OPEN;
        Struct_t[x].OUT = C_OPEN;
        Struct_t[x].CLOSE = C_OPEN;
        Struct_t[x].FSIN = --increment;
        Struct_t[x].FSOUT = --increment;
    }
    srand (time(NULL));
    
    while(1)
    {
        for(x=0,count_check_struct=0;x < 3; x++)
            {
                if(Struct_t[x].CLOSE == C_CLOSE)
                    ++count_check_struct;
                printf("check value : %d\n",count_check_struct);
            }
        if(count_check_struct == 3)    
        {
            printf("todas estruturas interligadas\n");
            break;   
        }
        
        else 
        {
            do
            {
                rand_FIX  = rand()%3+0;
                printf("rand_FIX %d\t",rand_FIX);
                rand_NEXT = rand()%3+0;
                printf("rand_NEXT %d\n",rand_NEXT);
                getchar();
                if (Struct_t[rand_FIX].IN == C_OPEN)
                {
                    printf("Struct_t[%d].IN : %d\n",rand_FIX,Struct_t[rand_FIX].IN == C_OPEN);
                    if (Struct_t[rand_NEXT].OUT == C_OPEN)
                    {
                        printf("Struct_t[%d].OUT : %d\n",rand_NEXT,Struct_t[rand_NEXT].OUT == C_OPEN);
                        if(rand_FIX != rand_NEXT)
                        {
                            if(rand_FIX != Struct_t[rand_NEXT].FSIN)
                        {
                                if((3&1))
                                 {
                                    printf("Trabalhando com impares\n");
                                    
                                         for(x=0,count_check_struct=0;x<3;x++)
                                         {
                                                if(Struct_t[x].OUT == C_OPEN)
                                                {
                                                    count_check_struct++;
                                                    printf("SLot aberto para entrada  total : %d <<\n", count_check_struct);
                                                }
                                                if(count_check_struct > 1)
                                                    break;
                                         }
                        
                                         if(count_check_struct == 1)
                                         {
                                             printf("ultimo slot aberto \n");
                                             break;
                                         }
                    }
                    
                    if(Struct_t[rand_FIX].FSOUT != Struct_t[rand_NEXT].FSIN)
                     break;
                            }
                }
                }
                }
            }while(1);

            //printf("Struct_t[%d].IN : close\t",rand_FIX);
            Struct_t[rand_FIX].IN = C_CLOSE;
            //printf("Struct_t[%d].OUT : close\n",rand_NEXT);
            Struct_t[rand_NEXT].OUT = C_CLOSE;
            //printf("Struct_t[%d] conectou com Struct_t[%d]\n",rand_FIX,rand_NEXT);
            Struct_t[rand_FIX].FSIN = rand_NEXT;
            Struct_t[rand_NEXT].FSOUT = rand_FIX;
            
            if (Struct_t[rand_FIX].IN == C_CLOSE && Struct_t[rand_FIX].OUT == C_CLOSE )
            {
                printf("Struct_t[%d] Foi fechada \n",rand_FIX);
                Struct_t[rand_FIX].CLOSE = C_CLOSE;
            }
            if (Struct_t[rand_NEXT].IN == C_CLOSE && Struct_t[rand_NEXT].OUT == C_CLOSE )
            {
                 printf("Struct_t[%d] Foi fechada \n",rand_NEXT);
                Struct_t[rand_NEXT].CLOSE = C_CLOSE;
            }
            for(x=0;x<3;x++)
            {
                printf("Struct_t[%d]:IN[%s] OUT[%s] CN[%d]:%d  COUT[%d]:%d CLOSE:%d\n",x,(Struct_t[x].IN == C_OPEN) ? "OP" : "CL",(Struct_t[x].OUT == C_OPEN) ? "OP" : "CL",x,Struct_t[x].FSIN,x,Struct_t[x].FSOUT,Struct_t[x].CLOSE);
                
        
            }
            /*if (Struct_t[rand_NEXT].IN == C_CLOSE && Struct_t[rand_NEXT].OUT == C_CLOSE )
            {
                
                Struct_t[rand_NEXT].CLOSE = C_CLOSE;
            }*/
          
        }
        
    };

    return (EXIT_SUCCESS);
}

