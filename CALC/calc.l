%{
#include <stdio.h>

static unsigned int token_count = 0;
static unsigned int error_count = 0;

#define TOKEN(category) do { \
    printf("%s : %s\n", category, yytext); \
    token_count++; \
} while (0)
%}

%option noyywrap

LETTER      [A-Za-z]
DIGIT       [0-9]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*

%%

"print"         { TOKEN("MOT_CLE"); }
{IDENTIFIER}    { TOKEN("IDF"); }
{DIGIT}+        { TOKEN("ENTIER"); }
[-+*/]          { TOKEN("OP_ARITH"); }
"="             { TOKEN("AFFECT"); }
";"             { TOKEN("PVG"); }
[()]            { TOKEN("PAR"); }
[ \t\r\n]+      ;
.               {
                    printf("Erreur lexicale : caractere '%s' non reconnu.\n",
                           yytext);
                    error_count++;
                }

%%

int main(void)
{
    yylex();
    printf("\nNombre total de tokens reconnus : %u\n", token_count);
    if (error_count != 0) {
        printf("Nombre d'erreurs lexicales : %u\n", error_count);
    }
    return error_count == 0 ? 0 : 1;
}
