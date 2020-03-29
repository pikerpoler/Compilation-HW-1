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
printable ([!-~])|{whitespace}
escape  (\)([nrt\"\\]|u\{{hex}\})

%%
(_|{letter})({letter}|{digit})* showToken("ID");
(")({printable}|{escape})*(") showToken("STRING");
{whitespace} ;
. printf("I Dont Know What That Is!\n");
%%

void showToken(char * name){
  printf("%d %s %s\n", yylineno, name, yytext);
}
