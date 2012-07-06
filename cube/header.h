/* 
 * File:   header.h
 * Author: blastin
 *
 * Created on 22 de Outubro de 2011, 02:34
 */

/*#ifndef HEADER_H
        #define	HEADER_H*/

#define create_object_m(x) struct map_info object_ ## x
#define create_object_c(x) struct corpo_info object_ ## x

#define create_msg(x) struct output_message message_ ## x



#define VOID_MAP(x) object_ ## x
#define VOID_CORPO(x) object_ ## x


typedef int flag;

typedef struct map_info * map_t;

typedef struct corpo_info * corpo_t;


#define MAX_BASE 200
#define MAX_ALTURA 200

#define MAX_ARRAY_SIZE 120





enum _flag{
    
    FALSE                       = 0x00,
    TRUE                        = 0X01,
    DEBUG_OFF                   = 0x00,
    DEBUG_ON                    = 0x01,
    
    
    
    NULL_MAP                    = 0x01,
    CORPO_MAP                   = 0x02,
    BLOCK_MAP                   = 0x03,
    
    FLAG_NULL                   = 0x04,
    FLAG_RIGHT                  = 0x08,
    FLAG_LEFT                   = 0x10,
    FLAG_UP                     = 0x20,
    FLAG_DOWN                   = 0x30,
    FLAG_END                    = 0x40,
    
    FLAG_ADD_BASE_RIGHT         = 0x50,
    FLAG_ADD_ALTURA_UP          = 0x51,
    FLAG_ADD_BASE_LEFT          = 0x52,
    FLAG_ADD_ALTURA_DOWN        = 0x53,
    
    FLAG_REMOVE_BASE_RIGHT      = 0x54,
    FLAG_REMOVE_ALTURA_UP       = 0x55,
    FLAG_REMOVE_BASE_LEFT       = 0x56,
    FLAG_REMOVE_ALTURA_DOWN     = 0x57,
    
            
};

#define NM NULL_MAP
#define CM CORPO_MAP
#define BM BLOCK_MAP

enum _CHARACTER{
    
    BLOCK_CHARACTER = '\'',
    CORPO_CHARACTER = '\"',
    ESPACE_CHARACTER= ' ',
    ERROR_CHARACTER = '#',
    
    A = 'A',
    B = 'B',
    C = 'C',
    D = 'D',
    
   
            
    
};

/*enum _MOVIMENT{
    LEFT = 'D',
    left = 'd',
 
    
};*/

 /*#define LEFT  "^[[D"
 #define RIGHT "^[[D"
 #define DOWN  "^[[B"
 #define UP    "^[[A"**/
         
#define point_connection_cubo ;

#define _OFFSET_MOD ;


#define _FM(x) M_ ## x
#define _FC(x) C_ ## x

#define m_i index
#define m_s map_show

#define c_i corpo
#define c_s corpo_show



#define NEXT_OFFSET 0x01

#define MAP_NUM_LOCAL -1

char * msg_error;

#define NULL ((void * ) 0)
#define SUCESS ((void * )1 )
#define EOF (-1)

#define AREA_MAX  MAX_BASE * MAX_ALTURA 


struct output_message{
    
    char msg[MAX_ARRAY_SIZE][MAX_ARRAY_SIZE];
    
    unsigned int ID;
    unsigned int flag:1;
    
    
};

 struct map_info{
    
    char *nome;
    
   
    
    char m_s[MAX_ALTURA][MAX_BASE];
    
    unsigned int altura;
    unsigned int base;
    
    
};


struct corpo_info{
    
   
     
    char * nome;
    
    
    
   
     /*
     
     int points[MAX_LINE_POINT][2];
     * point = {
     *           {x,y},
     *           {x,y},
     *         }
     
     
     */
    
    int c_s[MAX_ALTURA-1][MAX_BASE-1];
    
    unsigned int FLAG_DEBUG:1;
    
    int base,altura;
    
    unsigned int point_A_x:7;
    unsigned int point_A_y:7;/*a propia linha do mapa : exempl
                                 {A,1,1,1,1,1,1} A > oeste
                                 {1,0,0,0,0,0,1}
                              *  {1,1,1,1,1,1,1} 
                                 */
   
    unsigned int point_B_x:7;
    unsigned int point_B_y:7;/* o último ponto do objeto leste
                                 * 
                                 {1,1,1,1,1,1,B}B > leste
                                 {1,0,0,0,0,0,1}
                                 {1,1,1,1,1,1,1} 
                                 */
    unsigned int point_C_x:7;
    unsigned int point_C_y:7;/* o último ponto do objeto leste
                                 * 
                                 {1,1,1,1,1,1,B}
                                 {1,0,0,0,0,0,1}
                                 {C,1,1,1,1,1,1} C> oeste 
                                 */
    
    unsigned int point_D_x:7;
    unsigned int point_D_y:7;/* o último ponto do objeto leste
                                 * 
                                 {1,1,1,1,1,1,1}
                                 {1,0,0,0,0,0,1}
                                 {1,1,1,1,1,1,D} D> leste
                                 */
    
    unsigned int direcao:1;
    unsigned int sentido:1;
    
};





/* #endif	 HEADER_H */
