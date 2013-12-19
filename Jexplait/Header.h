/* 
 * File:   Header.h
 * Author: jeff
 *
 * Created on 19 de Dezembro de 2013, 20:11
 */

#ifndef HEADER_H
#define	HEADER_H


enum _enum {
    
        C_OPEN,
        C_CLOSE
};
    
    
typedef struct {
    
    unsigned int IN    : 1; // sem ou já com acesso saida para outra estrutura.
    unsigned int OUT   : 1; // sem ou com já acesso de entrada de outra estrutura.
    unsigned int CLOSE : 1; // estrutura fechada ou aberta. 
    unsigned int FS; // FS<FIle Struct>  inteiro para próxima estrutura na camada de ligamento. 
    
}_base;

#endif	/* HEADER_H */

