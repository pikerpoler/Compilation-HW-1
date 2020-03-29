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
(_|{letter})({letter}|{digit})* showToken("ID");
\"({oneliner}|{escape})*\"(whitespace)? showString("STRING");
{whitespace} ;
0b([01])+$ showInt(2);
0o([0-7])+$ showInt(8);
0x({hex})+$ showInt(16);
{int} showInt(10);
({digit})*\.({digit})*([eE][\+-]int)? showToken("DEC_REAL");
0x({hex})+p[\+-]int


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
