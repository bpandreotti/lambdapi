%{
open Parser

let build_prod : (string * p_term) list -> p_term -> p_term =
  List.fold_right (fun (x,a) b -> Pos.none (P_Prod(Pos.none x, Some(a), b)))

let build_abst : (string * p_term) list -> p_term -> p_term =
  List.fold_right (fun (x,a) b -> Pos.none (P_Abst(Pos.none x, Some(a), b)))

let build_config1 : string -> Eval.config = fun _ ->
  assert false (* TODO *)

let build_config2 : string -> string -> Eval.config = fun _ _ ->
  assert false (* TODO *)
%}

%token EOF
%token DOT
%token COMMA
%token COLON
%token EQUAL
%token ARROW
%token FATARROW
%token LONGARROW
%token DEF
%token LEFTPAR
%token RIGHTPAR
%token LEFTSQU
%token RIGHTSQU
%token EVAL
%token INFER
%token CHECK
%token CHECKNOT
%token ASSERT
%token ASSERTNOT
%token UNDERSCORE
%token <string> NAME
%token <string> REQUIRE
%token TYPE
%token KW_DEF
%token KW_THM
%token <string> ID
%token <string*string> QID

%start line
%type <Parser.p_cmd Pos.loc> line

%right ARROW FATARROW

%%

line:
  | s=ID ps=param* COLON a=term DOT
      { Pos.none (P_SymDecl(true, Pos.none s, build_prod ps a)) }
  | KW_DEF s=ID COLON a=term DOT
      { Pos.none (P_SymDecl(false, Pos.none s, a)) }
  | KW_DEF s=ID COLON a=term DEF t=term DOT
      { Pos.none (P_SymDef(false, Pos.none s, Some(a), t)) }
  | KW_DEF s=ID DEF t=term DOT
      { Pos.none (P_SymDef(false, Pos.none s,  None, t)) }
  | KW_DEF s=ID ps=param+ COLON a=term DEF t=term DOT
      { Pos.none (P_SymDef(false, Pos.none s, Some(build_prod ps a), build_abst ps t)) }
  | KW_DEF s=ID ps=param+ DEF t=term DOT
      { Pos.none (P_SymDef(false, Pos.none s, None, build_abst ps t)) }
  | KW_THM s=ID COLON a=term DEF t=term DOT
      { Pos.none (P_SymDef(true, Pos.none s, Some(a), t)) }
  | KW_THM s=ID ps=param+ COLON a=term DEF t=term DOT
      { Pos.none (P_SymDef(true, Pos.none s, Some(build_prod ps a), build_abst ps t)) }
  | rs=rule+ DOT
      { Pos.none (P_OldRules(rs)) }

  | EVAL t=term DOT
      { Pos.none (P_Eval(t, Eval.{strategy = SNF; steps = None})) }
  | EVAL c=eval_config t=term DOT
      { Pos.none (P_Eval(t, c)) }
  | INFER t=term DOT
      { Pos.none (P_Infer(t, Eval.{strategy = SNF; steps = None})) }
  | INFER c=eval_config t=term DOT
      { Pos.none (P_Infer(t, c)) }
  | CHECK     t=aterm COLON a=term DOT
      { Pos.none (P_TestType(false, false, t, a)) }
  | CHECKNOT  t=aterm COLON a=term DOT
      { Pos.none (P_TestType(false, true , t, a)) }
  | ASSERT    t=aterm COLON a=term DOT
      { Pos.none (P_TestType(true , false, t, a)) }
  | ASSERTNOT t=aterm COLON a=term DOT
      { Pos.none (P_TestType(true , true , t, a)) }

  | CHECK     t=aterm EQUAL u=term DOT
      { Pos.none (P_TestConv(false, false, t, u)) }
  | CHECKNOT  t=aterm EQUAL u=term DOT
      { Pos.none (P_TestConv(false, true , t, u)) }
  | ASSERT    t=aterm EQUAL u=term DOT
      { Pos.none (P_TestConv(true , false, t, u)) }
  | ASSERTNOT t=aterm EQUAL u=term DOT
      { Pos.none (P_TestConv(true , true , t, u)) }

  | NAME         DOT { Pos.none (P_Other(Pos.none "NAME")) }
  | r=REQUIRE    DOT { Pos.none (P_Require([r])) }
  | EOF              { raise End_of_file }

eval_config:
  | LEFTSQU s=ID RIGHTSQU              { build_config1 s }
  | LEFTSQU s1=ID COMMA s2=ID RIGHTSQU { build_config2 s1 s2 }

param:
  | LEFTPAR id=ID COLON te=term RIGHTPAR { (id, te) }

rule:
  | LEFTSQU c=context RIGHTSQU lhs=term LONGARROW rhs=term { (c, lhs, rhs ) }

context:
  | l=separated_list(COMMA, ID) { List.map (fun x -> (Pos.none x, None)) l }

%inline pid:
  | UNDERSCORE { "_" }
  | id=ID      { id }

sterm:
  | QID
      { let (m,id)=$1 in Pos.none (P_Vari(Pos.none([m], id))) }
  | id=pid
      { Pos.none (P_Vari(Pos.none([], id))) }
  | LEFTPAR t=term RIGHTPAR
      { t }
  | TYPE
      { Pos.none P_Type }

aterm:
  | t=sterm ts=sterm*
      { List.fold_left (fun t u -> Pos.none (P_Appl(t,u))) t ts }

term:
  | t=aterm
      { t }
  | x=pid COLON a=aterm ARROW b=term
      { Pos.none (P_Prod(Pos.none x, Some(a), b)) }
  | LEFTPAR x=ID COLON a=aterm RIGHTPAR ARROW b=term
      { Pos.none (P_Prod(Pos.none x, Some(a), b)) }
  | a=term ARROW b=term
      { Pos.none (P_Prod(Pos.none "_", Some(a), b)) }
  | x=pid FATARROW t=term
      { Pos.none (P_Abst(Pos.none x, None, t)) }
  | x=pid COLON a=aterm FATARROW t=term
      { Pos.none (P_Abst(Pos.none x, Some(a), t)) }
%%
