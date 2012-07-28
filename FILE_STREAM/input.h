
	
typedef struct{
	
	char * nick_name;
	
	
}user_sd;

static int string_input(char *);
static void strcopy(char * , char * );
static int lenghtline(char * );
#define sinput string_input


enum{
	fp_in,
	fp_out,
	fp_err
};
