%{
/*
 * Zork Clone
 * by Andy Niccolai and Chin
 * For Principles of Programming Languages
 * On 3/29/2011
 *
 */

%}
%%

[\t ]+	    /* ignore white space */ ;


start   |
begin   { printf("start the game\n"); /*start the game*/}

quit    |
bye     |
exit    { printf("exit"); /*exit the game*/}

move    |
go 	  |
fly     |
walk    |
run     |
travel  |
leap    { printf("move"); /*go to another room*/}

north   |
south   |
east    |
west    { printf("direction"); /*valid directions*/}

search  |
look    |
find    { printf("find objects"); /* find objects in the current room */}

use     |
take    |
grab    |
snatch  { printf("manipulate"); /*manipulate an object*/}

gold    |
milk    |
cookies |
perfume |
torch   |
jewels  |
toaster |
sword   { printf("manipulatable"); /* recognize a item */}

kill    |
attack  |
slay    |
murder  { printf("attack"); /* attacks on an object */}

dragon  |
zombie  |
ghost   |
dolphin { printf("attackable"); /* recognize objects which can be attacked */}


.*      { printf("unknown"); }

%%

main()
{
	yylex();
}
