#include "tree.h"
#include <time.h>
#include <stdlib.h>
//#include <stdio.h>
static int
recursive_tree(__JTREE_EXPLAIT *, unsigned int*, const unsigned int, unsigned int);
static int
jump_tree(__JTREE_EXPLAIT *, unsigned int*, const unsigned int, unsigned int);

int
tree_struct(__JTREE_EXPLAIT * __jtree_struct, __JTHREE_EXPLAIT_INFO * __JINFO, const unsigned int  __jlength) {

	register unsigned int  x, __JCOUNT_GENERIC;// faz trabalhos genéricos 
	register unsigned int  __jrand_init;  // numero aleatório da estrutura ativa
	register unsigned int  __jrand_out; // numero aleatório da estrutura passiva

	__JINFO->__JINFO_LENGTH =  __JINFO->__JINFO_INIT_COUT = __JINFO->__JINFO_OUT_COUT = __jlength;
	__JINFO->__JRECURSIVE = 0;

	for (x = 0, __JCOUNT_GENERIC = 0; x<__JINFO->__JINFO_LENGTH; x++)
	{
		(__jtree_struct + x)->IN = C_OPEN;
		(__jtree_struct + x)->OUT = C_OPEN;
		(__jtree_struct + x)->CLOSE = C_OPEN;
		(__jtree_struct + x)->FSIN = --__JCOUNT_GENERIC;
		(__jtree_struct + x)->FSOUT = --__JCOUNT_GENERIC;
		*(__JINFO->__JINFO_INIT + x) = x;
		*(__JINFO->__JINFO_OUT + x) = x;
	}

	srand(time(NULL));
	while (true)
	{
		if (!__JINFO->__JINFO_INIT_COUT && !__JINFO->__JINFO_OUT_COUT)
			break;
		else
		{
			do
			{
				do{
					__jrand_init = rand() % __JINFO->__JINFO_LENGTH;
					if (*(__JINFO->__JINFO_INIT + __jrand_init) == C_OFF)
						continue;
					else
						break;
				} while (true);

				do{
					__jrand_out = rand() % __JINFO->__JINFO_LENGTH;
					if (*(__JINFO->__JINFO_OUT + __jrand_out) == C_OFF)
						continue;
					else
						break;
				} while (true);

				if (__JINFO->__JINFO_INIT_COUT == 1 && __JINFO->__JINFO_OUT_COUT == 1)
					break;

				else if ((__jtree_struct + __jrand_out)->OUT == C_OPEN && __jrand_init != __jrand_out)
				{
					if (__jlength <= RECURSIVE_MAX)
					{
						if (!recursive_tree(__jtree_struct, &__JINFO->__JRECURSIVE, __jrand_init, __jrand_out))
							break;
					}
					else
						if (!jump_tree(__jtree_struct, &__JINFO->__JRECURSIVE, __jrand_init, __jrand_out))
							break;
				}
			} while (true);

			if (!__JINFO->__JTREE_EXPLAIT_CIRCUIT && __JINFO->__JINFO_INIT_COUT == 1 && __JINFO->__JINFO_OUT_COUT == 1)
				__JNOTHING
			else
			{
				(__jtree_struct + __jrand_init)->IN = C_CLOSE;
				*(__JINFO->__JINFO_INIT + __jrand_init) = C_OFF;


				(__jtree_struct + __jrand_out)->OUT = C_CLOSE;
				*(__JINFO->__JINFO_OUT + __jrand_out) = C_OFF;


				(__jtree_struct + __jrand_init)->FSIN = __jrand_out;
				(__jtree_struct + __jrand_out)->FSOUT = __jrand_init;

				if ((__jtree_struct + __jrand_init)->IN == C_CLOSE && (__jtree_struct + __jrand_init)->OUT == C_CLOSE)
					(__jtree_struct + __jrand_init)->CLOSE = C_CLOSE;

				if ((__jtree_struct + __jrand_out)->IN == C_CLOSE && (__jtree_struct + __jrand_out)->OUT == C_CLOSE)
					(__jtree_struct + __jrand_out)->CLOSE = C_CLOSE;
			}

			(__JINFO->__JINFO_INIT_COUT)--;
			(__JINFO->__JINFO_OUT_COUT)--;
		}
	}
	return 0;
}

static int
recursive_tree(__JTREE_EXPLAIT * __jtree_struct, unsigned int * __JRECURSIVE, const unsigned int  __jinit, unsigned int __jnext)
{
	/* Acima de 199.999 ligamentos começa a dar problema com o recebimento do sinal SIGSEGV
	*
	* SIGSEGV é o nome de um sinal conhecido por um processo informático
	* emitido quando acontece uma referência inválida de memória (segmentation fault)
	*  em sistemas operativos POSIX.
	*/
	(*__JRECURSIVE)++;

	if (__jinit == (__jtree_struct + __jnext)->FSIN)
		return 1;
	else if ((__jtree_struct + __jnext)->IN == C_CLOSE)
	{
		if (recursive_tree(__jtree_struct, __JRECURSIVE, __jinit, (__jtree_struct + __jnext)->FSIN))
			return 1;
		else return 0;
	}
	else
		return 0;
}

static int
jump_tree(__JTREE_EXPLAIT * __jtree_struct, unsigned int * __JRECURSIVE, const unsigned int  __jinit, unsigned int __jnext)
{
	_Jump_tree:
		(*__JRECURSIVE)++;

		if (__jinit == (__jtree_struct + __jnext)->FSIN)
			return 1;
		else if ((__jtree_struct + __jnext)->IN == C_CLOSE)
		{
			__jnext = (__jtree_struct + __jnext)->FSIN;
			goto _Jump_tree;
		}
		return 0;
}