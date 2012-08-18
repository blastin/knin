/* 
 * File:   hot_key.h
 * Author: jeff
 *
 * Created on 21 de Julho de 2012, 00:26
 */

enum {
    
    SEARCH_KEY_SIZE_T_UP=1,   /*tamanho que a array terá para KEY_UP   */
    SEARCH_KEY_SIZE_T_LEFT=3, /*tamanho que a array terá para KEY_LEFT */
    SEARCH_KEY_SIZE_T_DOWN=3, /*tamanho que a array terá para KEY_DOWN */
    SEARCH_KEY_SIZE_T_RIGHT   /*tamanho que a array terá para KEY_RIGHT*/
};

typedef struct {
    
    char KEY_UP[SEARCH_KEY_SIZE_T_UP];
    char KEY_LEFT[SEARCH_KEY_SIZE_T_LEFT];
    char KEY_DOWN[SEARCH_KEY_SIZE_T_DOWN];
    char KEY_RIGHT[SEARCH_KEY_SIZE_T_RIGHT];
    
}key_user;

#define UP              "UP"
#define DOWN            "DOWN"
#define LEFT            "LEFT"
#define RIGHT           "RIGHT"


#define EMBRANCE_INIT   '{'
#define EMBRANCE_END    '}'
