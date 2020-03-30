%{
/* Declerations section */
#include <stdio.h>
#include <stdlib.h>
void showToken(char *);
void showInt(int);
void showString(char *);

%}

%option yylineno
%option noyywrap

whitespace	([ \t\n\r])
digit	([0-9])
hex ({digit}|[a-f])
int ({digit})+$
letter	([a-zA-Z])
oneliner ([!-~])|([ \t\r])
printable {oneliner}|( )
escape  (\\)([nrt\\"\\]|u\{({hex}){1,6}\})

%%
;  showToken("SC");
, showToken("COMMA");
\x28 showToken("LPAREN");
\x29 showToken("RPAREN");
\x7B showToken("LBRACE");
\x7D showToken("RBRACE");
\x5B showToken("RBRACKET");
\x5D showToken("LBRACKET");
= showToken("ASSIGN");
\x3A showToken("COLON");

var showToken("VAR");
let showToken("LET");
func showToken("FUNC");
import showToken("IMPORT");
nil showToken("NIL");
while showToken("WHILE");
if showToken("IF");
else showToken("ELSE");
return showToken("RETURN");
(Int|UInt|Double|Float|Bool|String|Character) showToken("TYPE");
true showToken("TRUE");
false showToken("FALSE");

==|!=|<|>|<=|>= showToken("RELOP");
\x2B|\x2D|\x2A|\x2F|\x25 showToken("BINOP");
\x26\x26|\x7C\x7C showToken("LOGOP");
\x2D\x3E showToken("ARROW");


(_|{letter})({letter}|{digit})* showToken("ID");
\"({oneliner}|{escape})*\" showString("STRING");
{whitespace} ;
0b([01])+$ showInt(2);
0o([0-7])+$ showInt(8);
0x({hex})+$ showInt(16);
{int} showInt(10);
({digit})*\.({digit})*([eE][\+-]int)?$ showToken("DEC_REAL");
0x({hex})+p[\+-]int$


. printf("I Dont Know What That Is!\n");
%%

void showToken(char * name){
  printf("%d %s %s\n", yylineno, name, yytext);
}

void showInt(int base){
  const char* name;
  switch(base){
  case 2:
        name = "BIN_INT";
        break;
  case 8:
        name = "OCT_INT";
        break;
  case 10:
        name = "DEC_INT";
        break;
  case 16:
        name = "HEX_INT";
        break;
  }
  int n = strtol(yytext + 2, 0, base);
  printf("%d %s %d\n", yylineno, name, n);
}

void showString(char *name){
	char* text=yytext;
	int len=strlen(text);
	text++;
	text[len-2]='\0';
	printf(text);
	printf("%d %s %s\n", yylineno, name, text);
}
