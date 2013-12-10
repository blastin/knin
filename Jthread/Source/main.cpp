/* 
 * File:   main.cpp
 * Author: jeff
 *
 * Created on 6 de Abril de 2013, 23:26
 */

#include <cstdlib>
#include <iostream>
#include <cmath>
#include <time.h>
#include "Thread.h"
#include "module.h"
#include "module_data.h"

module module_standard;
module * module_object = (module*)malloc(sizeof(module_standard)*1);

attr_mutex mutex_var;    
attr_mutex mutex_wait;

jthread_t jthread_standard;

int main(int argc, char** argv) {

	 /* initialize random seed: */
    srand (time(NULL));
    
//    long double x,y;
    long int xx; 
	int advance=0;
    
    module_object->module_tpp = (long double*)malloc(sizeof(long double)*1500000);

	for(xx=0;xx<1500000;xx++)
		*(module_object->module_tpp+xx) = 0;

    module_object->syn_status = syncronize_module_LOCK;
    jthread_t * module_jthread[4];

	
    jthread_attr_mutex(&mutex_var);
	jthread_attr_mutex_wait(&mutex_wait,&mutex_var);
	

	//std::cout << "algumacoisa:" << mutex_var.bit_thread_wait << std::endl; system("pause");exit(1);
    for(xx=0;xx < 4 ; xx++)
    {
        *(module_jthread+xx) = (jthread_t * ) malloc(sizeof(jthread_standard));        
    }
	jthread_create(*module_jthread,&mutex_var,module_syncronize_left,(void*)*(module_jthread+advance));
    *(module_jthread+advance++);
    jthread_create(*(module_jthread+advance),&mutex_var,module_syncronize_right,(void*)*(module_jthread+advance));
   *(module_jthread+advance++);
    jthread_create(*(module_jthread+advance),&mutex_var,module_syncronize_random,(void*)*(module_jthread+advance));
    *(module_jthread+advance++);
    jthread_create(*(module_jthread+advance),&mutex_var,module_syncronize,(void*)*(module_jthread+advance));
    

    while(true){
        
        //std::cout << "Insira os dois pontos da intensidade: ";
       // std::cin >> x >> y;
        
       //module_object->new_module = sqrt(pow(x,2.0)+pow(y,2.0));
        
      /*  if(module_syncronize_status())
           continue;*/
		jthread_join();
        
        
    }
   system("pause");
    return 0;
}

