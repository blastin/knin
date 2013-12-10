/* 
 * File:   module.h
 * Author: jeff
 *
 * Created on 6 de Abril de 2013, 23:39
 */

#include "module_data.h"
	unsigned short int module_LIFO(void);

	syncronize_status module_syncronize_status(void);


	void  module_syncronize_left(void *);
	void  module_syncronize_right(void *);
	void  module_syncronize_random(void *);
	void  module_syncronize(void *);

