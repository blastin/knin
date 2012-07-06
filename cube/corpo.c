/* 
 * File:   corpo.c
 * Author: blastin
 *
 * Created on 23 de Outubro de 2011, 22:16
 */

#include "header.h"

//#include <stdlib.h>
//#include <stdio.h>


_OFFSET_MOD
#define _OFFSET(FLAG_UP_DOWN,FLAG_LEFT_RIGHT) \
    m_i->m_s[FLAG_UP_DOWN c_i->point_B_y][FLAG_LEFT_RIGHT c_i->point_B_x] = \
    m_i->m_s[FLAG_UP_DOWN c_i->point_D_y][FLAG_LEFT_RIGHT c_i->point_D_x] = \
    m_i->m_s[FLAG_UP_DOWN c_i->point_A_y][FLAG_LEFT_RIGHT c_i->point_A_x] = \
    m_i->m_s[FLAG_UP_DOWN c_i->point_C_y][FLAG_LEFT_RIGHT c_i->point_C_x] = CORPO_MAP;
_OFFSET_MOD



#define _FUNC(x) void C_ ## x(map_t m_i,corpo_t c_i)
static void corpo_add_size(map_t m_i,corpo_t c_i,flag FLAG);

_FUNC(init){
    
    register int row,colun;
    
    for(row=0;c_i->c_s[row][0] == NM ||c_i->c_s[row][0] == BM ;row++)
        for(colun=0;c_i->c_s[row][colun] == NM ||c_i->c_s[row][colun] == BM;colun++);
            
    c_i->altura = row;
    c_i->base   = colun;
    
    
    /*printf("CORPO : base:%d || altura :%d\n",colun,row);
    printf("MAP   : base:%d || altura :%d\n",m_i->base,m_i->altura);**/
   
    
    c_i->point_B_y = c_i->point_A_y =  m_i->altura - c_i->altura - 1    ;
    c_i->point_D_y = c_i->point_C_y =  c_i->point_A_y + c_i->altura - 1;
     
    c_i->point_C_x = c_i->point_A_x =  1;
    c_i->point_D_x = c_i->point_B_x =  c_i->base -1;
    
    
     
     m_i->m_s[c_i->point_B_y][c_i->point_B_x] = m_i->m_s[c_i->point_A_y][c_i->point_A_x] = CORPO_MAP;
     m_i->m_s[c_i->point_D_y][c_i->point_D_x] = m_i->m_s[c_i->point_C_y][c_i->point_C_x] = CORPO_MAP;
   
    
  
           
    
}void * corpo_map(map_t m_i,corpo_t c_i,int FLAG){

    if(c_i == NULL) return NULL;/*aqui ficara a função write criada*/

    else{
                
                switch(FLAG){
                    
                        case FLAG_NULL:
                            /*info*/
                            break;
                            
                        case FLAG_RIGHT:
                            if (m_i->m_s[c_i->point_B_y][c_i->point_B_x + NEXT_OFFSET] == NULL_MAP)
                                 _OFFSET( ,++)
                            break;
                            
                        case FLAG_LEFT:
                            if (m_i->m_s[c_i->point_A_y][c_i->point_A_x - NEXT_OFFSET] == NULL_MAP)
                                 _OFFSET( ,--)
                            break;
                            
                       case FLAG_UP:
                            if (m_i->m_s[c_i->point_A_y - NEXT_OFFSET][c_i->point_A_x] == NULL_MAP)
                                 _OFFSET(--, )
                            break;
                            
                        case FLAG_DOWN:
                            if (m_i->m_s[c_i->point_C_y + NEXT_OFFSET][c_i->point_C_x] == NULL_MAP)
                                 _OFFSET(++, )
                            break;

                         case FLAG_ADD_BASE_LEFT:
                            
                             corpo_add_size(m_i,c_i,FLAG_ADD_BASE_LEFT);
                             break;
                         case FLAG_ADD_BASE_RIGHT:
                            
                             corpo_add_size(m_i,c_i,FLAG_ADD_BASE_RIGHT);
                             break;
                         case FLAG_ADD_ALTURA_UP:
                            
                             corpo_add_size(m_i,c_i,FLAG_ADD_ALTURA_UP);
                             break;
                         case FLAG_ADD_ALTURA_DOWN:
                             
                              corpo_add_size(m_i,c_i,FLAG_ADD_ALTURA_DOWN);
                             break;
                         case FLAG_REMOVE_BASE_RIGHT:
                           
                              corpo_add_size(m_i,c_i,FLAG_REMOVE_BASE_RIGHT);
                             break;
                         case FLAG_REMOVE_ALTURA_UP:
                            
                              corpo_add_size(m_i,c_i,FLAG_REMOVE_ALTURA_UP);
                             break;
                         case FLAG_REMOVE_BASE_LEFT:
                             
                             corpo_add_size(m_i,c_i,FLAG_REMOVE_BASE_LEFT);
                             break;
                         case FLAG_REMOVE_ALTURA_DOWN :
                             
                             corpo_add_size(m_i,c_i,FLAG_REMOVE_ALTURA_DOWN);
                             break;
                             
                       default:
                           break;
                        
                        
                }
                
                
        _OFFSET( ,  ) 
                
        return SUCESS;
    }
    
    
}static void corpo_add_size(map_t m_i,corpo_t c_i,flag FLAG){ message("entrei\n");
    
    switch(FLAG){
        
        /*criar condicional para verificar se vai overflow limite da matrix*/
        
        case FLAG_ADD_BASE_RIGHT:
            
             
            if(m_i->m_s[c_i->point_B_y][c_i->point_B_x + NEXT_OFFSET]   == NULL_MAP){
               // message("entrei : direita\n");
                
                c_i->point_B_x++;
                c_i->point_D_x++;
                c_i->base++;
            }
            break;
            
        case FLAG_ADD_ALTURA_UP:
            
             if(m_i->m_s[c_i->point_A_y -  NEXT_OFFSET][c_i->point_A_x]  == NULL_MAP){
                  //message("entrei cima\n");
                c_i->point_A_y--;
                c_i->point_B_y--;
                c_i->altura++;
             }
             break;
         case FLAG_ADD_BASE_LEFT:
             
              if(m_i->m_s[ c_i->point_A_y][c_i->point_A_x - NEXT_OFFSET] == NULL_MAP){
                   //message("entrei esquerda\n");
                c_i->point_A_x--;
                c_i->point_C_x--;
                c_i->base++;
              }
            break;
        case FLAG_ADD_ALTURA_DOWN:
             
             if(m_i->m_s[c_i->point_C_y + NEXT_OFFSET][c_i->point_C_x]  == NULL_MAP){
                 
                 //message("entrei baixo\n");
                c_i->point_C_y++;
                c_i->point_D_y++;
                c_i->altura++;
             }
            break;
      
        case FLAG_REMOVE_BASE_RIGHT:
            
            if(m_i->m_s[c_i->point_B_y ][c_i->point_B_x - NEXT_OFFSET]  == NULL_MAP && \
                    c_i->point_B_x - NEXT_OFFSET != c_i->point_A_x){
                
                c_i->point_B_x--;
                c_i->point_D_x--;

                c_i->base--;
            }
            break;
                
        case FLAG_REMOVE_ALTURA_UP:
            if(m_i->m_s[c_i->point_A_y + NEXT_OFFSET ][c_i->point_A_x]  == NULL_MAP && \
                   c_i->point_A_y + NEXT_OFFSET != c_i->point_C_y ){
                
                c_i->point_A_y++;
                c_i->point_B_y++;
                c_i->altura--;
            }
            break;
        case FLAG_REMOVE_BASE_LEFT:
            if(m_i->m_s[c_i->point_A_y][c_i->point_A_x + NEXT_OFFSET]  == NULL_MAP && \
                    c_i->point_A_x + NEXT_OFFSET != c_i->point_B_x){
                
                c_i->point_A_x++;
                c_i->point_C_x++;
                c_i->base--;
            }
            break;
        case FLAG_REMOVE_ALTURA_DOWN:
            if(m_i->m_s[c_i->point_D_y - NEXT_OFFSET ][c_i->point_D_x]  == NULL_MAP && \
                    c_i->point_D_y - NEXT_OFFSET != c_i->point_B_y){
                
                c_i->point_C_y--;
                c_i->point_D_y--;
                c_i->altura--;
            }
            break;
    };
    
  
}
