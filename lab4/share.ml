(* lab4/share.ml *)
(* Copyright (c) 2017 J. M. Spivey *)

open Print
open Optree
open Mach

let debug = false

(* |dagnode| -- node in DAG representation of an expression *)
type dagnode =
  { g_serial: int;                      (* Serial number *)
    g_op: inst;                         (* Operator *)
    g_rands: dagnode list;              (* Operands *)
    mutable g_refct: int;               (* Reference count *)
    mutable g_temp: int }               (* Temp, or -1 if none *)

let fNode g = fMeta "@$($)" [fNum g.g_serial; fNum g.g_refct]

(* |serial| -- fetch serial number of a node *)
let serial g = g.g_serial

(* |node_table| -- hash table for value numbering *)
let node_table = Hashtbl.create 129

(* |node_count| -- counter for numbering nodes *)
let node_count = ref 0

(* |newnode| -- create a new node *)
let newnode op rands = 
  incr node_count;
  List.iter (function g -> g.g_refct <- g.g_refct+1) rands;
  if debug then
    printf "@ Node @$ = $ [$]\n"
      [fNum !node_count; fInst op; fList(fNode) rands];
  { g_serial = !node_count; g_op = op; g_rands = rands; 
    g_refct = 0; g_temp = -1 }

(* |node| -- create a new node or share an existing one *)
let node op rands =
  let key = (op, List.map serial rands) in
  try Hashtbl.find node_table key with 
    Not_found -> 
      let n = newnode op rands in
      Hashtbl.add node_table key n; 
      n

(* |kill| -- remove LOAD nodes that satisfy a test *)
let kill p = 
  let deleted = Stack.create () in
  let f key g =
    match g with
        #<(LOADC|LOADW), a> ->
          if p a then Stack.push key deleted
      | _ -> () in
  Hashtbl.iter f node_table;
  Stack.iter (Hashtbl.remove node_table) deleted

(* |reset| -- clear the value numbering table *)
let reset () = 
  Hashtbl.clear node_table


(* Alias analysis: bitmaps would work here, but let's keep it abstract and
   use O'Caml's Set module. *)

type region = Stack | Data | Heap

module Arena = Set.Make(struct
  type t = region
  let compare = compare
end)

let a_local = Arena.of_list [Stack]
let a_global = Arena.of_list [Data]
let a_memory = Arena.of_list [Stack; Data; Heap]
let a_regvar = Arena.empty

let rec arena g =
  match g with
      #<LOCAL _> -> a_local
    | #<GLOBAL _> -> a_global
    | #<REGVAR _> -> a_regvar
    | #<OFFSET, base, _> -> arena base
    | _ -> a_memory

(* |disjoint| -- test if two arenas are free of overlap *)
let disjoint a b = Arena.is_empty (Arena.inter a b)

(* |alias| -- test if address g1 could be an alias for g2 *)
let alias g1 g2 =
  let simple =
    function LOCAL _ | GLOBAL _ | REGVAR _ -> true | _ -> false in

  if simple g1.g_op && simple g2.g_op then 
    (* Simple addresses that alias only if they are equal *)
    g1.g_op = g2.g_op 
  else
    (* Other addresses can alias only if their arenas intersect *)
    not (disjoint (arena g1) (arena g2))

let is_regvar = function <REGVAR _> -> true | _ -> false

(* |make_dag| -- convert an expression into a DAG *)
let rec make_dag t =
  match t with
      <STOREW, t1, t2> -> 
        make_store STOREW LOADW t1 t2
    | <STOREC, t1, t2> -> 
        make_store STOREC LOADC t1 t2
    | <LABEL lab> -> 
        reset (); node (LABEL lab) []
    | <CALL n, @ts> -> 
        (* Never share procedure calls *)
        let gs = List.map make_dag ts in
        kill (fun g -> true);
        newnode (CALL n) gs
    | <(ARG _|STATLINK) as op, t> ->
        newnode op [make_dag t]
    | <w, @ts> ->
        node w (List.map make_dag ts)

and make_store st ld t1 t2 =
  let g1 = make_dag t1 in
  let g2 = make_dag t2 in
  (* Kill all nodes that might alias the target location *)
  kill (alias g2); 
  (* Add dummy argument to detect use of stored value *)
  if is_regvar t2 then
    node st [g1; g2]
  else begin
    let g3 = node ld [g2] in
    g2.g_refct <- g2.g_refct-1; (* Ignore artificial ref from g3 *)
    node st [g1; g2; g3]
  end

(* |visit| -- convert dag to tree, sharing the root if worthwhile *)
let rec visit g top =
  match g.g_op with
      TEMP _ | LOCAL _ | REGVAR _ | CONST _ -> 
        build g (* Trivial *)
    | GLOBAL _  when not Mach.share_globals ->
        build g
    | CALL _ ->
        (* Procedure call -- always moved to top level *)
        if top then build g else share g
    | _ ->
        if top || g.g_refct = 1 then build g else share g

(* |build| -- convert dag to tree with no sharing at the root *)
and build g =
  (* The patterns #<...> match graphs rather than trees *)
  match g with
      #<CALL _, @p::args> ->
        (* Don't share constant procedure addresses *)
        let p' = 
          match p.g_op with GLOBAL _ -> build p | _ -> visit p false in
        let args' = List.map (fun g1 -> visit g1 true) args in
        <g.g_op, @(p'::args')>
    | #<(STOREC|STOREW), g1, g2, g3> ->
        (* If dummy value is used, then make it share with g1 *)
        let t1 = 
          if g3.g_refct > 1 then share g1 else visit g1 false in
        g3.g_temp <- g1.g_temp;
        <g.g_op, t1, visit g2 false>
    | #<op, @rands> -> 
        <op, @(List.map (fun g1 -> visit g1 false) rands)>

(* |share| -- convert dag to tree, sharing the root *)
and share g =
  if g.g_temp >= 0 then begin
    Regs.inc_temp g.g_temp;
    <TEMP g.g_temp>
  end else begin
    let d' = build g in
    match d' with
        (* No point in sharing register variables *)
        <(LOADC|LOADW), <REGVAR _>> -> d'
      | _ ->
          let n = Regs.new_temp 1 in 
          if debug then
            printf "@ Sharing $ as temp $\n" [fNode g; fNum n];
          g.g_temp <- n;
          <AFTER, <DEFTEMP n, d'>, <TEMP n>>
  end

let traverse ts = 
  reset (); 
  (* Convert the trees to a list of roots in a DAG *)
  let gs = List.map make_dag ts in
  (* Then convert the DAG roots back into trees *)
  canon <SEQ, @(List.map (fun g -> visit g true) gs)>
