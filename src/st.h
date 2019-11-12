#include <string.h>
#include <stdlib.h>
struct symboleVar{
	char *name ;
	char type[10] ;
	struct symboleVar *next ;
};
//symboleVar symbol record
//st symbol
extern int scope_count ;
typedef struct symboleVar symboleVar ;
symboleVar *firstSymbole = (symboleVar *)0 ;
symboleVar *ajouterSym() ;
symboleVar *recupererSym() ;
symboleVar *ajouterSym(char *sym_name, int sym_type){
	char type[10] ;
	switch(sym_type){
		case 1:
			strcpy(type,"void");
			break;
		case 2:
			strcpy(type,"char");
			break;
		case 3:
			strcpy(type,"int");
			break;
		case 4:
			strcpy(type,"float");
			break;
	}
	symboleVar *ptr;
	ptr=(symboleVar *)malloc(sizeof(symboleVar));
	ptr->name=(char *)malloc(strlen(sym_name)+1);
	strcpy(ptr->name,sym_name);
	strcpy(ptr->type,type);
	ptr->next=(struct symboleVar *)firstSymbole;
	firstSymbole=ptr;
	return ptr;

}

symboleVar *recupererSym(char *sym_name)
{
	symboleVar *ptr;
	for(ptr=firstSymbole;ptr!=(symboleVar *)0;ptr=(symboleVar *)ptr->next)
	if(strcmp(ptr->name,sym_name)==0 && scope_count <2)
	return ptr;
	return 0;
}

