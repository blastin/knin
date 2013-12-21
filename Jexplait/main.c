/* 
 * File:   main.c
 * Author: jeff
 *
 * Created on 19 de Dezembro de 2013, 20:06
 */

#include <stdio.h>
#include <stdlib.h>
#include "tree.h"

#define MAX_ 98810
/*
 * 
 */
int main(int argc, char** argv) {
    
    __JTREE_EXPLAIT struct_base[MAX_];
    FILE *file;
    file = fopen("return.txt","w");
    int x,count1,count2;
    __JTHREE_EXPLAIT_INFO info;
    
    info.__JINFO_INIT = (int*)malloc(MAX_*sizeof(*info.__JINFO_INIT));
    info.__JINFO_NEXT = (int*)malloc(MAX_*sizeof(*info.__JINFO_NEXT));
    
    tree_struct(struct_base,&info,MAX_);
   
    printf("Conexão realizada com sucesso\n");
    
    fprintf(file,"Foi necessário entrar %d vezes na função recursiva\n",info.__JRECURSIVE);
    
    for(x=0;x<MAX_;x++) 
        fprintf(file,"Struct[%5.1d] >> %5.1d | Struct[%5.1d] << %5.1d | status:%s\n",x,struct_base[x].FSIN,x,struct_base[x].FSOUT,(struct_base[x].CLOSE)? "fechada" : "aberta");
    
     for(x=count1=count2=0;x<MAX_;x++)
     {
         count1+= *(info.__JINFO_INIT+x);
         count2+= *(info.__JINFO_NEXT+x);
     }
    
    if((count1 + count2) == -(MAX_*2))
        printf("sucesso programa finalizado\n");
    
    
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
