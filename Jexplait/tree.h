/* 
 * File:   Header.h
 * Author: jeff
 *
 * Created on 19 de Dezembro de 2013, 20:11
 */


#undef true
#undef false
enum _enum {
        C_OFF=-1,
        C_OPEN=0,
        C_CLOSE,
        false=0,
        true
};
    
typedef struct {
    
    unsigned int IN    : 1; // sem ou já com acesso saida para outra estrutura.
    unsigned int OUT   : 1; // sem ou com já acesso de entrada de outra estrutura.
    unsigned int CLOSE : 1; // estrutura fechada ou aberta. 
    unsigned int FSIN; // FSIN<FIle Struct IN> ">>" inteiro para  estrutura na camada a qual se interligou  . 
    unsigned int FSOUT;// FSIN<FIle Struct OUT> "<<" inteiro para  estrutura na camada a qual esta interligada 
    
}__JTREE_EXPLAIT;


typedef struct{
    
    unsigned int __JRECURSIVE;
    int * __JINFO_INIT;
    int * __JINFO_NEXT;
    unsigned int __JINFO_INIT_COUT;
    unsigned int __JINFO_NEXT_COUT;
    
}__JTHREE_EXPLAIT_INFO;



int 
tree_struct(__JTREE_EXPLAIT * ,__JTHREE_EXPLAIT_INFO *,const int);
