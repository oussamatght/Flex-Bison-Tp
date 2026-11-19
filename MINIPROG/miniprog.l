%{
#include <stdio.h>

static unsigned int token_count = 0;
static unsigned int error_count = 0;

#define TOKEN(category) do { \
    printf("Ligne %d : %s (%s)\n", yylineno, category, yytext); \
    token_count++; \
} while (0)
%}

%option noyywrap yylineno

LETTER      [A-Za-z]
DIGIT       [0-9]
IDENTIFIER  {LETTER}(({LETTER}|{DIGIT}|_)*({LETTER}|{DIGIT}))?
INTEGER     [+-]?{DIGIT}+
FLOAT       [+-]?{DIGIT}+"."{DIGIT}+

%%

"PROGRAM"       { TOKEN("PROGRAM"); }
"VAR"           { TOKEN("VAR"); }
"INTEGER"       { TOKEN("INTEGER"); }
"FLOAT"         { TOKEN("FLOAT"); }
"BEGIN"         { TOKEN("BEGIN"); }
"END"           { TOKEN("END"); }
"IF"            { TOKEN("IF"); }
"THEN"          { TOKEN("THEN"); }
"ELSE"          { TOKEN("ELSE"); }
"ENDIF"         { TOKEN("ENDIF"); }
"WRITE"         { TOKEN("WRITE"); }
"READ"          { TOKEN("READ"); }

{IDENTIFIER}    {
                    if (yyleng > 10) {
                        printf("Erreur lexicale ligne %d : identificateur "
                               "trop long (%s, %d caracteres; maximum 10)\n",
                               yylineno, yytext, yyleng);
                        error_count++;
                    } else {
                        TOKEN("IDF");
                    }
                }
{FLOAT}         { TOKEN("CST_FLOAT"); }
{INTEGER}       { TOKEN("CST_INT"); }
":="            { TOKEN("OP_AFF"); }
"=="|"!="|"<="|">="|"<"|">" {
                    TOKEN("OP_COMP");
                }
[+\-*/]         { TOKEN("OP_ARITH"); }
";"             { TOKEN("PVG"); }
","             { TOKEN("VIRGULE"); }
"("             { TOKEN("PAR_OUV"); }
")"             { TOKEN("PAR_FERM"); }
"//".*          ;
[ \t\r\n]+      ;
.               {
                    printf("Erreur lexicale ligne %d : caractere '%s' "
                           "non reconnu\n", yylineno, yytext);
                    error_count++;
                }

%%

int main(void)
{
    yylex();
    printf("\nNombre total de tokens reconnus : %u\n", token_count);
    printf("Nombre d'erreurs lexicales : %u\n", error_count);
    return error_count == 0 ? 0 : 1;
}
