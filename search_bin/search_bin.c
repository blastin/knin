
#include "string.h"
#include "common.h"
#include "hot_key.h"
#include "search_bin.h"



int search_key_string(char * array_key,char * search_key,FILE * key_fp){
    
                                /* _KEY :  struct key : estrutura que conte array para hot_key 
                            [ direita, esquerda,cima,baixo].
                                key : char * key : ponteiro para caracteres com a busca que será 
                                feita no arquivo.
                                n : int n :  número de caracteres que a string deve ter
                                key_file : FILE * key_file : arquivo contendo caracteres constantes 
                                para o deslocamento.

                            */
    
    int size_search_key = length(search_key)-1;
    int embrance_init_flag=0,search_flag=0;
    int offset=0,offset_embrance=0;
    
    char * searching = (char*)malloc(sizeof(char)*size_search_key);
    char * embrance = (char*)malloc(sizeof(char)*150);
    
    for(;;++offset){
        printf("searching status 1 : c[%c] || [.%s.][%d] || value offset : %d ||size search : %d\n",*(searching+offset),searching,length(searching),offset,size_search_key);
         //printf("embrance_init_flag : %d\t offset : %d \t temp : %d\n",embrance_init_flag,offset,temp);
        
        if((*(searching+offset) = getc(key_fp)) == EOF){
            
            printf("end of file ..\n");
            break;
        }
        printf("value *searching: %d\n",*(searching+offset));
        printf("searching status 2 : c[%c] || [.%s.][%d] || value offset : %d ||size search : %d\n",*(searching+offset),searching,length(searching),offset,size_search_key);
        
        //
            
        if(*(searching+offset) == EMBRANCE_INIT){
            printf("entrei EMBRANCE_INIT \n");
            embrance_init_flag++;
            clear_searching(searching);
            offset=0;
            
            while(embrance_init_flag){
                if( (*(embrance+offset_embrance)=getc(key_fp)) == EMBRANCE_END){
                     offset_embrance = 0;
                    printf("\nesperando whitspace terminar : [");
                    while(whitspace(*(embrance+offset_embrance) = getc(key_fp)))
                        putchar(*(embrance+offset_embrance));
                    putchar(']');
                    
                    printf("\nEMBRANCE_END\n");
                   
                    embrance_init_flag--;
                    
                }else printf("%c",*(embrance+offset_embrance++));
            }
            //printf("embrance_init_flag : %d\t offset : %d \t temp : %d\n",embrance_init_flag,offset,temp);
            
            putchar('\n');
            *(searching+offset) = *(embrance+offset_embrance);
            offset_embrance = 0;
        }
        else if(*(searching+offset) == *search_key){
            
            
            
        }
            
        else if (offset == size_search_key){ 
            
            printf("entrei strncomp : [%c]\n",*(searching+offset));
            if(!strncomp(searching,search_key,1)){
                printf("entrei strcomp\n");
                if(! strcomp(searching,search_key)){
                    search_flag++;
                    printf("achei : %s <=> %s\n",searching,search_key);
                    break;
                        }
            
                }
            clear_searching(searching);
            offset=-1;
        }
        
        
        
        else
            printf("control-flow else\n");
        
        
    }
    
    
    return 0;
	
}


static int whitspace(const char search){
    
    if(search == '\t' || search == '\n')
        return 1;
    return 0;
    

}
static void clear_searching(char * searching){
    int n = length(searching);
    printf("clean: ");
    for(;*searching;*searching++=0){
        printf("%c",*searching);
        
    }
    printf("\tsearching : [.%s.]\tlength : %d\n",searching,length(searching));
}