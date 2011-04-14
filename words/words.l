%{
/*
 * Modified by Andy Niccolai
 * For Principles of Programming Languages
 * On 3/24/2011
 *
 * Example based on code in lex & yacc by 
 * Levine, Mason and Brown
 *
 */

%}
%%

[\t ]+		/* ignore white space */ ;

%{/* 
* Recognize registers R0-R1 
*/%}

R[0-9] { printf("%s: is a register\n", yytext); }

%{/*
* Recognize complex numbers
*/%}

(\+|-)?([0-9]+(\+|-))?[0-9]*i { printf("%s: complex number\n", yytext); }

%{/*
* Recognize regular number (so you can see where complex ones stop)
*/%}

(\+|-)?[0-9]+[^i] { printf("%s: is a regular number\n", yytext); }

%{/*
* Recognize some adjectives
*/%}

bitter    |
delicious |
fresh     |
juicy     |
ripe      |
rotten    |
salty     |
sour      |
spicy     |
stale     |
sticky    |
strong    |
sweet     |
tart      |
tasteless |
tasty     |
thirsty   |
fluttering |
fuzzy     |
greasy    { printf("%s: is an adjective\n", yytext); }


ski |
bike |
hike |
read |
swim |
surf |
climb |
ride |
go		{ printf("%s: is a verb\n", yytext); }

I |
you |
he |
she |
we |
it |
they		{ printf("%s: is a pronoun\n", yytext); }

mountain |
ocean |
snowboard |
trail |
elk 		{ printf("%s: is a noun\n", yytext); }

[a-zA-Z]+ {
	 printf("%s:  don't recognize, might be a noun\n", yytext);
	}



%%

main()
{
	yylex();
}
