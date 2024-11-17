%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
%}

%option noyywrap

DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*
NUMBER      {DIGIT}+(\.{DIGIT}*)?

%%

"int"       { return INT; }
"return"    { return RETURN; }
"float"     { return FLOAT; }
"using"     { return USING; }
"namespace" { return NAMESPACE; }
"cout"      { return COUT; }
"setw"      { return SETW; }

"#include"  { return INCLUDE; }

{ID}        { yylval.sval = strdup(yytext); return ID; }

{NUMBER}    { yylval.ival = atoi(yytext); return NUMBER; }

"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"="         { return '='; }
";"         { return ';'; }
"{"         { return '{'; }
"}"         { return '}'; }
"("         { return '('; }
")"         { return ')'; }

[ \t\n]     ;  // Ignore whitespace

.           { printf("Unknown character: %s\n", yytext); }
%%

