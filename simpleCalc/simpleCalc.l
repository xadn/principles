%{
// Modified by Andy Niccolai on 4/13/2011
// for Principles of Programming Languages

#include "simpleCalc.tab.h"

char* extractName(char* name);

%}
%%

@[a-zA-Z]+ { 
	yylval.sval = extractName(yytext);	
	return NAME; 
	}
	
[0-9]+*\.[0-9]+ { 
	yylval.fval = atof(yytext); 
	return FNUMBER; 
	}
	
[0-9]+ { 
	yylval.ival = atoi(yytext); 
	return NUMBER; 
	}
	
	
[ \t\n\r]	;		/* ignore white space, newlines, and returns */

.	return yytext[0];

%%

// Copy the array starting at the second element to skip the '@'
// Strdup will make sure that the array ends at the first NULL character
char* extractName(char* name)
{
	return strdup(&name[1]);
}
 
yyerror(char *errmsg)
{
    fprintf(stderr, "%s\n", errmsg);
}

main(int argc, char **argv)
{
	// Try to read in a file if one is specified in the arguments
	// Otherwise it defaults to stdin
	if(argc)
	{
		FILE* inputFile = fopen(argv[1], "r");
		if(inputFile)
		{
			yyset_in(inputFile);
		}
	}
	yyparse();
}
