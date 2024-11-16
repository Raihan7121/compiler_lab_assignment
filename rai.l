%{
#include <stdio.h>

int operator_count = 0;
int datatype_count = 0;
int identifier_count = 0;
int keyword_count = 0;
%}

IDENTIFIER    [a-zA-Z_][a-zA-Z0-9_]* 
VSTRING       \`([^`\$]|(\$\{[a-zA-Z_][a-zA-Z0-9_]*\}))*\`
STRING        \"[^\"]*\" 
FLOAT         [0-9]+\.[0-9]+
INTEGER       [0-9]+
OPERATOR      [-+*/=<>!&|] 
DELIMITER     [,\(\)\[\]\{\}\\]
SLC           "//".*   
MLC           "/*"([^*]|\*+[^*/])*\*+"/"   
END_STATEMENT ";"       

%%

[ \t\n]+           // Matches whitespace, no action (OK to skip)
{SLC}              { printf("Single Line Comment         -> %s\n", yytext); }  
{MLC}              { printf("Multiline Comment           -> %s\n", yytext); }  
"inti"             { printf("INTEGER        -> %s\n", yytext); keyword_count++; }  
"vari"             { printf("FLOAT       -> %s\n", yytext); datatype_count++; }  
"loop"             { printf("LOOP        -> %s\n", yytext); keyword_count++; }  
"view"             { printf("PRINT     -> %s\n", yytext); keyword_count++; }  
"fi"               { printf("CONDITION   -> %s\n", yytext); keyword_count++; }  
"fin"              { printf("ELIF        -> %s\n", yytext); keyword_count++; }  
"fie"              { printf("ELSE        -> %s\n", yytext); keyword_count++; }  
"family"           { printf("METHOD      -> %s\n", yytext); keyword_count++; }  
"read"             { printf("SCAN        -> %s\n", yytext); keyword_count++; }  
"sotto"            { printf("TRUE        -> %s\n", yytext); keyword_count++; }  
"mitha"            { printf("FALSE       -> %s\n", yytext); keyword_count++; }  
"collection"       { printf("COLLECTION  -> %s\n", yytext); keyword_count++; }
"stop"             { printf("STOP        -> %s\n", yytext); keyword_count++; }
"agaw"             { printf("CONTINUE    -> %s\n", yytext); keyword_count++; }  
"biroti"           { printf("BREAK       -> %s\n", yytext); keyword_count++; }  
"out"              { printf("RETURN      -> %s\n", yytext); keyword_count++; }  
"include"          { printf("INCLUDE     -> %s\n", yytext); keyword_count++; }
"category"         { printf("CATEGORY    -> %s\n", yytext); keyword_count++; }
"inherit"          { printf("INHERIT     -> %s\n", yytext); keyword_count++; }
"null"             { printf("NULL        -> %s\n", yytext); keyword_count++; }
"attempt"          { printf("ATTEMPT     -> %s\n", yytext); keyword_count++; }
"catch"            { printf("CATCH       -> %s\n", yytext); keyword_count++; }
"success"          { printf("SUCCESS     -> %s\n", yytext); keyword_count++; }
"private"          { printf("PRIVATE     -> %s\n", yytext); keyword_count++; }
"public"           { printf("PUBLIC      -> %s\n", yytext); keyword_count++; }
"primary"          { printf("PRIMARY     -> %s\n", yytext); keyword_count++; }
"error"            { printf("ERROR       -> %s\n", yytext); keyword_count++; }
{FLOAT}            { printf("FLOAT       -> %s\n", yytext); datatype_count++; }
{INTEGER}          { printf("INT         -> %s\n", yytext); datatype_count++; }
{STRING}           { printf("STRING      -> %s\n", yytext); datatype_count++; }
{VSTRING}          { printf("vSTRING     -> %s\n", yytext); datatype_count++; }
{IDENTIFIER}       { printf("ID          -> %s\n", yytext); identifier_count++; }
{OPERATOR}         { printf("OPERATOR    -> %s\n", yytext); operator_count++; }
{DELIMITER}        { printf("DELIMITER   -> %s\n", yytext); }
{END_STATEMENT}    { printf("END OF STATEMENT -> %s\n", yytext); }  

.                   { printf("ERROR: UNKNOWN KEYWORD -> %s\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main() {
    FILE *file = fopen("in.txt", "r");
    if (!file) {
        perror("Failed to open input file");
        return 1;
    }

    FILE *outfile = fopen("out.txt", "w");
    if (!outfile) {
        perror("Failed to open output file");
        fclose(file);
        return 1;
    }

    freopen("out.txt", "w", stdout);

    yyin = file;

    yylex();

    printf("\n--- Statistics ---\n");
    printf("Keywords matched: %d\n", keyword_count);
    printf("Operators: %d\n", operator_count);
    printf("Datatypes: %d\n", datatype_count);
    printf("Identifiers: %d\n", identifier_count);

    fclose(file);
    fclose(outfile); 

    return 0;
}
