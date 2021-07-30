(* lab1/tree.mli *)
(* Copyright (c) 2017 J. M. Spivey *)

(* Abstract syntax *)

type expr =
    Number of float             (* Constant (value) *)
  | Variable of string          (* Variable (name) *)
  | Binop of op * expr * expr   (* Binary operator *)

and op = Plus | Minus | Times | Divide
