/* 
 * File:   main.c
 * Author: jeff
 *
 * Created on 19 de Dezembro de 2013, 20:06
 */
/*
 ERROR:
 BUFFER OVERFLOW ACIMA DE 199.999 LIGAMENTOS
 * ESTUDAR CASO
 * Problema esta na própria função recursiva 
 * 
 
 * modo de compilação : gcc  -Wall -Wextra -Werror -foptimize-sibling-calls  -O0 -fprefetch-loop-arrays -g3 main.c struct_tree.c
 * modo de entrada ao programa : ./a.out "Quantidade de árvore" "Arquivo de saida" "CLOSE | OPEN"
 */
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
#include <string.h>
#include <time.h>

int main(int argc, char** argv) {
    
    unsigned int MAX_,FILECHECK_,x,count1,count2;
    double time_end;
    
    __JTREE_EXPLAIT * struct_base;
    __JTHREE_EXPLAIT_INFO info;
   
    FILE *file;
    clock_t time_over,time_init;
    
    if(argc>1)   
     {
         MAX_ = atoi( *(argv+1));
         
         if(*(argv+2) != NULL)
         {
             printf("%s\n",*(argv+2));
             FILECHECK_ = strcmp(*(argv+2),"FILE"); 
         }
         else
             FILECHECK_ = 1;   
         
         if(*(argv+3) != NULL)
         {
             if(!strcmp(*(argv+3),"OPEN"))
                 info.__JTREE_EXPLAIT_CIRCUIT = C_OPEN; // Circuito aberto|fechado;
             else if(!strcmp(*(argv+3),"CLOSE"))
                 info.__JTREE_EXPLAIT_CIRCUIT = C_CLOSE; // Circuito aberto|fechado;
             else
                  info.__JTREE_EXPLAIT_CIRCUIT = C_OPEN; // Circuito aberto|fechado;
         }
     }
    
     else
         MAX_ = 10;
    
    info.__JINFO_INIT = (int*)calloc(MAX_,sizeof(*info.__JINFO_INIT));
    info.__JINFO_OUT = (int*)calloc(MAX_,sizeof(*info.__JINFO_OUT));
    struct_base = (__JTREE_EXPLAIT *)calloc(MAX_ ,sizeof(* struct_base));
     
    if(!FILECHECK_)
        file = fopen("return.txt","w");
    
    printf("Iniciando conexões ....\n");
    time_init = clock();
    tree_struct(struct_base,&info,MAX_);
    time_over = clock();
    time_end = ((double)time_over - time_init)/CLOCKS_PER_SEC;
    printf("Conexão realizada com sucesso\n");
    
    if(!FILECHECK_)
    {
        for(x=0;x<MAX_;x++) 
                fprintf(file,"Struct[%8.1d] >> %8.1d | Struct[%8.1d] << %8.1d | status:%s\n",x,struct_base[x].FSIN,x,struct_base[x].FSOUT,(struct_base[x].CLOSE)? "fechada" : "aberta");
    
        fprintf(file,"Tempo total : %f segundos ou %f minutos ou %f horas\n",time_end,time_end/60,time_end/(60*60));
        fprintf(file,"Foi necessário entrar %d vezes na função recursiva\n",info.__JRECURSIVE);
    }
    
    else
    {
        fprintf(stdout,"Tempo total : %f segundos ou %f minutos ou %f horas\n",time_end,time_end/60,time_end/(60*60));
        fprintf(stdout,"Foi necessário entrar %d vezes na função recursiva\n",info.__JRECURSIVE);
    }
    
     for(x=count1=count2=0;x<MAX_;x++)
     {
         count1+= *(info.__JINFO_INIT+x);
         count2+= *(info.__JINFO_OUT+x);
     }
    
    if((count1 + count2) == -(MAX_*2))
        printf("sucesso programa finalizado\n");
    
    if(!FILECHECK_)
        fclose(file);
    
    return (EXIT_SUCCESS);
}