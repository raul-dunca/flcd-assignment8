%{
#include <stdio.h>
#include <stdlib.h>

#define YYDEBUG 1 


%}


%token INT
%token STRING
%token IF
%token ELIF
%token ELSE
%token LOOP
%token NAMES
%token IN
%token OUT
%token BREAK


%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token DOLLAR
%token TILDE
%token MODULO
%token LTE
%token GTE
%token EQUALS
%token ASSIGN
%token NOTEQUALS
%token LOGICAL_NOT
%token LESS
%token GREATER
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token LEFT_BRACE
%token RIGHT_BRACE
%token SEMICOLON
%token COMMA
%token LEFT_PAREN
%token RIGHT_PAREN

%token ID
%token CONST_INT
%token CONST_STRING

%left PLUS MINUS DOLLAR TILDE
%left MULTIPLY DIVIDE MODULO

%start program
%% 
program: declaration stmt program 
        | declaration program 
        | stmt program 
        | declaration 
        | stmt
		;
declaration : typedecl
            | namesdecl
            ;

typedecl : type ID type_add
         ;

type_add : COMMA ID type_add
         | SEMICOLON
         ;

type : INT
     | STRING
     ;

namesdecl : NAMES ID LEFT_BRACE CONST_INT RIGHT_BRACE names_add
          ;

names_add : COMMA ID LEFT_BRACE CONST_INT RIGHT_BRACE names_add SEMICOLON
          | SEMICOLON
          ;

expression : term
           | term operation expression
           ;

term : LEFT_PAREN expression RIGHT_PAREN
     | ID
     | CONST_INT
     | ID LEFT_BRACE ID RIGHT_BRACE
     | ID LEFT_BRACE CONST_INT RIGHT_BRACE
     | CONST_STRING
     ;

operation : PLUS
          | MINUS
          | MULTIPLY
          | DIVIDE
          | MODULO
          ;

condition : negationcond
          | normcondition
          ;

negationcond : LOGICAL_NOT LEFT_PAREN condition RIGHT_PAREN
             ;

normcondition : expression relation expression
              ;

relation : LESS
         | GREATER
         | LTE
         | GTE
         | EQUALS
         | NOTEQUALS
         ;

assignstmt : ID ASSIGN expression SEMICOLON
           | assignnamestmt
           ;

assignnamestmt : ID LEFT_BRACE CONST_INT RIGHT_BRACE ASSIGN expression SEMICOLON
               | ID LEFT_BRACE ID RIGHT_BRACE ASSIGN expression SEMICOLON
               ;

iostmt : IN LEFT_PAREN ID RIGHT_PAREN SEMICOLON
       | OUT LEFT_PAREN ID RIGHT_PAREN SEMICOLON
       | OUT LEFT_PAREN print_output RIGHT_PAREN SEMICOLON
       ;

print_output : CONST_STRING
             | ID
             | ID PLUS print_output
             | CONST_STRING PLUS print_output
             | ID LEFT_BRACE ID RIGHT_BRACE
             | ID LEFT_BRACE CONST_INT RIGHT_BRACE
             | ID LEFT_BRACE ID RIGHT_BRACE PLUS print_output
             | ID LEFT_BRACE CONST_INT RIGHT_BRACE PLUS print_output
             ;

ifstmt : IF LEFT_PAREN condition RIGHT_PAREN LEFT_BRACKET stmt RIGHT_BRACKET
       | IF LEFT_PAREN condition RIGHT_PAREN LEFT_BRACKET stmt RIGHT_BRACKET elifstmt
       | IF LEFT_PAREN condition RIGHT_PAREN LEFT_BRACKET stmt RIGHT_BRACKET elifstmt ELSE LEFT_BRACKET stmt RIGHT_BRACKET
       | IF LEFT_PAREN condition RIGHT_PAREN LEFT_BRACKET stmt RIGHT_BRACKET ELSE LEFT_BRACKET stmt RIGHT_BRACKET
       ;

elifstmt : ELIF LEFT_PAREN condition RIGHT_PAREN LEFT_BRACKET stmt RIGHT_BRACKET
         | ELIF LEFT_PAREN condition RIGHT_PAREN LEFT_BRACKET stmt RIGHT_BRACKET elifstmt
         ;

loopstmt : LOOP LEFT_PAREN condition RIGHT_PAREN LEFT_BRACKET stmt RIGHT_BRACKET
         | LOOP LEFT_PAREN forcond RIGHT_PAREN LEFT_BRACKET stmt RIGHT_BRACKET
         ;

forcond : assignstmt condition SEMICOLON specialstmt
        ;

specialstmt : ID DOLLAR
            | ID TILDE
            ;

breakstmt : BREAK SEMICOLON
          ;

stmt : allstmt
     | allstmt stmt
     ;

allstmt : simplestmt
        | structstmt
        ;

simplestmt : assignstmt
           | iostmt
           | specialstmt SEMICOLON
           | breakstmt
           ;

structstmt : ifstmt
           | loopstmt
           ;
%%

yyerror(char *s)
{
  printf("%s\n", s);
}

extern FILE *yyin;

int main(int argc, char **argv)
{
  if(argc>1) yyin = fopen(argv[1], "r");
  if((argc>2)&&(!strcmp(argv[2],"-d"))) yydebug = 1;
  if(!yyparse()) fprintf(stderr,"\tO.K.\n");
}


