%{
/* Declerations section */
#include <stdio.h>
#include <stdlib.h>
void showToken(char *);
void showInt(int);
void showString(char *,char *);
void errorMessage(char *, char);
void error(char *);

char string_buf[1024];
char* string_buf_ptr;

%}

%option yylineno
%option noyywrap

whitespace	([ \t\n\r])
digit	([0-9])
hex ({digit}|[a-f])
int ({digit})+$
letter	([a-zA-Z])
character[\t !#-\[\]-~]
oneliner ([!-~])|([ \t\r])
printable {oneliner}|(\n)
escape  (\\)([nrt\\"\\]|u\{({hex}){1,6}\})

%x str
%x comment


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

0b([01])+ showInt(2);
0o([0-7])+ showInt(8);
0x({hex})+ showInt(16);
{int} showInt(10);
({digit})*\.({digit})*([eE][\2B\2D]int)? showToken("DEC_REAL");
0x({hex})+p[\+-]int showToken("HEX_FP");


(_|{letter})({letter}|{digit})* showToken("ID");




\" string_buf_ptr = string_buf; BEGIN(str);
<str>\" *string_buf_ptr = '\0'; showString("STRING",string_buf); BEGIN(INITIAL);
<str>\\n *string_buf_ptr++ = '\n';
<str>\\t *string_buf_ptr++ = '\t';
<str>\\r *string_buf_ptr++ = '\r';
<str>\x5C\x5C *string_buf_ptr++ = 0x5C;
<str>\x5C\x22 *string_buf_ptr++ = '"';
<str>\\u\x7B(({digit}|[a-f]){1,6})\x7D {
char temp[6] = {'\0'};
int i = 0;
while(yytext[3 + i] != '}' && i < 6){
  temp[i] = yytext[3 + i];
  i++;
}
i = atoi(temp);
if((0x20 <= i && i <= 0x7E) || i=='\n'|| i=='\t'|| i=='\r'){
*string_buf_ptr++ = i;
}else{
error("undefined escape sequence u");
}
}
<str>({character})  {*string_buf_ptr++ = *yytext;}
<str>\.+  {errorMessage("undefined escape sequence",yytext[1]);}

\2F\2A  BEGIN(comment);
<comment>\2A\2F  showToken("COMMENT"); BEGIN(INITIAL);
<comment>\2F\2A {error("Warning nested comment");}

\2F\2F[^\0A]*\0A  showToken("COMMENT");




{whitespace} ;
. errorMessage("Error", yytext[0]);
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

void showString(char *name,char *text){
	printf("%d %s %s\n", yylineno, name, text);
}
void errorMessage(char* message, char c){
printf("%s %c\n",c);
exit(0);
}
void error(char* message){
printf("%s\n",message);
exit(0);
}
