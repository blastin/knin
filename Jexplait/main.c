/* 
 * File:   main.c
 * Author: jeff
 *
 * Created on 19 de Dezembro de 2013, 20:06
 */

#include <stdio.h>
#include <stdlib.h>
#include "tree.h"

#define MAX_ 14578
/*
 * 
 */
int main(int argc, char** argv) {
    
    __JTREE_EXPLAIT struct_base[MAX_];
    FILE *file;
    file = fopen("return.txt","w");
    int x,*rand_acess_fix,*rand_acess_next,count1,count2;
    
    rand_acess_fix=(int*)malloc(MAX_*sizeof(*rand_acess_fix));
    rand_acess_next=(int*)malloc(MAX_*sizeof(*rand_acess_next));
    
    tree_struct(struct_base,MAX_,rand_acess_fix,rand_acess_next);
   
   for(x=0;x<MAX_;x++)
    {  
     fprintf(file,"Struct_t[%d]:IN[%s] OUT[%s] CN[%d]:%d  COUT[%d]:%d CLOSE:%d\n",x,(struct_base[x].IN == C_OPEN) ? "OP" : "CL",(struct_base[x].OUT == C_OPEN) ? "OP" : "CL",x,struct_base[x].FSIN,x,struct_base[x].FSOUT,struct_base[x].CLOSE);
    }
    
     for(x=count1=count2=0;x<MAX_;x++)
     {
         count1+= *(rand_acess_fix+x);
         count2+= *(rand_acess_next+x);
     }
    
    if((count1 + count2) == -(MAX_*2))
        printf("sucesso\n");
    
    fclose(file);
    /*printf("rand_acess_fix[");
    
     
    for(x=0;x<MAX_;x++)
    {
        printf("%d,",*(rand_acess_fix+x));
    }
    printf("]\nrand_acess_next[");
    for(x=0;x<MAX_;x++)
    {
        printf("%d,",*(rand_acess_next+x));
    }
    putchar(']');
    putchar('\n');*/
     
  
    return (EXIT_SUCCESS);
}
