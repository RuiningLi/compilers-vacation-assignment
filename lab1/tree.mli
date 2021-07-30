(* lab1/tree.mli *)
(* Copyright (c) 2017 J. M. Spivey *)

type ident = string

(* |name| -- type for applied occurrences, with annotations *)
type name = 
  { x_name: ident;              (* Name of the reference *)
    x_lab: string;              (* Global label *)
    x_line: int }               (* Line number *)

val make_name : ident -> int -> name


(* Abstract syntax *)

type program = Program of stmt

and stmt = 
    Skip 
  | Seq of stmt list
  | Assign of name * expr
  | Print of expr
  | Newline
  | IfStmt of expr * stmt * stmt
  | WhileStmt of expr * stmt

and expr = 
    Constant of int 
  | Variable of name
  | Monop of Keiko.op * expr 
  | Binop of Keiko.op * expr * expr

(* seq -- neatly join a list of statements into a sequence *)
val seq : stmt list -> stmt

val print_tree : out_channel -> program -> unit
