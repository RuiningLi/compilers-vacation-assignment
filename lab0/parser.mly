/* lab1/parser.mly */
/* Copyright (c) 2017 J. M. Spivey */

%{
open Tree
%}

%token <string>         IDENT
%token <float>          NUMBER 
%token                  PLUS MINUS TIMES DIVIDE OPEN CLOSE EQUAL EOF BADTOK

%type <string * Tree.expr>  equation

%start                  equation

%%

equation :
    expr EOF                            { ("it", $1) }
  | IDENT EQUAL expr EOF                { ($1, $3) } ;

expr :
    term                                { $1 }
  | expr PLUS term                      { Binop (Plus, $1, $3) }
  | expr MINUS term                     { Binop (Minus, $1, $3) } ;

term :
    factor                              { $1 }
  | term TIMES factor                   { Binop (Times, $1, $3) }
  | term DIVIDE factor                  { Binop (Divide, $1, $3) } ;

factor :
    NUMBER                              { Number $1 }
  | IDENT                               { Variable $1 }
  | OPEN expr CLOSE                     { $2 } ;

