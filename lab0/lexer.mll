(* lab1/lexer.mll *)
(* Copyright (c) 2017 J. M. Spivey *)

{
open Parser 
open Lexing
}

rule token = 
  parse
      ['A'-'Z''a'-'z']['A'-'Z''a'-'z''0'-'9''_']* as s
                        { IDENT s }
    | ['0'-'9']+("."['0'-'9']+)? as s
                        { NUMBER (float_of_string s) }
    | "("               { OPEN }
    | ")"               { CLOSE }
    | "="               { EQUAL }
    | "+"               { PLUS }
    | "-"               { MINUS }
    | "*"               { TIMES }
    | "/"               { DIVIDE }
    | [' ''\t']+        { token lexbuf }
    | _                 { BADTOK }
    | eof               { EOF }

