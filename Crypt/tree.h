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

	unsigned int IN : 1; // sem ou já com acesso para se conectar com outra estrutura.
	unsigned int OUT : 1; // sem ou com já acesso para ser conectado por outra estrutura.
	unsigned int CLOSE : 1; // estrutura fechada ou aberta. 
	unsigned int FSIN;    // FSIN<FIle Struct IN> ">>" inteiro para  estrutura na camada a qual se interligou  . 
	unsigned int FSOUT;    // FSIN<FIle Struct OUT> "<<" inteiro para  estrutura na camada a qual esta interligada 

}__JTREE_EXPLAIT;


typedef struct{

	int * __JINFO_INIT;/*
					   * array contém numeração de estruturas ainda aberta. QUando fechadas o canal de saída  é trocado pelo valor de C_OFF    */
	int * __JINFO_OUT;/*
					  * array contém numeração de estruturas ainda aberta. QUando fechadas o canal de entrada  é trocado pelo valor de C_OFF*/

	unsigned int __JRECURSIVE; // Conta quantas entradas foram necessárias na função tree_struct.
	unsigned int __JINFO_INIT_COUT; // contém a quantidade de slot aberto para saida  conectar em outra estrutura.
	unsigned int __JINFO_OUT_COUT; // contém a quantidade de slot aberto para entrada ser conectado por outra estrutura.
	unsigned int __JINFO_LENGTH; // tamanho da árvore. 

	unsigned int __JTREE_EXPLAIT_CIRCUIT : 1; /*  Caso o circuito seja fechado essa variável terá que ficar = 1 ,
											  * Caso seja circuito aberto a variável terá que ficar = 0*/
}__JTHREE_EXPLAIT_INFO;

int
tree_struct(__JTREE_EXPLAIT *, __JTHREE_EXPLAIT_INFO *, const unsigned int);
