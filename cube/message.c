#include "header.h"


int putchar(int n){

    return write(1,&n,1);
                                
}int  getchar(void){
    
    char tmp;
    
   return (read(0,&tmp,1) == 1) ?  (unsigned char) tmp : EOF;
   
    
}int strcmp(char * direction,char * offset){
    
    //message("entre strcmp\n");
    
    for(;*direction++ == *offset++;);
    
    return *direction - *offset;
    
}int length(const char * message){
    int x;
    for(x=0;*message++;x++);
    return x;


}int message(const char * msg){
    
    char * error_tmp = "Error : pointeiro nulo\n";
    
    if (msg == NULL) return write(1,error_tmp,length(error_tmp));
    else  return write(1,msg,length(msg));
         
    
}
