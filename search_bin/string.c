#include "common.h"
#include "string.h"

int strcomp(char *s,char *t){
    
    printf("%s==%s\n",s,t);
    
    //sleep(2);
    
   for(;*s ==*t;s++,t++){
           
        if(*s == '\0') break;
        
    }
    //printf("value %d\n",*s-*t);
    return *s-*t;
    
	
}void strcopy(char * s, char *t){
        while((*s++=*t++))
	;
}int strncomp(char *s,char *t,int n){
    
//printf("%c==%c\n",*s,*t);
    
    for(;--n && *s == *t;s++,t++)
        ;
    //printf("n:%d\t *s:%c\t *t:%c\n",(n ? 1 : 0),*s,*t);
    //printf("n:%d\t *s:%c\t *t:%c\n",(n ? 1 : 0),*s,*t);
    return *s - *t;
    
}int length(char * s){
    
    int temp;
    
    for(temp=0;*s++;)
        temp++;
    
    return temp;
    
}


