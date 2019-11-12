
%{
	#include<stdio.h>
	#include"st.h"
	extern int line ;
	int yylex();
	int yyerror(char *) ;
	int temp ;
	int t ;
	extern int line; 
        extern char *yytext;
	install (char *sym_name){
		symboleVar *s ;
		s = recupererSym(sym_name) ;
		if(s == 0)
		s = ajouterSym(sym_name, temp) ; //here
		else{
		//errors++ ;
		printf("La variable %s est deja definie,redefintion dans la ligne %d\n", sym_name, line) ;
		}
	}

	int context_check(char *sym_name){
	return (int)recupererSym(sym_name);
		/* if(recupererSym(sym_name) == 0){
		printf("La variable %s n'est pas declaree dans la ligne %d\n", sym_name, line) ;
		}*/
		
	}

	type_check(char *type, int type_2){
		int type_1;
		char *typeDonnee;
		if(strcmp(type, "int") == 0){
			type_1 =  3 ;
		}
		else if(strcmp(type, "float") == 0){
			type_1 = 4 ;
			
		}

		else {type_1 = 2 ; 
	} 
		//le type affecté 
		if(type_2 == 3){
		typeDonnee="int";}
		else if(type_2==4){
			typeDonnee="float";
		}
		else { typeDonnee="char"; }
		if(type_1 != type_2)

			printf("la variable est de type %s et non pas de type %s  dans la ligne %d\n",type,typeDonnee, line) ;
	}
%}
%union{
	/*SEMANTIC RECORD FOR RETURNING IDENTIFIERS*/
	int ival ;
	char *id ;
	float fval ;

}
%token INT FLOAT CHAR VOID FOR IF ELSE WHILE
%token PRINTF FNUM
%token <ival>  NUM
%token <id> IDENTIFIER STRING
%token INCLUDE INCR DECR
%token GE EE LE NE
%nonassoc ELSE
%type <ival> rel_expression
%type <fval> factor_rel


%start start

%%
start:
      INCLUDE start | function start | 
      ;

function:
	  type IDENTIFIER '(' arg ')'  compound_statement | 
	  type IDENTIFIER '(' type ')' ';' | 
	  type IDENTIFIER '(' arg  ')' ';'
	  ;

arg:
	type IDENTIFIER |
	;

compound_statement:
	  '{' statement_list '}' |
	  '{' '}'
	  ;

statement_list:
		statement | 
		statement statement_list 
		;

statement:
		declaration |
		assignment |
		for |
		if_else|
		whilestmnt |
		function_call |
		print |
		array 
		;

declaration:
		type identifier_list ';' ;

identifier_list:
		IDENTIFIER ',' identifier_list {install($1) ;} | 
		IDENTIFIER {install($1) ;}
		;

assignment:
		IDENTIFIER '=' expression ';' {if(context_check($1)==0)
		printf("La variable %s n'est pas declaree dans la ligne %d\n", $1, line) ;
		else { symboleVar *ss = recupererSym($1) ;  type_check(ss->type, t);}}
		;

expression:
		term expression_1 
		;

expression_1:
		'+' term expression_1 |
		'-' term expression_1 |
		;

term:
		factor term_1 
		;

term_1:
		'*' factor term_1 |
		'/' factor term_1 |
		;

factor:
		IDENTIFIER {if(context_check($1)==0)
		printf("La variable %s n'est pas declaree dans la ligne %d\n", $1, line) ; else {symboleVar *ss = recupererSym($1); if(!strcmp(ss->type, "int")) t = 3; else t = 4 ;}}|
		'(' expression ')' | 
		NUM {t = 3;} | FNUM {t = 4;} | STRING {t = 2;}
		;


rel_expression:
		factor_rel '<' factor_rel rel_expression {if($1<$3) $$=1; else $$=0;} |
		factor_rel '>' factor_rel rel_expression {if($1>$3) $$=1; else $$=0;} |		
		factor_rel LE  factor_rel rel_expression {if($1<=$3) $$=1; else $$=0;} |
		factor_rel GE  factor_rel rel_expression {if($1>=$3) $$=1; else $$=0;} |
		factor_rel EE  factor_rel rel_expression {if($1==$3) $$=1; else $$=0;} |
		factor_rel NE  factor_rel rel_expression {if($1!=$3) $$=1; else $$=0;} |
		{$$=0;}
		;

factor_rel:
		IDENTIFIER {if(context_check($1)==0)
		printf("La variable %s n'est pas declaree dans la ligne %d\n", $1, line)  ;} | NUM {$$=$1;}
		;
		

for:
		FOR '(' assignment  rel_expression  ';' update ')' compound_statement |

		FOR '(' assignment  rel_expression  ';' update ')' statement 
		;


whilestmnt:      WHILE '(' rel_expression ')' statement  
	        | WHILE '(' rel_expression ')' compound_statement 
	        ;

if_else:
		IF '(' rel_expression ')' compound_statement  |
		IF '(' rel_expression ')' compound_statement ELSE
		compound_statement 
		;

array:
		type IDENTIFIER '[' NUM ']' ';' {install($2) ;}      |
		type IDENTIFIER '[' NUM ']' '=' STRING ';' {install($2) ;}      |
		IDENTIFIER '[' NUM ']' '=' STRING ';' {if(context_check($1)==0)
		printf("La variable %s n'est pas declaree dans la ligne %d\n", $1, line) ;} |
		type IDENTIFIER '[' NUM ']' '=' NUM ';' {install($2) ;}      |
		IDENTIFIER '[' NUM ']' '=' NUM ';' {if(context_check($1)==0)
		printf("La variable %s n'est pas declaree dans la ligne %d\n", $1, line) ;} 
		;

function_call:
		IDENTIFIER '(' IDENTIFIER ')' ';'
		;

print:
		PRINTF'(' STRING ',' identifier_list ')' ';'   |
		PRINTF '(' STRING ')' ';' 
		;

update:
		IDENTIFIER INCR {if(context_check($1)==0)
		printf("La variable %s n'est pas declaree dans la ligne %d\n", $1, line) ;} | IDENTIFIER DECR {if(context_check($1)==0)
		printf("La variable %s n'est pas declaree dans la ligne %d\n", $1, line) ;} 
		;

type:
 		INT {temp = 3 ;}  | 
 		VOID {temp = 1 ;} | 
 		CHAR {temp = 2 ;} | 
 		FLOAT {temp = 4 ;}
 		;

%%
#include<ctype.h>
int main(int argc, char *argv[]){ 

	extern FILE *yyin;
	FILE *Fic_out;
   
	yyin = fopen( argv[1], "r" ); //change depending on test cases
	printf("\n resultat redirige vers le fichier data_txt.log");
	Fic_out=freopen("data_txt.log","w",stdout);
	   if(!yyparse()){
		printf("\n Output Completed\n");
	}
	else
		printf("\n Output failed \n");
        fclose(Fic_out);
	
	fclose(yyin);
	
	
	return 0 ;
}
/* Called by yyparse on error */
yyerror(char *s) {
	printf("l'erreur est dans la ligne %d , Type de l'erreur :  %s erreur avant  %s\n", line, s, yytext );
}