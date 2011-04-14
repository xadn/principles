%{
// Modified by Andy Niccolai on 4/13/2011
// for Principles of Programming Languages

#include <stdio.h>
#include <stdlib.h>

float total = 0;

void updateTotal(float value)
{
	total += value;
}

void endProgram() 
{ 
	printf("The total is: %f, Goodbye\n", total); 
	exit(0);
}

%}

%union { 
	int ival;
	float fval;
	char* sval;
} 
%token <sval> NAME
%token <ival> NUMBER
%token <fval> FNUMBER
%type <fval> expression term factor
%%

program: '{' statements '}' 		{ endProgram(); }
	;

statements: statement ';' statements
	| statement
	;

statement:	NAME '=' expression	{ printf("%s = %f\n", $1, $3); 
											  updateTotal($3); 
											  free($1); 
											}
	|	expression						{ printf("= %f\n", $1); 
											  updateTotal($1); 
											}
	;

expression:	expression '+' term	{ $$ = $1 + $3; }
	|	expression '-' term			{ $$ = $1 - $3; }
	|	term								{ $$ = $1; }
	;

term: term '*' factor 				{ $$ = $1 * $3; }
	|	factor 							{ $$ = $1; }
	;

factor: '(' expression ')'			{ $$ = $2; }
	| NUMBER 							{ $$ = $1; }
	| FNUMBER 							{ $$ = $1; }
	;