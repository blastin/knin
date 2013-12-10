


#ifndef THREAD_J_H
	#define THREAD_J__H
	#include "jthread.h"
	#define jthread_attr_mutex __jthread__attr_mutex
	#define jthread_attr_mutex_wait __jthread__attr_mutex_wait
	#define jthread_wait __jthread_base
	#define jthread_lock __jthread_base
	#define jthread_unlock __jthread_unlock 
	#define thread_pointer (void(*)(void*))
	#define thread_j_create __thread_j_create
	#define jthread_create(thread,attr_mutex,function_thread,data) thread_j_create(thread,attr_mutex,thread_pointer(function_thread),data)
	#define attr_mutex __attr_mutex
	#define jthread_t __jthread_t
	#define jthread_join __jthread_join

#endif
