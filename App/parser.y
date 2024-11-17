%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);

%}

%union {
    int ival;
    float fval;
    char *sval;
}

%token <ival> NUMBER
%token <sval> ID  // Keep ID as a string for identifiers
%token INT FLOAT RETURN USING NAMESPACE COUT SETW INCLUDE

%type <ival> expression

%left '+' '-'
%left '*' '/'

%%

program:
    function_list { printf("Parsed program\n"); }
    ;

function_list:
    function { printf("Parsed a function\n"); }
    | function_list function { printf("Parsed multiple functions\n"); }
    ;

function:
    type ID '(' ')' '{' statement_list '}'  { printf("Parsed function: %s\n", $2); }
    ;

type:
    INT       { /* No need for $$ here */ }
    | FLOAT   { /* No need for $$ here */ }
    ;

statement_list:
    statement { printf("Parsed single statement\n"); }
    | statement_list statement { printf("Parsed statement list\n"); }
    ;

statement:
    RETURN expression ';' { printf("Parsed return statement\n"); }
    | INT ID '=' expression ';' { printf("Parsed variable declaration\n"); }
    | FLOAT ID '=' expression ';' { printf("Parsed float variable declaration\n"); }
    | COUT expression ';' { printf("Parsed cout statement\n"); }
    ;

expression:
    NUMBER { printf("Parsed number: %d\n", $1); }
    | ID { printf("Parsed identifier: %s\n", $1); }
    | expression '+' expression { printf("Parsed addition\n"); }
    | expression '-' expression { printf("Parsed subtraction\n"); }
    | expression '*' expression { printf("Parsed multiplication\n"); }
    | expression '/' expression { printf("Parsed division\n"); }
    | '(' expression ')' { $$ = $2; }  // Handle parentheses
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Starting parser...\n");

    freopen("input.txt", "r", stdin);  // Input from file

    int result = yyparse();
    printf("Parsing finished with result: %d\n", result);

    fclose(stdin);
    return result;
}
