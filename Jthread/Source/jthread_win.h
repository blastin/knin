/* 
 * File:   thread_j.h
 * Author: jeff
 *
 * Created on 7 de Abril de 2013, 11:56
 */
#include <setjmp.h>
#include <ucontext.h>

#ifndef __THREAD_J_H
	#define	__THREAD_J_H
	
	typedef struct jthread_ {
    
		long  int ID_THREAD;
    
    
	}__jthread_t;

	enum __thread_j_data_enum {
	__THREAD_UNLOCK,__THREAD_LOCK,__THREAD_HERANCE,__THREAD_SIGNAL_RETURN,__THREAD_VOID,SIGNAL_SETJMP_JOIN_RETURN

	};

	enum __bit_jthread_wait_enum 
	{
		__JUMP_NOWAIT=0XAB,__JUMP_WAIT=0XBA,
		__JUMP_UNLOCK=0XAC,__JUMP_LOCK=0XCA,
		__JUMP_SETJMP=0XAD,__JUMP_SETJUMP_RELOAD = 0XDA,
		__JUMP_NOSYNCRONIZE=0XAE,__JUMP_SYNCRONIZE=0XEA,
		__JUMP_ATTR=0x2F,
		__JUMP_OPEN = 0X3F,
		__JUMP_USAGE= 0X4F,
	};

	typedef struct struct_jump_open_memory{
		int jump_open;
		void (*jthread_pointer_function)(void*);
		unsigned int jump_in_thread;
	}__jump_open_memory;

	typedef struct struct_attr_mutex
	{
		unsigned int bit_thread_status;
		unsigned int syncronize_jump_ID;
		unsigned int bit_syncronize_jmp_buf;
		__jump_open_memory * jump_open_memory;


	}__attr_mutex;


	typedef struct jump_jthread_struct{

	jmp_buf jthread_jump;
	}__jump_jthread_LIFO;

	typedef struct syncronize_IDS_struct
	{
		__jump_jthread_LIFO  * OBJECTS;
		unsigned long int JUMPS_IN_OBJECTS;
	}__syncronize_thread;

	typedef struct jthread_struct
	{
    
		long int ID;
		void (*jthread_pointer_function)(void*);
		void * thread_data;
		enum __thread_j_data_enum status_thread_function;
                int bit_syncronize;
		
	}__jthread_LIFO;


	typedef struct  struct_getid_Jthread{

		void (*jthread_pointer_function_call)(void*);

	}__getid_JThread;
	/*PUBLIC*/
	int     __thread_j_create(__jthread_t *,__attr_mutex * ,void (*)(void*),void *);
	//void    jthread_multithread(int);
	void   __jthread_join(void);
	void __jthread_base(__attr_mutex*);
	void   __jthread_signal_cond_wait(int);
	void   __jthread_unlock(__attr_mutex *);
	void   __jthread__attr_mutex(__attr_mutex *);
        void   __jthread__attr_mutex_wait(__attr_mutex*,__attr_mutex* ); /* __attr_mutex_wait , __attr_mutex_*/
	
	 //void   jthread_exit(void); // FAZER

	//#define jthread(function) void * jthread_ ## function(void)	

#endif	/* THREAD_J_H */

