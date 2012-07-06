OBJ=

main=$( grep '^[^#*]' make_disp | grep '^[mM]' | cut -d : -f 2) #puxa o nome do arquivo que tenha a função main

make_disp_object=$(grep '^[^#*]' make_disp | grep '^S' | cut -d : -f 2 | sed 's/c$/o/') #puxa todos as sources e coloca final .o

OPER=$(grep '^[^#*]' make_disp | grep '^[Aa]' | cut -d : -f 2- | grep '^[^0]' | cut -d : -f 2) # puxa todos os otimizadores com flag : 1


if [ -d "_obj" ]
then
	echo -ne "Pasta jsá criada\n\n"

	for x in "$(ls _obj)"
		do
			OBJ+=$x		
		done
	

	[ "$OBJ" =  "$make_disp_object" ] &&  echo -ne "Arquivos do objeto já compilados\n" || 
		{
		echo -ne "Arquivos do objeto ainda não foram compilados\n"

		$(gcc -c $(grep '^[^#*]' make_disp | grep  '^[Ss]' | cut -d : -f 2))

		$(mv *.o ./_obj/)

	}

	
	

else
	echo -ne "Pasta inexistente\n\n"
	$(mkdir _obj)
fi




$(gcc $OPER $MAIN -lz  ./_obj/* -o _knin)

echo -ne "gcc $OPER $main -lz  * $(ls ./_obj/) -o _knin\n\n"
