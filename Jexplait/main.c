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

#define MAX_ 1350
 static int value=0 ;
/*
 * 
 */
int main(int argc, char** argv) {
      srand (time(NULL));
    _base Struct_t[MAX_];
    int rand_acess_fix[MAX_]; // estruturas ainda livres para entrada ">>"
    int rand_acess_next[MAX_]; // estruturas ainda livres para serem entrada "<<"
    short int x,increment;
    short int count_check_struct; // conta estruturas já fechadas. 
    short int slot_open;
    int rand_FIX;  // numero aleatório da estrutura passiva
    int rand_NEXT; // numero aleatório da estrutura ativa
   
    for(x=0,increment=0;x<MAX_;x++)
    {
        Struct_t[x].IN = C_OPEN;
        Struct_t[x].OUT = C_OPEN;
        Struct_t[x].CLOSE = C_OPEN;
        Struct_t[x].FSIN = --increment;
        Struct_t[x].FSOUT = --increment;
        rand_acess_fix[x] = x;
        rand_acess_next[x] = x;
    }
    
    
    while(1)
    {
        for(x=0,count_check_struct=0;x < MAX_; x++)
            {
                if(Struct_t[x].CLOSE == C_CLOSE)
                    ++count_check_struct;
               //printf("check value : %d\n",count_check_struct);
            }
        if(count_check_struct == MAX_)    
        {
            printf("todas estruturas interligadas\n");
            break;   
        }
        
        else 
        {
            do
            {
                do
                {
                    rand_FIX  = rand()%MAX_;
                    if(rand_acess_fix[rand_FIX] == C_OFF)
                        continue;
                    else
                        break;
                
                }while(1); 
                
               // printf("rand_FIX %d\t",rand_FIX);
                
                do{
                    rand_NEXT = rand()%MAX_;
                    if(rand_acess_next[rand_NEXT] == C_OFF)
                        continue;
                    else
                        break;
                }while(1);
                
                
               // printf("rand_NEXT %d\n",rand_NEXT);
                
                
                if (Struct_t[rand_FIX].IN == C_OPEN && Struct_t[rand_FIX].CLOSE == C_OPEN && Struct_t[rand_NEXT].CLOSE == C_OPEN )
                {
                    
                    for(x=0,count_check_struct=0;x<MAX_;x++)
                    {
                        if(Struct_t[x].OUT == C_OPEN)
                        {
                            slot_open = x;
                            count_check_struct++;
                           // printf("SLot aberto para entrada  total : %d <<\n", count_check_struct);

                        }
                    }
                    if(count_check_struct == 1)
                    {
                        rand_NEXT = slot_open;
                        //printf("ultimo slot aberto , prosseguir \n");
                        break;
                    }
                    
                   
                    if (Struct_t[rand_NEXT].OUT == C_OPEN && rand_FIX != rand_NEXT)
                    {
                       // printf("Struct_t[%d].OUT : open\n",rand_NEXT);
                        //printf("Struct_t[%d].IN : open \n",rand_FIX);
                        if(!recursive_Fscheck(&Struct_t,rand_FIX,rand_NEXT))
                                break;    
                    }
                }
            }while(1);

            
            Struct_t[rand_FIX].IN = C_CLOSE;
            rand_acess_fix[rand_FIX] = C_OFF;
            
            Struct_t[rand_NEXT].OUT = C_CLOSE;
            rand_acess_next[rand_NEXT] = C_OFF;
            
            Struct_t[rand_FIX].FSIN = rand_NEXT;
            Struct_t[rand_NEXT].FSOUT = rand_FIX;
            
            if (Struct_t[rand_FIX].IN == C_CLOSE && Struct_t[rand_FIX].OUT == C_CLOSE )
                Struct_t[rand_FIX].CLOSE = C_CLOSE;
               
            if (Struct_t[rand_NEXT].IN == C_CLOSE && Struct_t[rand_NEXT].OUT == C_CLOSE )
                Struct_t[rand_NEXT].CLOSE = C_CLOSE;
        }
        
    };
    
    for(x=0;x<MAX_;x++)
    {
        printf("Struct_t[%d]:IN[%s] OUT[%s] CN[%d]:%d  COUT[%d]:%d CLOSE:%d\n",x,(Struct_t[x].IN == C_OPEN) ? "OP" : "CL",(Struct_t[x].OUT == C_OPEN) ? "OP" : "CL",x,Struct_t[x].FSIN,x,Struct_t[x].FSOUT,Struct_t[x].CLOSE);
    }
    printf("rand_acess_fix[");
    for(x=0;x<MAX_;x++)
    {
        printf("%d,",rand_acess_fix[x]);
    }
    printf("]\nrand_acess_next[");
    for(x=0;x<MAX_;x++)
    {
        printf("%d,",rand_acess_next[x]);
    }
    putchar(']');
    putchar('\n');
    printf("recursive on  : %d\n",++value);
    return (EXIT_SUCCESS);
}

int 
recursive_Fscheck(_base * struct_base,int fix,int next)
{
    ++value;
   
    if(fix == (struct_base+next)->FSIN)
        return 1;
    else if((struct_base+next)->IN == C_CLOSE)
    {
        if(recursive_Fscheck(struct_base,fix,(struct_base+next)->FSIN))
            return 1;
        else return 0;
    }
    else
        return 0;
    
    
    
}