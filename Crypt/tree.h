/*
* File:   Header.h
* Author: jeff
*
* Created on 19 de Dezembro de 2013, 20:11
*/

#if defined(true) && defined(false)
#undef true
#undef false
#endif

#define __JNOTHING ;
#define RECURSIVE_MAX 200000
enum _enum {
	C_OFF = -1,
	C_OPEN = 0,
	C_CLOSE,
	false = 0,
	true
};

typedef struct {

	unsigned int IN : 1; // sem ou j� com acesso para se conectar com outra estrutura.
	unsigned int OUT : 1; // sem ou com j� acesso para ser conectado por outra estrutura.
	unsigned int CLOSE : 1; // estrutura fechada ou aberta. 
	unsigned int FSIN;    // FSIN<FIle Struct IN> ">>" inteiro para  estrutura na camada a qual se interligou  . 
	unsigned int FSOUT;    // FSIN<FIle Struct OUT> "<<" inteiro para  estrutura na camada a qual esta interligada 

}__JTREE_EXPLAIT;


typedef struct{

	int * __JINFO_INIT;/*
					   * array cont�m numera��o de estruturas ainda aberta. QUando fechadas o canal de sa�da  � trocado pelo valor de C_OFF    */
	int * __JINFO_OUT;/*
					  * array cont�m numera��o de estruturas ainda aberta. QUando fechadas o canal de entrada  � trocado pelo valor de C_OFF*/

	unsigned int __JRECURSIVE; // Conta quantas entradas foram necess�rias na fun��o tree_struct.
	unsigned int __JINFO_INIT_COUT; // cont�m a quantidade de slot aberto para saida  conectar em outra estrutura.
	unsigned int __JINFO_OUT_COUT; // cont�m a quantidade de slot aberto para entrada ser conectado por outra estrutura.
	unsigned int __JINFO_LENGTH; // tamanho da �rvore. 

	unsigned int __JTREE_EXPLAIT_CIRCUIT : 1; /*  Caso o circuito seja fechado essa vari�vel ter� que ficar = 1 ,
											  * Caso seja circuito aberto a vari�vel ter� que ficar = 0*/
}__JTHREE_EXPLAIT_INFO;

int
tree_struct(__JTREE_EXPLAIT *, __JTHREE_EXPLAIT_INFO *, const unsigned int);
