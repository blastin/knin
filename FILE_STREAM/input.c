//      input.c
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
#include "common.h"
#include <stdlib.h>
#include <unistd.h>
#include "input.h"


int main(int argc, char **argv)
{
	/*char * algumacoisa = (char*)malloc(sizeof(char) *15);
	sinput(algumacoisa);
	
	return 0;*/
	char * file_stream_write = (char*) malloc(sizeof(char) * CHAR_TEXT);
	
	user_sd * usuario = (user_sd*) malloc(sizeof(user_sd)*1);
	
	usuario->nick_name = (char*) malloc(sizeof(char) * 15);
	
	//strcopy(usuario->nick_name,"jeff");
	
	FILE * fpinput,* flag_file;
	int boolean = True,flag=0,offset_nick;
	printf("FILE STREAM ....\n");
	printf("insira um nick\n");
	scanf("%s",usuario->nick_name);
	printf("bem vindo %s\n",usuario->nick_name);
	
	while(boolean){
		
		offset_nick = 0;
		printf("%s : ",(*usuario).nick_name);
		//fscanf(stdin,"%s",file_stream_write);
		sinput(file_stream_write);
		
		if(*file_stream_write != 0x1b){
			//sleep(1);
			
			while(flag == FLAG_LOCK || flag == FLAG_WAIT){
				printf("esperando flag\n");
				flag_file = fopen(FLAG_FILE_STATUS ,"r");
				flag = getc(flag_file);
				fclose(flag_file);
				sleep(2);
			}
			
			printf("abrindo flag_file\n");
			flag_file = fopen(FLAG_FILE_STATUS ,"w");
			putc(FLAG_WAIT,flag_file);
			fclose(flag_file);
			
			
			fpinput= fopen(FP_INPUT,"a");
			
			while(*(usuario->nick_name+offset_nick))
				putc(~*(usuario->nick_name+offset_nick++),fpinput);
			putc(~':',fpinput);
			putc(~' ',fpinput);
			while(*file_stream_write)
				putc(~*file_stream_write++,fpinput);
				
			putc(~'\n',fpinput);
			fclose(fpinput);
			
			flag_file = fopen(FLAG_FILE_STATUS,"w");
			putc(FLAG_LOCK,flag_file);
			fclose(flag_file);
			
			//sleep(2);	
			
			}
			
		else boolean = False;
		
		
		
	}
	
	
	return 0;
	
}static void strcopy(char * s, char * t){
	
	while((*s++ = *t++))
		;
}static int string_input(char * string){
	
	
	char * read_string = (char*)malloc(sizeof(char)*CHAR_TEXT);
	/*int n;*/
	read(fp_in,read_string,CHAR_TEXT);
	
	/*printf("lenghtline : %d\n",lenghtline(read_string));*/
	
	*(read_string+lenghtline(read_string)-1) = '\0';
	/*for(n=0;*read_string;read_string++,n++)
		printf("%c[%d]<%d> | ",*read_string,*read_string,n);*/
		
	
	strcopy(string,read_string);
	
	
	return 0;
	
}static int lenghtline(char * string){
	int line =0;
	while(*string++)
		line++;
	return line;
}
