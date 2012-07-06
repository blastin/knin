/* 
 * File:   map.c
 * Author: blastin
 *
 * Created on 24 de Outubro de 2011, 17:11
 */
#include "header.h"


/*#include <stdio.h>
#undef putchar**/

#define _FUNC(x) void M_ ## x(map_t m_i,corpo_t c_i)

void map_init(map_t m_i){ int row,colun;

 for(row=0;m_i->m_s[row][0] == NM ||m_i->m_s[row][0] == BM ;row++)
        for(colun=0;m_i->m_s[row][colun] == NM ||m_i->m_s[row][colun] == BM;colun++);
       
 m_i->altura = row;
 m_i->base   = colun;
        
    
}static _FUNC(cleanup){register int row,colun;

for(row=0;row < m_i->altura;row++)
    for(colun=0;colun < m_i->base;colun++)
        if(m_i->m_s[row][colun] == CORPO_MAP)
             m_i->m_s[row][colun] = NULL_MAP;
}              
  _FUNC(putmap){register int row,colun;

     
#ifdef WIN_32
    system("cls");
#else
    system("clear");
#endif
    
    for(row=0;row < m_i->altura;row++){
        for(colun=0;colun < m_i->base;colun++){
           
            
            if(c_i->FLAG_DEBUG){
                
             putchar(
                    m_i->m_s[row][colun] == BLOCK_MAP ? BLOCK_CHARACTER  : \
                    m_i->m_s[row][colun] == CORPO_MAP ?                    \

                          (row == c_i->point_A_y && colun == c_i->point_A_x ? A : \
                           row == c_i->point_B_y && colun == c_i->point_B_x ? B : \
                           row == c_i->point_C_y && colun == c_i->point_C_x ? C : D )   : \

                    m_i->m_s[row][colun] == NULL_MAP  ? ESPACE_CHARACTER : ERROR_CHARACTER 
                      
                  );
             
            }
            else  { point_connection_cubo   /*QUADRADO POINT*/
                    
                 putchar(      m_i->m_s[row][colun] == BLOCK_MAP ? BLOCK_CHARACTER  : \
                               m_i->m_s[row][colun] == CORPO_MAP || \
                        (

          
                               (  row   >  c_i->point_A_y  &&     row <  c_i->point_C_y ) && \
                               (  colun == c_i->point_A_x  ||   colun == c_i->point_B_x ) || \
                               (  row   == c_i->point_A_y  ||     row == c_i->point_C_y ) && \

                               (
                                ( colun >  c_i->point_A_x  &&   colun <  c_i->point_B_x ) || \
                                ( colun >  c_i->point_C_x  &&   colun <  c_i->point_D_x )  
                               )
            
                       ) ? CORPO_CHARACTER  : m_i->m_s[row][colun] == NULL_MAP  ? \
                           ESPACE_CHARACTER : ERROR_CHARACTER  );

            }
     

 
        }
        
       putchar('\n');   
  }
    putchar(45);
    putchar('\n');
    _FM(cleanup)(m_i,c_i);
    
    
    
}
