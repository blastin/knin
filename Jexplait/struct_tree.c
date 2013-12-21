#include "tree.h"
#include <time.h>


static int 
recursive_tree(__JTREE_EXPLAIT *,const int,int);

int 
tree_struct(__JTREE_EXPLAIT * __jtree_struct ,const int __jlength,int * __JINFO_INIT,int * __JINFO_NEXT) {
   
    srand (time(NULL));
    register int x;
    int __JCOUNT_GENERIC; // faz trabalhos genéricos 
    int __jrand_init;  // numero aleatório da estrutura passiva
    int __jrand___jnext; // numero aleatório da estrutura ativa
    short int slot_open;
    
    for(x=0,__JCOUNT_GENERIC=0;x<__jlength;x++)
    {
        (__jtree_struct+x)->IN = C_OPEN;
        (__jtree_struct+x)->OUT = C_OPEN;
        (__jtree_struct+x)->CLOSE = C_OPEN;
        (__jtree_struct+x)->FSIN = --__JCOUNT_GENERIC;
        (__jtree_struct+x)->FSOUT = --__JCOUNT_GENERIC;
         *(__JINFO_INIT+x) = x;
         *(__JINFO_NEXT+x) = x;
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
                    if( *(__JINFO_INIT+__jrand_init) == C_OFF)
                        continue;
                   
                __jrand___jnext = rand()%__jlength;
                    if( *(__JINFO_NEXT+__jrand___jnext) == C_OFF)
                        continue;
                  
                if ((__jtree_struct+__jrand___jnext)->CLOSE == C_OPEN)
                {
                    //TODO: Patch
                    for(x=0,__JCOUNT_GENERIC=0;x<__jlength;x++)
                    {
                        if((__jtree_struct+x)->OUT == C_OPEN)
                        {
                            slot_open = x;
                            __JCOUNT_GENERIC++;
                        }
                    }
                    if(__JCOUNT_GENERIC == 1)
                    {
                        __jrand___jnext = slot_open;
                        break;
                    }
                    //FIM
                    
                    if ((__jtree_struct+__jrand___jnext)->OUT == C_OPEN && __jrand_init != __jrand___jnext)
                        if(!recursive_tree(__jtree_struct,__jrand_init,__jrand___jnext))
                                break;    
                }
            }while(true);

            (__jtree_struct+__jrand_init)->IN = C_CLOSE;
             *(__JINFO_INIT+__jrand_init) = C_OFF;
            
            (__jtree_struct+__jrand___jnext)->OUT = C_CLOSE;
             *(__JINFO_NEXT+__jrand___jnext) = C_OFF;
            
            (__jtree_struct+__jrand_init)->FSIN = __jrand___jnext;
            (__jtree_struct+__jrand___jnext)->FSOUT = __jrand_init;
            
            if ((__jtree_struct+__jrand_init)->IN == C_CLOSE && (__jtree_struct+__jrand_init)->OUT == C_CLOSE )
                (__jtree_struct+__jrand_init)->CLOSE = C_CLOSE;
               
            if ((__jtree_struct+__jrand___jnext)->IN == C_CLOSE && (__jtree_struct+__jrand___jnext)->OUT == C_CLOSE )
                (__jtree_struct+__jrand___jnext)->CLOSE = C_CLOSE;
        }
        
    };
    
    return 0;
}

static int 
recursive_tree(__JTREE_EXPLAIT * __jtree_struct,const int __jinit,int __jnext)
{
    if(__jinit == (__jtree_struct+__jnext)->FSIN)
        return 1;
    else if((__jtree_struct+__jnext)->IN == C_CLOSE)
    {
        if(recursive_tree(__jtree_struct,__jinit,(__jtree_struct+__jnext)->FSIN))
            return 1;
        else return 0;
    }
    else
        return 0;
    
}