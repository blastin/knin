/* 
 * File:   main.c
 * Author: jeff
 *
 * Created on 19 de Dezembro de 2013, 20:06
 */

#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
#include <string.h>
#include <time.h>

int main(int argc, char** argv) {
    unsigned int MAX_;
     if(argc>1)   
         MAX_ = atoi( *(argv+1));
     else
         MAX_ = 4;
    
    FILE *file;
    file = fopen("return.txt","w");
    int x,count1,count2;
     double time_end;
    clock_t time_over,time_init;
    
    __JTHREE_EXPLAIT_INFO info;
    __JTREE_EXPLAIT struct_base[MAX_];
    info.__JINFO_INIT = (int*)malloc(MAX_*sizeof(*info.__JINFO_INIT));
    info.__JINFO_OUT = (int*)malloc(MAX_*sizeof(*info.__JINFO_OUT));
      
    printf("Iniciando conexões ....\n");
    time_init = clock();
    tree_struct(struct_base,&info,MAX_);
    time_over = clock();
    time_end = ((double)time_over - time_init)/CLOCKS_PER_SEC;
    printf("Conexão realizada com sucesso\n");
    fprintf(file,"Tempo total : %f segundos ou %f minutos ou %f horas\n",time_end,time_end/60,time_end/(60*60));
    fprintf(file,"Foi necessário entrar %d vezes na função recursiva\n",info.__JRECURSIVE);
    
    for(x=0;x<MAX_;x++) 
        fprintf(file,"Struct[%8.1d] >> %8.1d | Struct[%8.1d] << %8.1d | status:%s\n",x,struct_base[x].FSIN,x,struct_base[x].FSOUT,(struct_base[x].CLOSE)? "fechada" : "aberta");
    
     for(x=count1=count2=0;x<MAX_;x++)
     {
         count1+= *(info.__JINFO_INIT+x);
         count2+= *(info.__JINFO_OUT+x);
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
