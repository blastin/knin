 /* 
 * File:   main.c
 * Author: blastin
 *
 * Created on 8 de Setembro de 2011, 21:22
 */



#include "header.h"


#if defined(WIN_32)
        
        #define _CONIO_
        #include <conio.h>
#endif



extern struct map_info VOID_MAP(mapa02);
extern struct corpo_info VOID_CORPO(quadrado);

int getchar(void);



void main(int argc,char *argv[]){char offset;

     message("Bem Vindo ao KNiN Project\n");
     
     map_t m_i = &VOID_MAP(mapa02);
     corpo_t c_i =  &VOID_CORPO(quadrado);
     
     
     
     map_init(m_i);
     _FC(init)(m_i,c_i); 
     
     corpo_t c_ibackup = c_i;
     
    if (argc > 1)
         if(strcmp(argv[1],"ABCD") == 0){ 
             c_i->FLAG_DEBUG = 0x1;
             message("ABCD ON\n");
               
         }
     
         
      _FM(putmap)(m_i,c_i);
      
     do{
         
#if defined(_CONIO_)
             offset = getch();
    #else
             system("stty echo raw");
             
             offset = getchar();
            
             system("stty echo -raw");
             
            
    #endif 
             
             if(offset == 'E' || offset == 'e')
                 break;
             else if(offset == EOF){
                 message ("erro no  recebimento de posição\n");
                 break;
             }
             /*  < = ^[[D
                   > = ^[[C
                  *cima = ^[[A
                  * baixo = ^[[B
                  **/ 

             switch(offset){

                 case 'D' : case 'd':
                     offset = FLAG_RIGHT;
                     break;

                 case 'A' : case 'a':
                     offset = FLAG_LEFT;
                     break;

                 case 'W' : case 'w':
                     offset = FLAG_UP;
                     break;

                 case 'S' : case 's':
                     offset = FLAG_DOWN;
                     break;
                     
                
                     
                 case '8' : case '6':/*ADD AND REMOVE SIZE BASE OR Height*/
                 case '4' : case '2':
                 case '7' : case '3':
                 case '1' : case '9':
                     
                     switch(offset){
                             
                         case '4':
                             offset = FLAG_ADD_BASE_LEFT;
                             //corpo_add_size(m_i,c_i,FLAG_ADD_BASE_LEFT);
                             break;
                         case '6':
                             offset = FLAG_ADD_BASE_RIGHT;
                             //corpo_add_size(m_i,c_i,FLAG_ADD_BASE_RIGHT);
                             break;
                         case '8':
                             offset = FLAG_ADD_ALTURA_UP;
                            // corpo_add_size(m_i,c_i,FLAG_ADD_ALTURA_UP);
                             break;
                         case '2':
                             offset  = FLAG_ADD_ALTURA_DOWN;
                              //corpo_add_size(m_i,c_i,FLAG_ADD_ALTURA_DOWN);
                             break;
                         case '7':
                             offset = FLAG_REMOVE_BASE_RIGHT;
                              //corpo_add_size(m_i,c_i,FLAG_REMOVE_BASE_RIGHT);
                             break;
                         case '3':
                             offset = FLAG_REMOVE_ALTURA_UP;
                              //corpo_add_size(m_i,c_i,FLAG_REMOVE_ALTURA_UP);
                             break;
                         case '9':
                             offset = FLAG_REMOVE_BASE_LEFT;
                             //corpo_add_size(m_i,c_i,FLAG_REMOVE_BASE_LEFT);
                             break;
                         case '1' :
                             offset =  FLAG_REMOVE_ALTURA_DOWN;
                             //corpo_add_size(m_i,c_i,FLAG_REMOVE_ALTURA_DOWN);
                             break;
                             
                     }
                     
                     break;
                 default :
                     
                     offset = FLAG_NULL;
                     
                     break;
             }





           corpo_map(m_i,c_i,offset);

           _FM(putmap)(m_i,c_i);   
           
     }while(TRUE);

          //putchar(m_i->map_show[30][103] == BLOCK_MAP ? '*' : '-');

}