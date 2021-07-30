(* lab1/main.ml *)
(* Copyright (c) 2017 J. M. Spivey *)

open Eval 
open Print

(* |parse_equation| -- parse a string as an equation *)
let parse_equation s = 
  Parser.equation Lexer.token (Lexing.from_string s)

(* |failure| -- print message after an exception *)
let failure msg =
  printf "Failed: $\n" [fStr msg]

(* |main| -- main read-eval-print loop *)
let main () =
  printf "Welcome to the world of arithmetic\n" [];
  try
    while true do
      printf "? " []; flush stdout;
      let line = input_line stdin in
      try
        let (x, e) = parse_equation line in
        let v = process (x, e) in
        printf "=> $\n" [fFlo v]
      with
          Failure msg -> failure msg
        | Not_found -> failure "not found"
        | Parsing.Parse_error -> failure "syntax error"
    done
  with End_of_file -> 
    printf "\nBye\n" []

let calc = main ()
