
#include  <stdio.h>
#include "common.h"

int main(int argc, char * argv[]){
    
#if defined(WIN)
    if(win_mode())
        return 0;
#elif defined(GNU)
    if(nix_mode())
        return 0;
#endif
}


#if defined(WIN)
boolean win_mode(void){
    char over_buffer;
    
    while(!kbhit()){
    Sleep(_TIME_SLEEP * 1000); /*Sleep(Num_of_millisecs_you_want_to_sleep_for_minimum)*/
        
    }
    return True;
}
   
#elif defined(GNU)
boolean nix_mode(void){
     initscr();
     keypad(stdscr, TRUE);
     noecho();
     cbreak();
     timeout(0);
     while(True){
         unsigned int KEY = getch();
         sleep(_TIME_SLEEP);
     }
     return True;
}
#endif
