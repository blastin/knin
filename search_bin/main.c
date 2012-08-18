/* 
 * File:   main.c
 * Author: jeff
 *
 * Created on 20 de Julho de 2012, 23:57
 */

#include "common.h"
#include "hot_key.h"
#include "string.h"
/*
 * 
 */

struct {
    int bit:3;
    
}_value;
int len(char *);
int main(int argc, char** argv) {
    
    FILE * key_t = fopen("files/hot_key.key","r");
    
    char   array_key[SEARCH_KEY_SIZE_T_DOWN];
    char * search_key = "39ASJID";
   
    int x = 1;
    int y;
    /*printf("%d\n",((x && y) || (!x && !y)));
    printf("%d\n",((x && y) || !(x+y)));
    printf("%d\n",((!(!x && !x)) || !(x || y)));*/
    //for(y=0;y < 17;y++){
    //_value.bit = y;
    //printf("y[%2d]\t%3.1d\n",y,_value.bit);
    //}
    printf("value of right is : %d\n",SEARCH_KEY_SIZE_T_RIGHT);
    search_key_string(array_key,search_key,key_t);
    
    
    return (EXIT_SUCCESS);
}

