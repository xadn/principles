#include <cstdio>
#include <cctype>
#include <fstream>
#include <iostream>
#include <istream>

using namespace std;

/* prototypes */
void expr();
int lex();
void factor();
void term();
void error();

/* Global variables*/
ifstream yyin;  // file being read
char buffer[100]; // line from file
int buffptr; // keep track of next character in line 
char lexeme[100]; // identifier
int lexLen; // next position for identifier
char nextChar; // character just read
int charClass; // type of character just read
int nextToken; // type of token being processed

// Character classes
const int LETTER = 0;
const int DIGIT = 1;
const int UNKNOWN = -1;

// Token classes
const int ID_CODE = 0;
const int LEFT_PAREN_CODE = 1;
const int RIGHT_PAREN_CODE = 2;
const int AST_CODE = 3;
const int SLASH_CODE = 4;
const int PLUS_CODE = 5;
const int MINUS_CODE = 6;
const int INT_LIT = 7;
const int END_CODE = 8;
const int EQUALS_CODE = 9;
const int IF_CODE = 10;
const int ELSE_CODE = 11;

/* place the next character into the lexeme */
void addChar()
{
	if (lexLen <= 99)
		lexeme[lexLen++] = nextChar;
	else
		printf("Error - lexeme is too long\n");
}

/* get the next character from the buffer, classify it */
void getChar()
{
	nextChar = buffer[buffptr++];
	if (isalpha(nextChar))
		charClass = LETTER;
	else if (isdigit(nextChar))
		charClass = DIGIT;
	else
		charClass = UNKNOWN;
}

/* skip white space, get the next character to be processed */
void getNonBlank()
{
	while (isspace(nextChar))
	{
		getChar();
	}
}

/* set up nextToken  */
int lex() {
	lexLen = 0;
	static int first = 1;
	/* read line to be parsed from the file */
	if (first) {
		yyin.getline(buffer, 100);
		nextChar = ' ';
		buffptr = 0;
		first = 0;
		buffer[strlen(buffer)] = '\n';
	}
	getNonBlank();

	switch (charClass) {
    case LETTER:
      lexLen = 0; // reset lexeme length for new identifier
      addChar();
      getChar();
      while (charClass == LETTER || charClass == DIGIT)
      {
        addChar();
        getChar();
      }
	  lexeme[lexLen] = '\0'; // end identifier string
	  // this is where you'll test for if and else
      nextToken = ID_CODE;
      break;
    case DIGIT: 
      addChar();
      getChar();
      while (charClass == DIGIT) {
        addChar();
        getChar();
      }
      nextToken = INT_LIT;
      break;
	case UNKNOWN:
	  switch (nextChar)
	  {
		  case '+':
		    nextToken = PLUS_CODE; break;
		  case '-':
		    nextToken = MINUS_CODE; break;
		  case '*':
		    nextToken = AST_CODE; break;
		  case '/':
		    nextToken = SLASH_CODE; break;
		  case '(':
		    nextToken = LEFT_PAREN_CODE; break;
		  case ')':
		    nextToken = RIGHT_PAREN_CODE; break;
		  case '\n':
		    nextToken = END_CODE; break;
		  case '=':
        nextToken = EQUALS_CODE; break;

	  }		  
  }  /* End of switch */
}  /* End of function lex */

/* Function factor 
Parses strings in the language generated by the rule:  
<factor> -> id  |  (<ex)  
*/ 

void factor() {
  if (nextToken == ID_CODE)
   {
	  printf("%s", lexeme);
      lex(); // For the RHS id, just call lex
   }
  /* If the RHS is ( � call lex to pass over the left parenthesis, 
     call expr, then check for the right parenthesis */
   else if (nextToken == LEFT_PAREN_CODE) 
   {
	   	 printf("%c",nextChar);
	   	 nextChar = ' ';
         lex();
         expr();
         if (nextToken == RIGHT_PAREN_CODE)
		     {
    		   printf("%c",nextChar);
    		   nextChar = ' ';
               lex();
    		 }
         else
            error();
   }  /* End of else if (nextToken == ...  */
   else if (nextToken == EQUALS_CODE){
          
   }
   else error(); /* Neither RHS matches */
  }

/* Function term
   Parses strings in the language generated by the rule: 
    <term> -> <factor> {(* | /) <factor> }  
*/

 void term() {
 /* Parse the first factor */
   factor();
   while (nextToken == AST_CODE || nextToken == SLASH_CODE) 
   {
	 printf("%c",nextChar);
	 nextChar = ' ';
     lex();
     factor();
   }
}

/* Function expr 
Parses strings in the language generated by the rule: 
<expr> ? <term> { (+ | -) <term> }     
*/

void expr() {
// Parse the first term 
  term(); 
  /* As long as the next token is + or -, call lex to get the next 
     token, and parse the next term */
  while (nextToken == PLUS_CODE || nextToken == MINUS_CODE || EQUALS_CODE)
   {
	 printf("%c",nextChar);
	 nextChar = ' ';
     lex();
     term();  
   }
   printf("\nIs an expression!\n");
}

void error()
{
	printf("Error while parsing\n");
}

int main(int argc, char** argv)
{
	if (argc == 2)
	{
		yyin.open(argv[1],ios::in);   
		if (!yyin) {
			printf("Error: couldn't open %s\n", argv[1]);
			exit(1);
		}
		lex();
		expr();
	}	
	else
		printf("Error, no file name specified");
}

