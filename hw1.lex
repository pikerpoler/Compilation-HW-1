%{
/* Declerations section */
#include <stdio.h>
void showToken(char *);
void showString(char *);
%}

%option yylineno
%option noyywrap

whitespace	([ \t\n\r])
digit	([0-9])
hex ({digit}|[a-f]){1,6}
letter	([a-zA-Z])
oneliner ([!-~])|([ \t\r])
printable {oneliner}|( )
escape  (\\)([nrt\\"\\]|u\{{hex}\})

%%
(_|{letter})({letter}|{digit})* showToken("ID");
\"({oneliner}|{escape})*\"(whitespace)? showString("STRING");
{whitespace} ;
. printf("I Dont Know What That Is!\n");
%%

void showToken(char * name){
  printf("%d %s %s\n", yylineno, name, yytext);
}

void showString(char *name){
	char* text=yytext;
	int len=strlen(text);
	text++;
	text[len-2]='\0';
  printf("%d %s %s\n", yylineno, name, text);
}
