%{
/* Declerations section */
#include <stdio.h>
void showToken(char *);
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
\"({oneliner}|{escape})*\"(whitespace)? showToken("STRING");
{whitespace} ;
. printf("I Dont Know What That Is!\n");
%%

void showToken(char * name){
  printf("%d %s %s\n", yylineno, name, yytext);
}
