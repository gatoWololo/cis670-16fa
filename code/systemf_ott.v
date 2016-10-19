(* generated by Ott 0.25, locally-nameless lngen from: systemf.ott *)
Require Import Metalib.Metatheory.
(** syntax *)
Definition typ := var. (*r type variables *)
Definition x := var. (*r variables *)

Inductive Typ : Set :=  (*r type *)
 | t_var_b (_:nat) (*r variable *)
 | t_var_f (typ5:atom) (*r variable *)
 | t_arr (t1:Typ) (t2:Typ) (*r function *)
 | t_all (t:Typ) (*r polymorphic *).

Inductive Exp : Set :=  (*r expression *)
 | e_var_b (_:nat) (*r variable *)
 | e_var_f (x5:atom) (*r variable *)
 | e_lam (t:Typ) (e:Exp) (*r abstraction *)
 | e_ap (e1:Exp) (e2:Exp) (*r application *)
 | e_Lam (e:Exp) (*r type abstraction *)
 | e_App (e:Exp) (t:Typ) (*r type application *).

Definition D : Set := list typ.

Definition G : Set := list (x * Typ).

(* EXPERIMENTAL *)
(** auxiliary functions on the new list types *)
(** library functions *)
(** subrules *)
(** arities *)
(** opening up abstractions *)
Fixpoint open_Typ_wrt_Typ_rec (k:nat) (t_5:Typ) (t__6:Typ) {struct t__6}: Typ :=
  match t__6 with
  | (t_var_b nat) => 
      match lt_eq_lt_dec nat k with
        | inleft (left _) => t_var_b nat
        | inleft (right _) => t_5
        | inright _ => t_var_b (nat - 1)
      end
  | (t_var_f typ5) => t_var_f typ5
  | (t_arr t1 t2) => t_arr (open_Typ_wrt_Typ_rec k t_5 t1) (open_Typ_wrt_Typ_rec k t_5 t2)
  | (t_all t) => t_all (open_Typ_wrt_Typ_rec (S k) t_5 t)
end.

Fixpoint open_Exp_wrt_Exp_rec (k:nat) (e_5:Exp) (e__6:Exp) {struct e__6}: Exp :=
  match e__6 with
  | (e_var_b nat) => 
      match lt_eq_lt_dec nat k with
        | inleft (left _) => e_var_b nat
        | inleft (right _) => e_5
        | inright _ => e_var_b (nat - 1)
      end
  | (e_var_f x5) => e_var_f x5
  | (e_lam t e) => e_lam t (open_Exp_wrt_Exp_rec (S k) e_5 e)
  | (e_ap e1 e2) => e_ap (open_Exp_wrt_Exp_rec k e_5 e1) (open_Exp_wrt_Exp_rec k e_5 e2)
  | (e_Lam e) => e_Lam (open_Exp_wrt_Exp_rec k e_5 e)
  | (e_App e t) => e_App (open_Exp_wrt_Exp_rec k e_5 e) t
end.

Fixpoint open_Exp_wrt_Typ_rec (k:nat) (t5:Typ) (e_5:Exp) {struct e_5}: Exp :=
  match e_5 with
  | (e_var_b nat) => e_var_b nat
  | (e_var_f x5) => e_var_f x5
  | (e_lam t e) => e_lam (open_Typ_wrt_Typ_rec k t5 t) (open_Exp_wrt_Typ_rec k t5 e)
  | (e_ap e1 e2) => e_ap (open_Exp_wrt_Typ_rec k t5 e1) (open_Exp_wrt_Typ_rec k t5 e2)
  | (e_Lam e) => e_Lam (open_Exp_wrt_Typ_rec (S k) t5 e)
  | (e_App e t) => e_App (open_Exp_wrt_Typ_rec k t5 e) (open_Typ_wrt_Typ_rec k t5 t)
end.

Definition open_Exp_wrt_Exp e_5 e__6 := open_Exp_wrt_Exp_rec 0 e__6 e_5.

Definition open_Exp_wrt_Typ t5 e_5 := open_Exp_wrt_Typ_rec 0 e_5 t5.

Definition open_Typ_wrt_Typ t_5 t__6 := open_Typ_wrt_Typ_rec 0 t__6 t_5.

(** terms are locally-closed pre-terms *)
(** definitions *)

(* defns LC_Typ *)
Inductive lc_Typ : Typ -> Prop :=    (* defn lc_Typ *)
 | lc_t_var_f : forall (typ5:typ),
     (lc_Typ (t_var_f typ5))
 | lc_t_arr : forall (t1 t2:Typ),
     (lc_Typ t1) ->
     (lc_Typ t2) ->
     (lc_Typ (t_arr t1 t2))
 | lc_t_all : forall (t:Typ),
      ( forall typ5 , lc_Typ  ( open_Typ_wrt_Typ t (t_var_f typ5) )  )  ->
     (lc_Typ (t_all t)).

(* defns LC_Exp *)
Inductive lc_Exp : Exp -> Prop :=    (* defn lc_Exp *)
 | lc_e_var_f : forall (x5:x),
     (lc_Exp (e_var_f x5))
 | lc_e_lam : forall (t:Typ) (e:Exp),
     (lc_Typ t) ->
      ( forall x5 , lc_Exp  ( open_Exp_wrt_Exp e (e_var_f x5) )  )  ->
     (lc_Exp (e_lam t e))
 | lc_e_ap : forall (e1 e2:Exp),
     (lc_Exp e1) ->
     (lc_Exp e2) ->
     (lc_Exp (e_ap e1 e2))
 | lc_e_Lam : forall (e:Exp),
      ( forall typ5 , lc_Exp  ( open_Exp_wrt_Typ e (t_var_f typ5) )  )  ->
     (lc_Exp (e_Lam e))
 | lc_e_App : forall (e:Exp) (t:Typ),
     (lc_Exp e) ->
     (lc_Typ t) ->
     (lc_Exp (e_App e t)).
(** free variables *)
Fixpoint tt_fv_Typ (t_5:Typ) : vars :=
  match t_5 with
  | (t_var_b nat) => {}
  | (t_var_f typ5) => {{typ5}}
  | (t_arr t1 t2) => (tt_fv_Typ t1) \u (tt_fv_Typ t2)
  | (t_all t) => (tt_fv_Typ t)
end.

Fixpoint tt_fv_Exp (e_5:Exp) : vars :=
  match e_5 with
  | (e_var_b nat) => {}
  | (e_var_f x5) => {}
  | (e_lam t e) => (tt_fv_Typ t) \u (tt_fv_Exp e)
  | (e_ap e1 e2) => (tt_fv_Exp e1) \u (tt_fv_Exp e2)
  | (e_Lam e) => (tt_fv_Exp e)
  | (e_App e t) => (tt_fv_Exp e) \u (tt_fv_Typ t)
end.

Fixpoint e_fv_Exp (e_5:Exp) : vars :=
  match e_5 with
  | (e_var_b nat) => {}
  | (e_var_f x5) => {{x5}}
  | (e_lam t e) => (e_fv_Exp e)
  | (e_ap e1 e2) => (e_fv_Exp e1) \u (e_fv_Exp e2)
  | (e_Lam e) => (e_fv_Exp e)
  | (e_App e t) => (e_fv_Exp e)
end.

(** substitutions *)
Fixpoint t_subst_Typ (t_5:Typ) (ryp5:typ) (t__6:Typ) {struct t__6} : Typ :=
  match t__6 with
  | (t_var_b nat) => t_var_b nat
  | (t_var_f typ5) => (if eq_var typ5 ryp5 then t_5 else (t_var_f typ5))
  | (t_arr t1 t2) => t_arr (t_subst_Typ t_5 ryp5 t1) (t_subst_Typ t_5 ryp5 t2)
  | (t_all t) => t_all (t_subst_Typ t_5 ryp5 t)
end.

Fixpoint e_subst_Exp (e_5:Exp) (y5:x) (e__6:Exp) {struct e__6} : Exp :=
  match e__6 with
  | (e_var_b nat) => e_var_b nat
  | (e_var_f x5) => (if eq_var x5 y5 then e_5 else (e_var_f x5))
  | (e_lam t e) => e_lam t (e_subst_Exp e_5 y5 e)
  | (e_ap e1 e2) => e_ap (e_subst_Exp e_5 y5 e1) (e_subst_Exp e_5 y5 e2)
  | (e_Lam e) => e_Lam (e_subst_Exp e_5 y5 e)
  | (e_App e t) => e_App (e_subst_Exp e_5 y5 e) t
end.

Fixpoint t_subst_Exp (t5:Typ) (ryp5:typ) (e_5:Exp) {struct e_5} : Exp :=
  match e_5 with
  | (e_var_b nat) => e_var_b nat
  | (e_var_f x5) => e_var_f x5
  | (e_lam t e) => e_lam (t_subst_Typ t5 ryp5 t) (t_subst_Exp t5 ryp5 e)
  | (e_ap e1 e2) => e_ap (t_subst_Exp t5 ryp5 e1) (t_subst_Exp t5 ryp5 e2)
  | (e_Lam e) => e_Lam (t_subst_Exp t5 ryp5 e)
  | (e_App e t) => e_App (t_subst_Exp t5 ryp5 e) (t_subst_Typ t5 ryp5 t)
end.


(** definitions *)

(* defns Jtype *)
Inductive type : D -> Typ -> Prop :=    (* defn type *)
 | type_var : forall (D5:D) (typ5:typ),
      In  typ5   D5  ->
     type D5 (t_var_f typ5)
 | type_arr : forall (D5:D) (t1 t2:Typ),
     type D5 t1 ->
     type D5 t2 ->
     type D5 (t_arr t1 t2)
 | type_all : forall (L:vars) (D5:D) (t:Typ),
      ( forall typ5 , typ5 \notin  L  -> type  ( typ5  ::  D5 )   ( open_Typ_wrt_Typ t (t_var_f typ5) )  )  ->
     type D5 (t_all t).

(* defns Jexp *)
Inductive exp : D -> G -> Exp -> Typ -> Prop :=    (* defn exp *)
 | exp_var : forall (D5:D) (G5:G) (x5:x) (t:Typ),
     type D5 t ->
      In ( x5 ,  t )  G5  ->
     exp D5 G5 (e_var_f x5) t
 | exp_lam : forall (L:vars) (D5:D) (G5:G) (t1:Typ) (e:Exp) (t2:Typ),
     type D5 t1 ->
      ( forall x5 , x5 \notin  L  -> exp D5  (( x5 ,  t1 ) ::  G5 )   ( open_Exp_wrt_Exp e (e_var_f x5) )  t2 )  ->
     exp D5 G5 (e_lam t1 e) (t_arr t1 t2)
 | exp_ap : forall (D5:D) (G5:G) (e1 e2:Exp) (t t2:Typ),
     exp D5 G5 e1 (t_arr t2 t) ->
     exp D5 G5 e2 t2 ->
     exp D5 G5 (e_ap e1 e2) t
 | exp_Lam : forall (L:vars) (D5:D) (G5:G) (e:Exp) (t:Typ),
      ( forall typ5 , typ5 \notin  L  -> exp  ( typ5  ::  D5 )  G5  ( open_Exp_wrt_Typ e (t_var_f typ5) )   ( open_Typ_wrt_Typ t (t_var_f typ5) )  )  ->
     exp D5 G5 (e_Lam e) (t_all t)
 | exp_App : forall (D5:D) (G5:G) (e:Exp) (t t':Typ),
     exp D5 G5 e (t_all t') ->
     type D5 t ->
     exp D5 G5 (e_App e t)  (open_Typ_wrt_Typ  t' t ) .

(* defns Jdynamics *)
Inductive val : Exp -> Prop :=    (* defn val *)
 | val_lam : forall (t:Typ) (e:Exp),
     lc_Typ t ->
     lc_Exp (e_lam t e) ->
     val (e_lam t e)
 | val_Lam : forall (e:Exp),
     lc_Exp (e_Lam e) ->
     val (e_Lam e)
with red : Exp -> Exp -> Prop :=    (* defn red *)
 | red_lam : forall (t1:Typ) (e e2:Exp),
     lc_Typ t1 ->
     lc_Exp (e_lam t1 e) ->
     val e2 ->
     red (e_ap (e_lam t1 e) e2)  (open_Exp_wrt_Exp  e   e2 ) 
 | red_ap1 : forall (e1 e2 e1':Exp),
     lc_Exp e2 ->
     red e1 e1' ->
     red (e_ap e1 e2) (e_ap e1' e2)
 | red_ap2 : forall (e1 e2 e2':Exp),
     val e1 ->
     red e2 e2' ->
     red (e_ap e1 e2) (e_ap e1 e2')
 | red_Lam : forall (e:Exp) (t:Typ),
     lc_Exp (e_Lam e) ->
     lc_Typ t ->
     red (e_App (e_Lam e) t)  (open_Exp_wrt_Typ  e   t ) 
 | red_App : forall (e:Exp) (t:Typ) (e':Exp),
     lc_Typ t ->
     red e e' ->
     red (e_App e t) (e_App e' t).

(* defns Jequiv *)
Inductive eq : D -> G -> Exp -> Exp -> Typ -> Prop :=    (* defn eq *)
 | eq_ap : forall (L:vars) (D5:D) (G5:G) (t1:Typ) (e2 e1:Exp) (t2:Typ),
      ( forall x5 , x5 \notin  L  -> exp D5  (( x5 ,  t1 ) ::  G5 )   ( open_Exp_wrt_Exp e2 (e_var_f x5) )  t2 )  ->
     exp D5 G5 e1 t1 ->
     eq D5 G5 (e_ap  ( (e_lam t1 e2) )  e1)  (open_Exp_wrt_Exp  e2   e1 )  t2
 | eq_App : forall (L:vars) (D5:D) (G5:G) (e:Exp) (r t:Typ),
      ( forall typ5 , typ5 \notin  L  -> exp  ( typ5  ::  D5 )  G5  ( open_Exp_wrt_Typ e (t_var_f typ5) )  t )  ->
     type D5 r ->
     eq D5 G5 (e_App (e_Lam e) r)  (open_Exp_wrt_Typ  e   r )  t.


(** infrastructure *)
Hint Constructors type exp val red eq lc_Typ lc_Exp.


