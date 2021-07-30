(* lab1/lexer.mli *)
(* Copyright (c) 2017 J. M. Spivey *)

(* |token| -- scan the next token *)
val token : Lexing.lexbuf -> Parser.token
