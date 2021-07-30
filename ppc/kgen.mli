(* ppc/kgen.mli *)
(* Copyright (c) 2017 J. M. Spivey *)

(* |translate| -- generate intermediate code *)
val translate : Tree.program -> unit

(* |boundchk| -- flag to enable array bound and null pointer checks *)
val boundchk : bool ref

(* |optflag| -- flag to enable peephole optimiser *)
val optflag : bool ref
