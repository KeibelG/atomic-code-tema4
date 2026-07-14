%{
/* ---------------------------------------------------------------------------
 * Lenguaje:   C (generado por Flex)
 * Asignatura: Lenguajes y compiladores
 * Equipo:     Atomic Code
 *             Segmentando el codigo, construyendo la logica
 *
 * Integrantes:
 *   - Victor Vargas    C.I: 30.697.219
 *   - Keibel Guilarte  C.I: 28.726.605
 *   - Oriana Marquez   C.I: 31.354.299
 *   - Jeanny Monagas   C.I: 30.857.471
 *
 * ---------------------------------------------------------------------------
 *                           DESCRIPCION
 * ---------------------------------------------------------------------------
 * Analizador lexico construido con el metacompilador Flex para el lenguaje
 * L = subconjunto de Rust definido por el equipo. L admite:
 *
 *   Palabras clave : fn let mut if else while loop return break continue
 *                    true false
 *   Tipos          : i32 i64 u32 u64 f32 f64 bool char String str
 *   Literales      : enteros, flotantes, cadenas "...", caracteres '.'
 *   Identificadores: [a-zA-Z_][a-zA-Z0-9_]*
 *   Macro          : println!  (unica macro soportada, como un solo token)
 *   Operadores     : + - * / % = == != < > <= >= && || ! -> ::
 *   Delimitadores  : { } ( ) [ ] ; , :
 *   Comentarios    : de linea (doble diagonal) y de bloque (estilo C)
 *
 * El programa lee un archivo fuente en L (pasado como argumento) y emite,
 * por cada componente lexico reconocido, su categoria de token, el lexema y
 * el numero de linea donde aparece.
 *
 * Compilar:  flex -o lex.yy.c lexer.l  &&  gcc lex.yy.c -o lexer
 * Ejecutar:  ./lexer ejemplos/ejemplo1.rs
 * ---------------------------------------------------------------------------
 */
#include <stdio.h>
%}

%option noyywrap
%option yylineno

%x COMENTARIO_BLOQUE

DIGITO      [0-9]
LETRA       [a-zA-Z_]

%%

"/*"                        { BEGIN(COMENTARIO_BLOQUE); }
<COMENTARIO_BLOQUE>"*/"     { BEGIN(INITIAL); }
<COMENTARIO_BLOQUE>\n       { /* solo avanza yylineno, no produce token */ }
<COMENTARIO_BLOQUE>.        { /* contenido del comentario de bloque: se ignora */ }

"//".*                      { /* comentario de linea: se ignora */ }

"fn"                         { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"let"                        { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"mut"                        { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"if"                         { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"else"                       { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"while"                      { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"loop"                       { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"return"                     { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"break"                      { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"continue"                   { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"true"                       { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }
"false"                      { printf("(%-10s, %-20s, linea %d)\n", "KEYWORD",     yytext, yylineno); }

"i32"                        { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }
"i64"                        { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }
"u32"                        { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }
"u64"                        { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }
"f32"                        { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }
"f64"                        { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }
"bool"                       { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }
"char"                       { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }
"String"                     { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }
"str"                        { printf("(%-10s, %-20s, linea %d)\n", "TYPE",        yytext, yylineno); }

{LETRA}({LETRA}|{DIGITO})*"!" { printf("(%-10s, %-20s, linea %d)\n", "MACRO",      yytext, yylineno); }
{LETRA}({LETRA}|{DIGITO})*    { printf("(%-10s, %-20s, linea %d)\n", "IDENTIFIER", yytext, yylineno); }

{DIGITO}+"."{DIGITO}+        { printf("(%-10s, %-20s, linea %d)\n", "FLOAT",       yytext, yylineno); }
{DIGITO}+                    { printf("(%-10s, %-20s, linea %d)\n", "INT",        yytext, yylineno); }

\"([^"\\]|\\.)*\"            { printf("(%-10s, %-20s, linea %d)\n", "STRING",     yytext, yylineno); }
'([^'\\]|\\.)'               { printf("(%-10s, %-20s, linea %d)\n", "CHAR",       yytext, yylineno); }

"->"                         { printf("(%-10s, %-20s, linea %d)\n", "OPERATOR",   yytext, yylineno); }
"::"                         { printf("(%-10s, %-20s, linea %d)\n", "OPERATOR",   yytext, yylineno); }
"=="                         { printf("(%-10s, %-20s, linea %d)\n", "OPERATOR",   yytext, yylineno); }
"!="                         { printf("(%-10s, %-20s, linea %d)\n", "OPERATOR",   yytext, yylineno); }
"<="                         { printf("(%-10s, %-20s, linea %d)\n", "OPERATOR",   yytext, yylineno); }
">="                         { printf("(%-10s, %-20s, linea %d)\n", "OPERATOR",   yytext, yylineno); }
"&&"                         { printf("(%-10s, %-20s, linea %d)\n", "OPERATOR",   yytext, yylineno); }
"||"                         { printf("(%-10s, %-20s, linea %d)\n", "OPERATOR",   yytext, yylineno); }
[+\-*/%=<>!]                 { printf("(%-10s, %-20s, linea %d)\n", "OPERATOR",   yytext, yylineno); }

[{}()\[\];,:]                { printf("(%-10s, %-20s, linea %d)\n", "PUNCT",      yytext, yylineno); }

[ \t]+                       { /* espacios y tabuladores: se ignoran */ }
\n                           { /* solo avanza yylineno, no produce token */ }

.                            { printf("ERROR LEXICO: caracter no reconocido %s en linea %d\n", yytext, yylineno); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            perror("Error al abrir el archivo");
            return 1;
        }
        yyin = archivo;
    }
    yylex();
    return 0;
}
