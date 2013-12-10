#include "module.h"
#include "data_.h"
#include "Thread.h"
#include "module_data.h"
#include <iostream>
#include <cmath>
#include <cstdlib>
extern module * module_object;
extern attr_mutex mutex_var; 
extern attr_mutex mutex_wait;


//jthread_mutex module_left,module_right,module_random;

unsigned short int module_LIFO(void)
{
	

    register long int length_tpp_t = length_module(module_object->module_tpp);
	std::cout << "length_module : " << length_tpp_t << std::endl;
    for(;length_tpp_t >=module_object->desloc;length_tpp_t--)
	{
		*(module_object->module_tpp+length_tpp_t) = *(module_object->module_tpp+length_tpp_t - 1);
        *(module_object->module_tpp+length_tpp_t+module_object->desloc) = module_object->new_module;
	} 
	long int x;
	for(x=0;x<=length_tpp_t;x++)
		std::cout << "< " << *(module_object->module_tpp+x) << std::endl;
	return 0 ;
    

}

syncronize_status module_syncronize_status(void)
{
    long int module_length = length_module(module_object->module_tpp);
    
    if(*module_object->module_tpp)
    {
        if(module_object->new_module < *module_object->module_tpp )
           module_object->desloc = 0;
          
        else if(module_object->new_module > module_length)
            module_object->desloc = module_length ;
         
        else
        {
			std::cout << "syncronize on:" << std::endl;
            module_object->syn_status = syncronize_module_UNLOCK;
            return module_object->syn_status;
        }
        
    }
    module_LIFO();
    
    module_object->syn_status = syncronize_module_LOCK;
    return module_object->syn_status;
    
}


void  module_syncronize_left(void * thread_data)
{
    
    jthread_t * thread_module_syncronize_left = ( jthread_t *)thread_data;
	std::cout << "Thread[module_syncronize_left]: " << thread_module_syncronize_left->ID_THREAD << std::endl;
	while(1){
	 jthread_lock(&mutex_var);
		  std::cout << "mutex syncronize left" << std::endl;
		  jthread_unlock(&mutex_var);
	}
    
    
}

void module_syncronize_right(void * thread_data)
{
     jthread_t * thread_module_syncronize_right = ( jthread_t *)thread_data;
	 std::cout << "Thread[module_syncronize_right]: " << thread_module_syncronize_right->ID_THREAD << std::endl;
	 while(1){
	 jthread_lock(&mutex_var);
		  std::cout << "mutex syncroniz righte" << std::endl;
		  jthread_unlock(&mutex_var);
	 }
}

void module_syncronize_random(void * thread_data)
{
     jthread_t * thread_module_syncronize_random = ( jthread_t *)thread_data;
	 std::cout << "Thread[module_syncronize_random]: " << thread_module_syncronize_random->ID_THREAD << std::endl;
	 while(1){
	 jthread_lock(&mutex_var);
		  std::cout << "mutex syncronizerandom" << std::endl;
		  jthread_unlock(&mutex_var);
	 }
}


void module_syncronize(void * thread_data)
{
     jthread_t  * thread_module_syncronize = ( jthread_t *)thread_data;
     std::cout << "Thread[module_syncronize]: " << thread_module_syncronize->ID_THREAD << std::endl;
     while(true) /*FIX-ME*/
     {
		  jthread_lock(&mutex_var);
		  std::cout << "mutex syncronize" << std::endl;
		  jthread_unlock(&mutex_var);
		  //exit(0);
         //long double x,y;
         //std::cout << "Insira os dois poantos da intensidade: ";
         //std::cin >> x >> y;
         //module_object->new_module = sqrt(pow(x,2.0)+pow(y,2.0));
       
         //thread_wait(&mutex_wait);
         //module_LIFO();
     }
     
}
