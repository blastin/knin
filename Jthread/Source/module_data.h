/* 
 * File:   module_data.h
 * Author: jeff
 *
 * Created on 6 de Abril de 2013, 23:58
 */

#ifndef MODULE_DATA_H
	#define MODULE_DATA_H
	 enum syncronize_module_data{
		syncronize_module_UNLOCK,
		syncronize_module_LOCK,
    
	};

	struct module_struct{
    
		long double * module_tpp;
		long int desloc;
		long double new_module;
		enum  syncronize_module_data syn_status;
    
		long int ID_module;
	};


	typedef enum syncronize_module_data syncronize_status;
	typedef struct module_struct module;

#endif