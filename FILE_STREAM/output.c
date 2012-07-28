//      output.c
//      
//      Copyright 2012 Jefferson <jeff@debian>
//      
//      This program is free software; you can redistribute it and/or modify
//      it under the terms of the GNU General Public License as published by
//      the Free Software Foundation; either version 2 of the License, or
//      (at your option) any later version.
//      
//      This program is distributed in the hope that it will be useful,
//      but WITHOUT ANY WARRANTY; without even the implied warranty of
//      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//      GNU General Public License for more details.
//      
//      You should have received a copy of the GNU General Public License
//      along with this program; if not, write to the Free Software
//      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//      MA 02110-1301, USA.


#include <stdio.h>
#include <unistd.h>
#include "common.h"
#include <stdlib.h>

#define ERROR_OPEN_FILE(string) \
	fprintf(stderr,"Error : cannot open file :" #string "\n");
	
int main(int argc, char **argv)
{
	
	char * _output = (char*) malloc(sizeof(char) * CHAR_TEXT) ;
	FILE * _fpout, * flag_file;


	_fpout =  fopen(FP_INPUT,"w");	
	fclose(_fpout);
			
	register int offset = 0;
	int flag;
	
	
	if((flag_file = fopen(FLAG_FILE_STATUS,"w")) == NULL){
		
		ERROR_OPEN_FILE(flag_file);
		
		return -1;
	}
	
	putc(FLAG_UNLOCK,flag_file);
	fclose(flag_file);
	sleep(5);
	
	while(True){
		
		
		flag_file = fopen(FLAG_FILE_STATUS,"r");
		flag = getc(flag_file);
		fclose(flag_file);
		
		if(flag == FLAG_LOCK){
			_fpout =  fopen(FP_INPUT,"r");	
			
		
			while(True){
				
				
				
				*(_output+offset) = getc(_fpout);
				
				if(*(_output+offset) == EOF)
					break;
					
				else if (*(_output+offset) == ~'\n'){
					putchar('\n');
				}
				
		#if ! defined(STRING_INPUT)
				else if(*(_output+offset) == ~'.')
					putchar(' ');
					
		#endif
				else
					putchar(~*(_output + offset));
				
				offset++;
			}
			
			fclose(_fpout);
			_fpout =  fopen(FP_INPUT,"w");	
			fclose(_fpout);
			
			flag_file = fopen(FLAG_FILE_STATUS,"w");			
			putc(FLAG_UNLOCK,flag_file);
			offset = 0;
			fclose(flag_file);
		
		}
		
	   sleep(4);
	}
	return 0;
}
