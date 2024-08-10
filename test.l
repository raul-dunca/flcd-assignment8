
%{ 	 
#include <stdio.h>
#include <stdlib.h>
#include <math.h> 
#include "syntax.tab.h"

%} 


%option noyywrap
%option caseless

SIGN        [-]
DIGIT 		[0-9]
NON_ZERO    [1-9]
ID 		    [a-zA-Z][a-z0-9A-Z_]*
STRING      \"[^\"\n]*\"

%% 

{SIGN}?{NON_ZERO}{DIGIT}* 	{printf( "An integer constant: %s (%d)\n", yytext, atoi( yytext )); 
	                                return CONST_INT; } 

"0"                           {printf("An integer constant: %s (%d)\n", yytext, atoi(yytext));
                                    return CONST_INT; }

{STRING}  {printf( "A string constant: %s \n", yytext); 
            return CONST_STRING;}  

"int" {
    printf("Keyword: int\n");
    return INT;
}

"string" {
    printf("Keyword: string\n");
    return STRING;
}

"if" {
    printf("Keyword: if\n");
    return IF;
}

"elif" {
    printf("Keyword: elif\n");
    return ELIF;
}

"else" {
    printf("Keyword: else\n");
    return ELSE;
}

"loop" {
    printf("Keyword: loop\n");
    return LOOP;
}

"names" {
    printf("Keyword: names\n");
    return NAMES;
}

"in" {
    printf("Keyword: in\n");
    return IN;
}

"out" {
    printf("Keyword: out\n");
    return OUT;
}

"break" {
    printf("Keyword: break\n");
    return BREAK;
}

{ID} 		{printf( "An identifier: %s\n", yytext );
            return ID;} 


"+" {
    printf("Operator: +\n");
    return PLUS;
}

"-" {
    printf("Operator: -\n");
    return MINUS;
}

"*" {
    printf("Operator: *\n");
    return MULTIPLY;
}

"/" {
    printf("Operator: /\n");
    return DIVIDE;
}

"$" {
    printf("Operator: $\n");
    return DOLLAR;
}

"~" {
    printf("Operator: ~\n");
    return TILDE;
}

"%" {
    printf("Operator: %%\n");
    return MODULO;
}

"<=" {
    printf("Operator: <=\n");
    return LTE;
}

">=" {
    printf("Operator: >=\n");
    return GTE;
}

"==" {
    printf("Operator: ==\n");
    return EQUALS;
}

"=" {
    printf("Operator: =\n");
    return ASSIGN;
}

"!=" {
    printf("Operator: !=\n");
    return NOTEQUALS;
}

"!" {
    printf("Operator: !\n");
    return LOGICAL_NOT;
}

"<" {
    printf("Operator: <\n");
    return LESS;
}

">" {
    printf("Operator: >\n");
    return GREATER;
}


"[" {
    printf("Separator: [\n");
    return LEFT_BRACKET;
}

"]" {
    printf("Separator: ]\n");
    return RIGHT_BRACKET;
}

"{" {
    printf("Separator: {\n");
    return LEFT_BRACE;
}

"}" {
    printf("Separator: }\n");
    return RIGHT_BRACE;
}

";" {
    printf("Separator: ;\n");
    return SEMICOLON;
}

"," {
    printf("Separator: ,\n");
    return COMMA;
}

"(" {
    printf("Separator: (\n");
    return LEFT_PAREN;
}

")" {
    printf("Separator: )\n");
    return RIGHT_PAREN;
}

[ \t\n]+ 		/* eat up whitespace */ 
		 
. printf("Lexical Error at %s !!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n",yytext);
%% 