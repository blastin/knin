#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
#include <string.h>
#include <time.h>

int main(int argc, char** argv) {

	unsigned int MAX_, FILECHECK_, x, count1, count2;
	double time_end;

	__JTREE_EXPLAIT * struct_base;
	__JTHREE_EXPLAIT_INFO info;

	FILE *file = NULL;
	clock_t time_over, time_init;

	if (argc>1)
	{
		MAX_ = atoi(*(argv + 1));

		if (*(argv + 2) != NULL)
		{
			printf("%s\n", *(argv + 2));
			FILECHECK_ = strcmp(*(argv + 2), "FILE");
		}
		else
			FILECHECK_ = 1;

		if (*(argv + 3) != NULL)
		{
			if (!strcmp(*(argv + 3), "OPEN"))
				info.__JTREE_EXPLAIT_CIRCUIT = C_OPEN; // Circuito aberto|fechado;
			else if (!strcmp(*(argv + 3), "CLOSE"))
				info.__JTREE_EXPLAIT_CIRCUIT = C_CLOSE; // Circuito aberto|fechado;
			else
				info.__JTREE_EXPLAIT_CIRCUIT = C_OPEN; // Circuito aberto|fechado;
		}
	}

	else
		MAX_ = 10;

	info.__JINFO_INIT = (int*)calloc(MAX_, sizeof(*info.__JINFO_INIT));
	info.__JINFO_OUT = (int*)calloc(MAX_, sizeof(*info.__JINFO_OUT));
	struct_base = (__JTREE_EXPLAIT *)calloc(MAX_, sizeof(*struct_base));

	if (!FILECHECK_){
		//file = fopen("return.txt", "w");
		if (!fopen_s(&file, "return.txt", "w"))
			printf("Iniciando conex�es ....\n");
		else
		{
			fprintf(stdout, "Erro : N�o foi poss�vel criar o arquivo return.txt..!");
			return(EXIT_FAILURE);
		}
			
	}
	time_init = clock();
	tree_struct(struct_base, &info, MAX_);
	time_over = clock();
	time_end = ((double)time_over - time_init) / CLOCKS_PER_SEC;
	printf("Conex�o realizada com sucesso\n");

	if (!FILECHECK_)
	{
		fprintf(file, "Ser� conectado : %d struct utilizando o metodo %s\n", MAX_, (MAX_ < RECURSIVE_MAX) ? "RECURSIVE" : "JUMP");
		for (x = 0; x<MAX_; x++)
			fprintf(file, "Struct[%8.1d] >> %8.1d | Struct[%8.1d] << %8.1d | status:%s\n", x, struct_base[x].FSIN, x, struct_base[x].FSOUT, (struct_base[x].CLOSE) ? "fechada" : "aberta");

		fprintf(file, "Tempo total : %f segundos ou %f minutos ou %f horas\n", time_end, time_end / 60, time_end / (60 * 60));
		fprintf(file, "Foi necess�rio entrar %d vezes na fun��o recursiva\n", info.__JRECURSIVE);
	}

	else
	{
		fprintf(stdout, "Ser� conectado : %d struct utilizando o metodo %s\n", MAX_, (MAX_ < RECURSIVE_MAX) ? "RECURSIVE" : "JUMP");
		fprintf(stdout, "Tempo total : %f segundos ou %f minutos ou %f horas\n", time_end, time_end / 60, time_end / (60 * 60));
		fprintf(stdout, "Foi necess�rio entrar %d vezes na fun��o recursiva\n", info.__JRECURSIVE);
	}

	for (x = count1 = count2 = 0; x<MAX_; x++)
	{
		count1 += *(info.__JINFO_INIT + x);
		count2 += *(info.__JINFO_OUT + x);
	}

	if ((count1 + count2) == -(MAX_ * 2.0))
		printf("sucesso programa finalizado\n");

	if (!FILECHECK_)
		fclose(file);

	return (EXIT_SUCCESS);
}