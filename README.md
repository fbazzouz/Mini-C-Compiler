# Mini-C-Compiler
Mini C compiler using lex and yacc
# Les Fonctionnalités 
* Analyseur lexical :RegEx pour :  Les identificateurs , les nombres , for , while , if ,else , printf , return , les operations arithmétique ( + , -  , * ,  /) , les Tableaux , verification du fermeture et ouverture des ‘{‘ et ‘}’  ….
* Analyseur syntaxique : Declaration des fonctions , les includes , if et else , while , for , printf , les tableaux , les operations , les declaration …
* Analyseur Sémantique :

  * le semantique du if ( 0 si la condition est fausse , sinon 1) 
  * Implementation d’une table des symboles sous forme d’une liste chainée
  * Verification du variable si definie .
  * Generer les erreurs si un affectation pour un variable non definie.
  * Verifier si une affectation est de meme type .
* Redirection du resultat vers un fichier .log
