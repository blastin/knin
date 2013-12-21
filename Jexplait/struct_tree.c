#include "tree.h"
#include <time.h>
#include <stdio.h>

static int 
recursive_tree(__JTREE_EXPLAIT *,__JTHREE_EXPLAIT_INFO*,const int ,int );

int 
tree_struct(__JTREE_EXPLAIT * __jtree_struct, __JTHREE_EXPLAIT_INFO * __JINFO, const int  __jlength) {
   
    srand (time(NULL));
    register int  x;
    int  __JCOUNT_GENERIC; // faz trabalhos genéricos 
    int  __jrand_init;  // numero aleatório da estrutura passiva
    int  __jrand_next; // numero aleatório da estrutura ativa
    
    __JINFO->__JINFO_INIT_COUT = __JINFO->__JINFO_NEXT_COUT =  __jlength;
    __JINFO->__JRECURSIVE = 0;
    
    for(x=0,__JCOUNT_GENERIC=0;x<__jlength;x++)
    {
         (__jtree_struct+x)->IN = C_OPEN;
         (__jtree_struct+x)->OUT = C_OPEN;
         (__jtree_struct+x)->CLOSE = C_OPEN;
         (__jtree_struct+x)->FSIN = --__JCOUNT_GENERIC;
         (__jtree_struct+x)->FSOUT = --__JCOUNT_GENERIC;
         *(__JINFO->__JINFO_INIT+x) = x;
         *(__JINFO->__JINFO_NEXT+x) = x;
        
    }
    
    while(true)
    {
        for(x=0,__JCOUNT_GENERIC=0;x < __jlength; x++)
            {
                if((__jtree_struct+x)->CLOSE == C_CLOSE)
                    ++__JCOUNT_GENERIC;
            }
        if(__JCOUNT_GENERIC == __jlength)    
            break;   
      
        else 
        {
            do
            {
                  __jrand_init  = rand()%__jlength;
                  if( *(__JINFO->__JINFO_INIT+__jrand_init) == C_OFF)
                        continue;
                   
                  __jrand_next = rand()%__jlength;
                  if( *(__JINFO->__JINFO_NEXT+ __jrand_next) == C_OFF)
                        continue;
                  
                  if ((__jtree_struct+__jrand_next)->CLOSE == C_OPEN)
                  {
                                        
                    if(__JINFO->__JINFO_INIT_COUT == 1 && __JINFO->__JINFO_NEXT_COUT == 1 )
                        break;
                    
                    else if ((__jtree_struct+__jrand_next)->OUT == C_OPEN && __jrand_init != __jrand_next)
                        if(!recursive_tree(__jtree_struct,__JINFO,__jrand_init,__jrand_next))
                                break;    
                 }
            }while(true);

            (__jtree_struct+__jrand_init)->IN = C_CLOSE;
             *(__JINFO->__JINFO_INIT+__jrand_init) = C_OFF;
             (__JINFO->__JINFO_INIT_COUT)--; 
            
            (__jtree_struct+__jrand_next)->OUT = C_CLOSE;
             *(__JINFO->__JINFO_NEXT+ __jrand_next) = C_OFF;
            (__JINFO->__JINFO_NEXT_COUT)--;
            
            (__jtree_struct+__jrand_init)->FSIN = __jrand_next;
            (__jtree_struct+__jrand_next)->FSOUT = __jrand_init;
            
            if ((__jtree_struct+__jrand_init)->IN == C_CLOSE && (__jtree_struct+__jrand_init)->OUT == C_CLOSE )
                (__jtree_struct+__jrand_init)->CLOSE = C_CLOSE;
               
            if ((__jtree_struct+__jrand_next)->IN == C_CLOSE && (__jtree_struct+__jrand_next)->OUT == C_CLOSE )
                (__jtree_struct+__jrand_next)->CLOSE = C_CLOSE;
        }
        
    };
    
    return 0;
}

static int 
recursive_tree(__JTREE_EXPLAIT * __jtree_struct,__JTHREE_EXPLAIT_INFO * __JINFO,const int  __jinit,int __jnext)
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