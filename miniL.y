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
%start prog_start
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY ENUM OF IF THEN ENDIF ELSE FOR WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE IDENT NUMBER SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN EQ_SIGN
%left ADD SUB
/* %start program */

%% 
prog_start:
	program		{printf("prog_start -> program\n");}
	;

program:
	{printf("program -> epsilon\n");}	
|	function program {printf("program -> FUNCTION program\n");}
	;

function:
	FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {printf("function -> IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n");}
	;

declaration:
	identifiers COLON INTEGER {printf("declaration -> identifiers COLON INTEGER\n");}
|	identifiers COLON ENUM L_PAREN identifiers R_PAREN {printf("declaration -> identifiers COLON ENUM L_PAREN identifiers R_PAREN\n");}
|	identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("identifiers -> COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}
|	identifiers INTEGER {yyerror("Invalid declaration");}
|       identifiers ENUM L_PAREN identifiers R_PAREN {yyerror("Invalid declaration");}
|	identifiers ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {yyerror("Invalid declaration");}
	;

statement:
	var ASSIGN expression {printf("statement -> var ASSIGNMENT expression\n");}
|	IF bool-expr THEN statements elses ENDIF {printf("statement -> IF bool-expr THEN statements elses ENDIF\n");}
|	WHILE bool-expr BEGINLOOP statements ENDLOOP {printf("statement -> WHILE bool-expr BEGINLOOP statements ENDLOOP\n");}
|	DO BEGINLOOP statements ENDLOOP WHILE bool-expr {printf("statement -> DO BEGINLOOP statements ENDLOOP WHILE bool-expr\n");}
|	READ vars {printf("statement -> READ vars\n");}
|	WRITE vars {printf("statement -> WRITE vars\n");}
|	CONTINUE {printf("statement -> CONTINUE\n");}
|	RETURN expression {printf("statement -> RETURN expression\n");}
|	var EQ_SIGN expression {yyerror(":= expected");}
	;

bool-expr:
	rltn-and-expr {printf("bool-expr -> rltn-and-expr\n");}
|	rltn-and-expr OR bool-expr {printf("bool-expr -> rltn-and-expr OR bool-expr\n");}
	;

rltn-and-expr:
	rltn-expr {printf("rltn-and-expr -> rltn-expr\n");}
|	rltn-expr AND rltn-and-expr {printf("rltn-and-expr -> rltn-expr AND rltn-and-expr\n");}
	;

rltn-expr:
	NOT rltn-expr {printf("rltn-expr -> NOT rltn-expr\n");}
|	expression comp expression {printf("rltn-expr -> expression comp expression\n");}
|	TRUE {printf("rltn-expr -> TRUE\n");}
|	FALSE {printf("rltn-expr -> FALSE\n");}
|	L_PAREN bool-expr R_PAREN {printf("rltn-expr -> L_PAREN bool-expr R_PAREN\n");}
	;

comp:
	EQ {printf("comp -> EQ\n");}
|	NEQ {printf("comp -> NEQ\n");}
|	LT {printf("comp -> LT\n");}
|	GT {printf("comp -> GT\n");}
|	LTE {printf("comp -> LTE\n");}
|	GTE {printf("comp -> GTE\n");}
|	EQ_SIGN{yyerror("Invalid comparator");}
	;

expression:
	mult-expr {printf("expression -> mult-expr\n");}
|	mult-expr ADD expression {printf("expression -> mult-expr ADD expression\n");}
|	mult-expr SUB expression {printf("expression -> mult-expr SUB expression\n");}
	;

mult-expr:
	term {printf("mult-expr -> term\n");}
|	term MULT mult-expr {printf("mult-expr -> term MULT mult-expr\n");}
|	term DIV mult-expr {printf("mult-expr -> term DIV mult-expr\n");}
|	term MOD mult-expr {printf("mult-expr -> term MOD mult-expr\n");}
	;
 
term:
	IDENT L_PAREN expressions R_PAREN {printf("term -> IDENT L_PAREN expressions R_PAREN\n");}
|	terms {printf("term -> terms\n");}
	;

terms:
	SUB terms {printf("terms -> SUB terms\n");}
|	vars {printf("terms -> vars\n");}
|	NUMBER {printf("terms -> NUMBER\n");}
|	L_PAREN expression R_PAREN {printf("terms -> L_PAREN expression R_PAREN\n");}
	;

var:
	IDENT {printf("var -> IDENT\n");}
|	IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n");}
	;

expressions:
	{printf("expressions -> epsilon\n");}
|	expression expressions2 {printf("expressions -> expression expressions2\n");}
	;

expressions2:
	{printf("expressions2 -> epsilon\n");}
|	COMMA expression expressions2 {printf("expressions2 -> COMMA expression expressions2\n");}
	;
	
elses:
	{printf("elses -> epsilon\n");}
|	ELSE statements {printf("elses -> ELSE statements\n");}
	;

vars:
	var {printf("vars -> var\n");}
|	var COMMA vars {printf("vars -> var COMMA vars\n");}
|       var vars {yyerror("Expected comma");}
	;

identifiers:
	IDENT {printf("identifiers -> IDENT\n");}
|	IDENT COMMA identifiers {printf("identifiers -> IDENT COMMA identifiers\n");}
|       IDENT identifiers {yyerror("Expected comma");}
	;

declarations:
	{printf("declarations -> epsilon\n");}
|	declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
|	declaration declarations {yyerror("Expected semicolon");}
	;

statements:
	statement SEMICOLON {printf("statements -> statement SEMICOLON\n");}
|	statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}
|	statement {yyerror("Expected Semicolon");}
|	statement statements {yyerror("Expected semicolon");}
	;

  /* write your rules here */

%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
     printf("**Syntax error at  line %d, position %d: %s\n", currLine, currPos, msg); 
}
