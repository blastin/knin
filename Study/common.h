/* 
 * File:   common.h
 * Author: jeff
 *
 * Created on 9 de Junho de 2012, 12:38
 */

#ifndef COMMON_H
#define	COMMON_H


#if (defined(__WIN32__) || defined(__WIN32) || defined(_WIN32) || \
defined(_WIN64)         || defined(_MSC_VER)|| defined(__BORLANDC__)) \
&& !defined(WIN32)
	#define WIN
	#include <conio.h>
	#include <Windows.h>
#elif defined(__GNUC__)
	#define GNU
	#include <ncurses.h>
	#include <unistd.h>
	#include <pthread.h>
#endif


#if defined(GNU) 
        static void *threadFunc(void *arg);
#elif defined(WIN)
        static void *threadFunc(void); /*TODO : trabalhar com CreatThread em windows*/
#endif 

#define _TIME_SLEEP (1 << 1)

typedef enum {
    False,True
    
}boolean;


boolean win_mode(void);//modo windows
boolean nix_mode(void);//modo nix





#endif	/* COMMON_H */

