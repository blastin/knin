#include "tree.h"
#include <time.h>

static int 
recursive_tree(__JTREE_EXPLAIT *,__JTHREE_EXPLAIT_INFO*,const unsigned int ,unsigned int );

int 
tree_struct(__JTREE_EXPLAIT * __jtree_struct, __JTHREE_EXPLAIT_INFO * __JINFO, const unsigned int  __jlength) {
   
    register unsigned int  x,__JCOUNT_GENERIC;// faz trabalhos genéricos 
    register int  __jrand_init;  // numero aleatório da estrutura ativa
    register int  __jrand_out; // numero aleatório da estrutura passiva
    
    __JINFO->__JINFO_INIT_COUT = __JINFO->__JINFO_OUT_COUT =  __jlength;
    __JINFO->__JRECURSIVE = 0;
    
    for(x=0,__JCOUNT_GENERIC=0;x<__jlength;x++)
    {
         (__jtree_struct+x)->IN = C_OPEN;
         (__jtree_struct+x)->OUT = C_OPEN;
         (__jtree_struct+x)->CLOSE = C_OPEN;
         (__jtree_struct+x)->FSIN = --__JCOUNT_GENERIC;
         (__jtree_struct+x)->FSOUT = --__JCOUNT_GENERIC;
         *(__JINFO->__JINFO_INIT+x) = x;
         *(__JINFO->__JINFO_OUT+x) = x;
    }
    srand (time(NULL));
    while(true)
    {
        if(! __JINFO->__JINFO_INIT_COUT && ! __JINFO->__JINFO_OUT_COUT)
            break; 
        else 
        {
            do
            {
                do{
                  __jrand_init  = rand()%__jlength;
                  if( *(__JINFO->__JINFO_INIT+__jrand_init) == C_OFF)
                        continue;
                  else 
                      break;
                }while(true);
                
                do{
                  __jrand_out = rand()%__jlength;
                  if( *(__JINFO->__JINFO_OUT+ __jrand_out) == C_OFF)
                        continue;
                  else 
                      break;
                }while(true);
                
                  if ((__jtree_struct+__jrand_out)->CLOSE == C_OPEN)
                  {               
                    if(__JINFO->__JINFO_INIT_COUT == 1 && __JINFO->__JINFO_OUT_COUT == 1 )
                        break;
                    
                    else if ((__jtree_struct+__jrand_out)->OUT == C_OPEN && __jrand_init != __jrand_out)
                        if(!recursive_tree(__jtree_struct,__JINFO,__jrand_init,__jrand_out))
                                break;
                 }
            }while(true);

             (__jtree_struct+__jrand_init)->IN = C_CLOSE;
            *(__JINFO->__JINFO_INIT+__jrand_init) = C_OFF;
             (__JINFO->__JINFO_INIT_COUT)--; 
            
            (__jtree_struct+__jrand_out)->OUT = C_CLOSE;
           *(__JINFO->__JINFO_OUT+ __jrand_out) = C_OFF;
            (__JINFO->__JINFO_OUT_COUT)--;
            
            (__jtree_struct+__jrand_init)->FSIN = __jrand_out;
            (__jtree_struct+__jrand_out)->FSOUT = __jrand_init;
            
            if ((__jtree_struct+__jrand_init)->IN == C_CLOSE && (__jtree_struct+__jrand_init)->OUT == C_CLOSE )
                (__jtree_struct+__jrand_init)->CLOSE = C_CLOSE;
               
            if ((__jtree_struct+__jrand_out)->IN == C_CLOSE && (__jtree_struct+__jrand_out)->OUT == C_CLOSE )
                (__jtree_struct+__jrand_out)->CLOSE = C_CLOSE;
        }  
    };
    return 0;
}

static int 
recursive_tree(__JTREE_EXPLAIT * __jtree_struct,__JTHREE_EXPLAIT_INFO * __JINFO,const unsigned int  __jinit,unsigned int __jnext)
{
    (__JINFO->__JRECURSIVE)++;
    if(__jinit == (__jtree_struct+__jnext)->FSIN)
        return 1;
    else if((__jtree_struct+__jnext)->IN == C_CLOSE)
    {
        if(recursive_tree(__jtree_struct,__JINFO,__jinit,(__jtree_struct+__jnext)->FSIN))
            return 1;
        else return 0;
    }
    else
        return 0;
}