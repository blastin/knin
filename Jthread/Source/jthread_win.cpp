
#include <cstdlib>
#include <time.h> 
#include "jthread.h"
#include <iostream>



//#include <signal.h>
//static void __alloc_jump_syncronize_jthread(__attr_mutex *);
//static void __alloc_jumps_save_jthread(unsigned int);

static __jthread_LIFO __jthread_LIFO_standard;
static __jthread_LIFO *  __jthread_LIFO_t;

static __jump_jthread_LIFO _jump_jthread_LIFO_standard;
static __jump_open_memory  __jump_open_memory_standard;

static __syncronize_thread *__jthread_syncronizes_IDS,__jthread_syncronize_IDS_standard; 
static int __jthread_syncronizes_IDS_objects = 0;/* ID para cada syncronize guardando na var mutex*/

jmp_buf __jmp_jthread_standard,__jmp_join;


__getid_JThread __ID_JTHREAD_MAIN;

static int thread_exit_bit = 1;
static long int _IDS_JTHREADS_ = 0; /* número em ordem criado para cada thread criada*/
static unsigned int __jthread_LIFO_t_objects = 0; /* Neste caso o '0' est� representando posi��o da primeira thread em LIFO*/
static unsigned int __jthread_LIFO_ID = 1; /* Quantidade de thread aberta */



#define __jthread_function(number_thread_random) ((__jthread_LIFO_t+number_thread_random)->jthread_pointer_function)
#define __JTHREAD_SYID __jthread_syncronizes_IDS


int __thread_j_create(__jthread_t * __jthread,__attr_mutex * __attr_jthread,void (*__thread_function)(void*),void * __jthread_data)
{
	if(!__jthread_LIFO_t_objects)
	{
		__jthread_LIFO_t = (__jthread_LIFO *) malloc(1 * sizeof(__jthread_LIFO_standard));

		if(__attr_jthread != NULL)
		{
			__JTHREAD_SYID->OBJECTS = (__jump_jthread_LIFO*)malloc(1*sizeof(_jump_jthread_LIFO_standard));
			__attr_jthread->jump_open_memory = (__jump_open_memory *)malloc(1*sizeof(__jump_open_memory_standard));
			__attr_jthread->jump_open_memory->jump_open = __JUMP_OPEN;
			__attr_jthread->jump_open_memory->jthread_pointer_function = __thread_function;

		}
		//signal_statics();
	}

	else
	{
		__jthread_LIFO_t = (__jthread_LIFO *) realloc(__jthread_LIFO_t,__jthread_LIFO_ID * sizeof(__jthread_LIFO_standard));
		__attr_jthread->jump_open_memory = (__jump_open_memory *)realloc(__attr_jthread->jump_open_memory,__jthread_LIFO_ID*sizeof(__jump_open_memory_standard));
		(__attr_jthread->jump_open_memory+__jthread_LIFO_t_objects)->jump_open = __JUMP_OPEN;
		(__attr_jthread->jump_open_memory+__jthread_LIFO_t_objects)->jthread_pointer_function = __thread_function;
		__JTHREAD_SYID->OBJECTS = (__jump_jthread_LIFO*)realloc\
			(__JTHREAD_SYID->OBJECTS,__jthread_LIFO_ID*sizeof(_jump_jthread_LIFO_standard));

	}
	__jthread->ID_THREAD = _IDS_JTHREADS_;
   (__jthread_LIFO_t+__jthread_LIFO_t_objects)->ID = _IDS_JTHREADS_++;
   (__jthread_LIFO_t+__jthread_LIFO_t_objects)->jthread_pointer_function = __thread_function ;
   (__jthread_LIFO_t+__jthread_LIFO_t_objects)->thread_data = __jthread_data;
   (__jthread_LIFO_t+__jthread_LIFO_t_objects)->status_thread_function = __THREAD_VOID;
   (__jthread_LIFO_t+__jthread_LIFO_t_objects)->bit_syncronize = __JUMP_NOSYNCRONIZE;
	__jthread_LIFO_ID++;
	__jthread_LIFO_t_objects++;

    return 0;
    
}


/*static void signal_statics(void)
{
	
	signal(SIGNAL_SETJMP_JOIN_RETURN,jthread_lock);
}

/*void * jthread_multithread(long int  ID_THREAD)
{
	unsigned long int  THREAD_length;
	for(THREAD_length=0;THREAD_length < __jthread_LIFO_ID ; THREAD_length++)
	{
		if(ID_THREAD == (__jthread_LIFO_t+THREAD_length)->thread->ID)
		{
			(__jthread_LIFO_t+THREAD_length)->thread->status_thread_function = THREAD_HERANCE;
			break;
		}
	}
	while((__jthread_LIFO_t+THREAD_length)->thread->status_thread_function == THREAD_HERANCE)
	{
		jthread(join);
	}
	return (void*) NULL;
    
}*/

/*static void __alloc_jump_syncronize_jthread(void)
{
		__JTHREAD_SYID = (__syncronize_thread *)realloc(__JTHREAD_SYID,(++__jthread_syncronizes_IDS_objects)*sizeof(__jthread_syncronize_IDS_standard));
		(__JTHREAD_SYID+ __jthread_syncronizes_IDS_objects)->JUMPS_IN_OBJECTS = 0;		
};*/

void __jthread_base(__attr_mutex * __attr_jthread)
{
	register unsigned int __set_bit = 0,__set_bit2 = 0;

	if(__attr_jthread->bit_thread_status == __JUMP_WAIT)
	  {
		 ;
         //
	  }

	else if (__attr_jthread->bit_thread_status == __JUMP_SETJUMP_RELOAD)
	{
		for(__set_bit=0;__set_bit < __jthread_LIFO_t_objects ; __set_bit++)
		{
			if(__ID_JTHREAD_MAIN.jthread_pointer_function_call == (__jthread_LIFO_t+__set_bit)->jthread_pointer_function)
			{
				for(__set_bit2 = 0;__set_bit2 <=__jthread_LIFO_t_objects;__set_bit2++)
				{
					if((__attr_jthread->jump_open_memory +__set_bit2)->jump_open == __JUMP_OPEN)
					{
						(__attr_jthread->jump_open_memory +__set_bit2)->jump_open = __JUMP_USAGE;
						
						(__jthread_LIFO_t+__set_bit)->bit_syncronize = __JUMP_SYNCRONIZE;
						
						if(!setjmp(*(jmp_buf*)((__JTHREAD_SYID+__attr_jthread->syncronize_jump_ID)->OBJECTS\
[(__jthread_syncronizes_IDS+__attr_jthread->syncronize_jump_ID)->JUMPS_IN_OBJECTS++].jthread_jump)))	
						{
							if((__jthread_syncronizes_IDS+__attr_jthread->syncronize_jump_ID)->JUMPS_IN_OBJECTS == __jthread_LIFO_t_objects)
							{
								__attr_jthread->bit_thread_status = __JUMP_LOCK;	
								goto _unlock;
							}

							else
								longjmp(__jmp_join,0);
						}
						else
							__set_bit2 = __set_bit = __jthread_LIFO_t_objects;
					}	
				}
			}
		}
	
	}
	else
		{
			if(__attr_jthread->bit_thread_status == __JUMP_UNLOCK || __attr_jthread->bit_thread_status == __JUMP_WAIT  )
			{
				_unlock:
				unsigned int __random_jump_objects;
				do 
				{
					__random_jump_objects = rand() % (__jthread_syncronizes_IDS+__attr_jthread->syncronize_jump_ID)->JUMPS_IN_OBJECTS;
				}while(__attr_jthread->bit_thread_status == __JUMP_WAIT);
				__attr_jthread->bit_thread_status = __JUMP_LOCK;	
				longjmp(*(jmp_buf*)((__JTHREAD_SYID+__attr_jthread->syncronize_jump_ID)->OBJECTS[__random_jump_objects].jthread_jump),1); 
			}

		} 
}

void __jthread_unlock(__attr_mutex * __attr_jthread)
{
	__attr_jthread->bit_thread_status = __JUMP_UNLOCK;

}

void __jthread_signal_cond_wait(__attr_mutex * __attr_jthread)
{
	__attr_jthread->bit_thread_status = __JUMP_NOWAIT;
}

void __jthread__attr_mutex(__attr_mutex * __attr_jthread)
{
	static short int __mutex_objects = 0;

	if(!__mutex_objects++)
	{
		__JTHREAD_SYID = (__syncronize_thread *)malloc(1*sizeof(__jthread_syncronize_IDS_standard));
		__JTHREAD_SYID->JUMPS_IN_OBJECTS = 0;		
		
	}

	else
	{
	__JTHREAD_SYID = (__syncronize_thread *)realloc\
		(__JTHREAD_SYID,(++__jthread_syncronizes_IDS_objects)*sizeof(__jthread_syncronize_IDS_standard));
		(__JTHREAD_SYID+ __jthread_syncronizes_IDS_objects)->JUMPS_IN_OBJECTS = 0;		
	}

	__attr_jthread->bit_thread_status = __JUMP_SETJUMP_RELOAD;
	__attr_jthread->bit_syncronize_jmp_buf = __JUMP_ATTR;
	__attr_jthread->syncronize_jump_ID = __jthread_syncronizes_IDS_objects;

}

void __jthread__attr_mutex_wait(__attr_mutex* __attr_jthread_mutex_wait,__attr_mutex* __attr_jthread_mutex)
{
	if(__attr_jthread_mutex->bit_syncronize_jmp_buf == __JUMP_ATTR)
	{
		__attr_jthread_mutex_wait->syncronize_jump_ID = __attr_jthread_mutex->syncronize_jump_ID;
		__attr_jthread_mutex_wait->bit_thread_status =__JUMP_WAIT;
	}

	else
	{
		std::cout << "Error: variavel mutex nao foi atribuida" << std::endl;
		std::cin.get();
		exit(1);
	}
	
}

void __jthread_join(void)
{
	 setjmp(__jmp_join);
   
    unsigned int __number_thread_random_temp = 0;

	//jthread_status_global.thread_exit_bit = 1;

    while(thread_exit_bit)
    {
		 do 
		 { 
			 __number_thread_random_temp = rand() % __jthread_LIFO_t_objects + 0;
		 
		 } while((__jthread_LIFO_t+__number_thread_random_temp)->bit_syncronize == __JUMP_SYNCRONIZE);
	
		__ID_JTHREAD_MAIN.jthread_pointer_function_call = ((__jthread_LIFO_t+__number_thread_random_temp)->jthread_pointer_function);

		__jthread_function(__number_thread_random_temp)((__jthread_LIFO_t+__number_thread_random_temp)->thread_data);

		
    }
}




/*void jthread_exit()
{
	thread_exit_bit = 0;
	//JTHREAD EXIT 
	// Aqui acessamos LIFO_JUMP :
	// 1 : Retiramos jump_objects desejado
	// 2 :  reorganizamos a pilha
    //jthread_status_global.thread_exit_bit =0;
    return (void*) NULL;
}*/

