    /* cs152-miniL phase2 */
%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *msg);
extern int currLine;
extern int currPos;
FILE * yyin;
%}

%union{
  /* put your types here */
	char* str
}

%error-verbose
%locations
%start input
%token ADD SUB
%left ADD SUB
/* %start program */

%% 
input:
	| input TEST	{printf("baby");}
	;
TEST:	
	ADD SUB		{printf(" YES BITCH ");}
	;
  /* write your rules here */

%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
     printf("error"); 
}
