Require Export Foundations.Generalities.uu0.

Unset Automatic Introduction.


(** ** To ustream files of the library *)

Notation hfppru := hfpg' .

Notation hfpprl := hfpg . 

Notation fromunit := termfun .


(** To homotopies *)

Definition idhomot { X Y : UU } ( f : X -> Y ) : homot f f := fun x => idpath ( f x ) . 


(** To hfiber. *)


Definition tohfiber { X Y : UU } ( f : X -> Y ) ( x : X ) : hfiber f ( f x ) := hfiberpair f x ( idpath _ ) . 

(** To hfp *)

Definition hfptriple { X X' Y:UU} (f:X -> Y) (f':X' -> Y) ( x : X ) ( x' : X' ) ( h : paths ( f' x' ) ( f x ) ) : 
hfp f f' := tpair ( fun xx' : dirprod X X'  => paths ( f' ( pr2 xx' ) ) ( f ( pr1 xx' ) ) )  ( dirprodpair x x' ) h .

Definition tohfpfiber { X Y : UU } ( f : X -> Y ) ( x : X ) : hfp ( fromunit ( f x ) ) f := 
hfptriple ( fromunit ( f x ) )  f tt x ( idpath ( f x ) ) .  

(** Functoriality of hfp. *)

Lemma hfplhomot { X Y Z : UU } { fl1 fl2 : X -> Y } ( h : homot fl1 fl2 ) ( gr : Z -> Y ) 
: weq ( hfp fl1 gr ) ( hfp fl2 gr ) .
Proof . intros . refine ( weqgradth _ _ _ _ ) .  

{ intro xze . destruct xze as [ xz e ] . split with xz .  exact (pathscomp0 e (h (pr1 xz))) . }

{ intro xze . destruct xze as [ xz e ] . split with xz .  exact (pathscomp0 e ( pathsinv0 (h (pr1 xz)))) . }

{ intro xze . destruct xze as [ xz e ] . apply ( maponpaths ( fun ee => tpair _ xz ee ) ) .  destruct ( h ( pr1 xz ) ) . 
destruct e . apply idpath . } 

{  intro xze .  destruct xze as [ xz e ] . apply ( maponpaths ( fun ee => tpair _ xz ee ) ) . destruct (h (pr1 xz)) . 
destruct e . apply idpath . }

Defined . 

Lemma hfprhomot { X Y Z : UU } ( fl : X -> Y ) { gr1 gr2 : Z -> Y } ( h : homot gr1 gr2 ) :
 weq ( hfp fl gr1 ) ( hfp fl gr2 ) .
Proof . intros . refine ( weqgradth _ _ _ _ ) .  

{ intro xze . destruct xze as [ xz e ] . split with xz .  exact (pathscomp0 ( pathsinv0 (h (pr2 xz))) e) . }

{ intro xze . destruct xze as [ xz e ] . split with xz .  exact (pathscomp0 (h (pr2 xz)) e) . }

{ intro xze . destruct xze as [ xz e ] . apply ( maponpaths ( fun ee => tpair _ xz ee ) ) .  destruct ( h ( pr2 xz ) ) . 
destruct e . apply idpath . } 

{  intro xze .  destruct xze as [ xz e ] . apply ( maponpaths ( fun ee => tpair _ xz ee ) ) . destruct (h (pr2 xz)) . 
destruct e . apply idpath . }

Defined . 


Lemma hfpcube { X X' Y Z Zt Xt' : UU } ( f : X -> Y ) ( g : Z -> X ) ( f' : X' -> Y ) ( g' : Z -> X' ) ( gt : Zt -> X ) 
( ft' : Xt' -> Y ) ( gt' : Zt -> Xt' ) ( h_back : commsqstr g' f' g f ) ( h_up : commsqstr gt' ft' gt f ) ( x : hfp gt g ) :
 hfp ft' f' . 
Proof . intros .  split with ( dirprodpair ( gt' ( pr1 ( pr1 x ) ) ) ( g' ( pr2 ( pr1 x ) ) ) ) . destruct x as [ x e ] . simpl . 
 destruct x as [ zt z ] . 
 simpl .  simpl in e .  destruct ( pathsinv0 ( h_back z ) ) . destruct ( pathsinv0 ( h_up zt ) ) . exact ( maponpaths f e ) .
 Defined.

Lemma hfpcube_h_front { X X' Y Z Zt Xt' : UU } ( f : X -> Y ) ( g : Z -> X ) ( f' : X' -> Y ) ( g' : Z -> X' ) ( gt : Zt -> X ) 
( ft' : Xt' -> Y ) ( gt' : Zt -> Xt' ) ( h_back : commsqstr g' f' g f ) ( h_up : commsqstr gt' ft' gt f ) :
 commsqstr ( hfpcube f g f' g' gt ft' gt' h_back h_up ) ( hfpprl ft' f' ) ( hfpprl gt g ) gt'  . 
Proof. intros .  intro z . apply idpath . Defined.


Lemma hfpcube_h_down { X X' Y Z Zt Xt' : UU } ( f : X -> Y ) ( g : Z -> X ) ( f' : X' -> Y ) ( g' : Z -> X' ) ( gt : Zt -> X ) 
( ft' : Xt' -> Y ) ( gt' : Zt -> Xt' ) ( h_back : commsqstr g' f' g f ) ( h_up : commsqstr gt' ft' gt f ) :
 commsqstr ( hfpcube f g f' g' gt ft' gt' h_back h_up )  ( hfppru ft' f' ) ( hfppru gt g ) g' . 
Proof. intros .  intro z . apply idpath . Defined.







(** Double pull-backs  ( cf. two_pullbacks_isequiv in hott-limits ) . *)

Definition doublehfp_from { Tll' Tll Tlr Tur } ( f'l : Tll' -> Tll ) ( fl : Tll -> Tlr ) ( gr : Tur -> Tlr ) 
( xyh' : hfp f'l ( hfpprl fl gr ) ) : hfp ( funcomp f'l fl ) gr . 
Proof. intros . destruct xyh' as [ [ x' [ [ x y ] h ] ] h' ] . set ( hflh' :=  pathscomp0 h ( maponpaths fl h' ) ) .
 exact ( hfptriple ( funcomp f'l fl ) gr x' y hflh' ) . Defined. 

 
Definition doublehfp_to { Tll' Tll Tlr Tur } ( f'l : Tll' -> Tll ) ( fl : Tll -> Tlr ) ( gr : Tur -> Tlr )  
( x'yh' : hfp ( funcomp f'l fl ) gr ) : hfp f'l ( hfpprl fl gr ) . 
Proof. intros . destruct x'yh' as [ [ x' y ] h' ] . exact ( hfptriple f'l ( hfpprl fl gr ) x' ( hfptriple fl gr ( f'l x' ) y h' ) 
( idpath _ ) ) . Defined. 


Definition doublehfp_to_from { Tll' Tll Tlr Tur } ( f'l : Tll' -> Tll ) ( fl : Tll -> Tlr ) ( gr : Tur -> Tlr ) :
 homot ( funcomp ( doublehfp_to f'l fl gr ) ( doublehfp_from f'l fl gr ) ) ( idfun ( hfp ( funcomp f'l fl ) gr ) ). 
Proof. intros . intro xyh . destruct xyh as [ [ x y ] h ] .  unfold doublehfp_to . unfold doublehfp_from. unfold funcomp . 
unfold hfppru. unfold hfpprl . unfold idfun .  simpl .  simpl in h . rewrite ( @pathscomp0rid _ _ (fl (f'l x)) h ) . 
 apply idpath . Defined . 

Lemma doublehfp_from_to_l1 { Tll Tlr Tur } ( fl : Tll -> Tlr ) ( gr : Tur -> Tlr ) ( x0 : Tll ) ( z : hfiber ( hfpprl fl gr ) x0 ) :
 hfiber ( hfpprl fl gr ) x0 .
Proof . intros .  destruct z as [ [ [ x y ] h ] h0 ] . 
 exact ( tohfiber ( hfpprl fl gr ) ( hfptriple fl gr x0 y ( pathscomp0 h ( maponpaths fl h0 ) ) ) ) . Defined.  

Lemma doublehfp_from_to_l2 { Tll Tlr Tur } ( fl : Tll -> Tlr ) ( gr : Tur -> Tlr ) ( x0 : Tll ) :
 homot ( doublehfp_from_to_l1 fl gr x0 ) ( idfun _ ) . 
Proof. intros . intro z .  destruct z as [ [ [ x y ] h ] h0 ] . destruct h0 . unfold idfun . simpl .  unfold hfpprl .    simpl .
 rewrite ( @pathscomp0rid _ ( gr y ) ( fl x ) h ) . apply idpath . Defined . 

Definition doublehfp_from_to { Tll' Tll Tlr Tur } ( f'l : Tll' -> Tll ) ( fl : Tll -> Tlr ) ( gr : Tur -> Tlr ) :
 homot ( funcomp  ( doublehfp_from f'l fl gr ) ( doublehfp_to f'l fl gr ) ) ( idfun ( hfp f'l ( hfpprl fl gr ) ) ).
Proof. intros .  intro x'yh' . destruct x'yh' as [ [ x' xyh ] h' ] .  simpl in h'. unfold hfpprl in h' .   simpl in h'.  
unfold idfun . unfold funcomp. unfold doublehfp_to. unfold doublehfp_from. unfold hfpprl . unfold hfppru .   simpl . 
  set ( x0 := f'l x' ) .  set ( e := doublehfp_from_to_l2 fl gr x0 ( hfiberpair ( hfpprl fl gr ) xyh h' ) ) .  
set ( phi := fun xyhh' : hfiber ( hfpprl fl gr ) x0 => hfptriple f'l ( hfpprl fl gr ) x' ( pr1 xyhh') ( pr2 xyhh' ) ) . 
destruct xyh as [ [ x y ] h ] .   exact ( maponpaths phi e ) .   Defined.       
 

Lemma isweq_doublehfp_from { Tll' Tll Tlr Tur } ( f'l : Tll' -> Tll ) ( fl : Tll -> Tlr ) ( gr : Tur -> Tlr ) :
 isweq ( doublehfp_from f'l fl gr ) . 
Proof . intros . apply gradth with ( doublehfp_to f'l fl gr ) .  exact ( doublehfp_from_to f'l fl gr ) .
 exact ( doublehfp_to_from f'l fl gr ) . Defined. 


(** Note: change these in uu0.v *)
 
Definition hfibersgtof'  { X X' Y Z : UU } ( f : X -> Y ) ( f' : X' -> Y ) ( g : Z -> X ) ( g' : Z -> X' ) 
( h : commsqstr g' f' g f ) ( x : X ) ( ze : hfiber g x ) : hfiber f' ( f x )  .
Proof. intros . split with ( g' ( pr1 ze ) ) .    apply ( pathscomp0  ( h ( pr1 ze ) )  ( maponpaths f ( pr2 ze ) )  ) . Defined . 

Definition hfibersg'tof  { X X' Y Z : UU } ( f : X -> Y ) ( f' : X' -> Y ) ( g : Z -> X ) ( g' : Z -> X' ) 
( h : commsqstr g' f' g f ) ( x' : X' ) ( ze : hfiber g' x' ) : hfiber f ( f' x' )  .
Proof. intros . split with ( g ( pr1 ze ) ) .    apply ( pathscomp0 ( pathsinv0 ( h ( pr1 ze ) ) ) ( maponpaths f' ( pr2 ze ) ) ) .
 Defined . 

(** To uu0.v *)

Definition pathstofun { X Y : UU } ( e : paths X Y ) : X -> Y .
Proof. intros X Y e x. destruct e . apply x .  Defined.  

Notation app1 := toforallpaths. 

Implicit Arguments app1 [ T P f g ] . 

(** To uu0.v after funextsec *)

Definition hfunextsecapp1 { T : UU } ( P : T -> UU ) { s1 s2 : forall t:T, P t} ( e : paths s1 s2 ) :
 paths ( funextsec P s1 s2 ( fun t => app1 e t ) ) e . 
Proof.  intros . apply ( homotweqinvweq ( weqfunextsec P s1 s2 ) e ) . Defined. 


Definition happ1funextsec { T : UU } ( P : T -> UU ) { s1 s2 : forall t:T, P t } ( e : forall t:T, paths (s1 t) (s2 t) ) ( t : T ) :
 paths ( app1 ( funextsec P s1 s2 e ) t ) ( e t ) . 
Proof.  intros . set ( int := homotinvweqweq ( weqfunextsec P s1 s2 ) e ) .  apply ( app1 int t ) .  Defined . 


(** Paths in total2 *)

Definition topathsintotal2 { X : UU } ( P : X -> UU ) ( x1 x2 : total2 P ) ( e : paths ( pr1 x1 ) ( pr1 x2 ) ) 
( ee : paths ( transportf P e ( pr2 x1 ) ) ( pr2 x2 ) ) : paths x1 x2 .
Proof. intros. destruct x1 as [ x11 x12 ]. destruct x2 as [ x21 x22 ]. set (int := pr1 ( pr2 ( constr1 P e ) ) x12 ). 
 apply ( pathscomp0 int ( maponpaths ( fun p => tpair P x21 p ) ee ) ) . Defined.






(** ** Pre-towers and towers of types 

A tower of types can be viewed either as an infinite sequence of functions ... -> T_{n+1} -> T_n -> ... -> T_0 or as a
 coinductive object as in [tower] below.
We call such infinite sequences of functions pre-towers and coinductive opbjects towers. 
In its coinductive version a tower is essentially a rooted tree of infinite (countable) depth with the collection of
 branches leaving each node parametrized by a  arbitrary type. 


*)

(** *** Pre-towers of types - the sequence of functions definition. *)

Definition pretowerP := ( fun T : nat -> UU => forall n : nat , T ( S n ) -> T n ) .

Definition pretower := total2 pretowerP . 

Definition pretowerpair ( T : nat -> UU ) ( p : forall n : nat , T ( S n ) -> T n ) : pretower :=
 tpair ( fun T : nat -> UU => forall n : nat , T ( S n ) -> T n ) T p . 

Definition preTn ( pT : pretower ) ( n : nat ) : UU := pr1 pT n .

Coercion preTn : pretower >-> Funclass .  

Definition pretowerpn ( pT : pretower ) ( n : nat ) : pT ( S n ) -> pT n := pr2 pT n . 








(** Equalities of pre-towers *)


Definition ptintpaths ( pT pT' : pretower ) : UU := 
total2 ( fun e : forall n : nat , paths ( pT n ) ( pT' n ) =>
 forall n : nat , paths ( funcomp ( pathstofun ( pathsinv0 ( e ( S n ) ) ) ) 
( funcomp ( pretowerpn pT n ) ( pathstofun ( e n ) ) ) ) ( pretowerpn pT' n ) ) .


Definition ptintpathstopaths_a ( pT : pretower ) ( ppT' : nat -> UU ) ( e : paths ( pr1 pT ) ppT' ) :
 paths ( transportf pretowerP e ( pr2 pT ) ) 
( fun n : nat => 
funcomp ( funcomp ( pathstofun ( pathsinv0 ( app1 e ( S n ) ) ) ) ( pretowerpn pT n  ) ) ( pathstofun ( app1 e n ) ) )  . 
Proof. intros. destruct e . apply idpath . Defined. 


Definition ptintpathstopaths ( pT pT' : pretower ) ( eneen : ptintpaths pT pT' ) : paths pT pT' . 
Proof.  intros . set ( int := funextfun _ _ ( pr1 eneen ) ) .  set ( int2 := pr2 eneen ) .  
refine ( topathsintotal2 pretowerP _ _ _ _ ).

apply int . 

apply ( pathscomp0 (ptintpathstopaths_a pT ( pr1 pT' ) int ) ) . 

apply funextsec .  intro n . 

set ( es1 := ( app1 int n ) ) . assert ( e1 : paths es1 ( pr1 eneen n ) ) .  apply ( happ1funextsec _ ( pr1 eneen ) n ) . 

set ( es2 := ( pathsinv0 ( app1 int ( S n ) ) ) ) . assert ( e2 : paths es2 ( pathsinv0 ( pr1 eneen ( S n ) ) ) )  .  
apply ( maponpaths ( fun e => pathsinv0 e ) ) . apply ( happ1funextsec _ ( pr1 eneen ) ( S n ) ) .

change  (paths
     (fun x' : pr1 pT' (S n) =>
      pathstofun es1
        (pretowerpn pT n (pathstofun es2 x')))
     (pr2 pT' n)) . rewrite e1 . rewrite e2 . 

apply ( pr2 eneen ) .  Defined . 






(** Pre-tower functions. *)

Definition pretowerfun ( pT pT' : pretower ) : UU := total2 ( fun fn : forall n : nat , pT n -> pT' n => 
forall n : nat , homot ( funcomp ( fn ( S n ) ) ( pretowerpn pT' n ) ) ( funcomp ( pretowerpn pT n ) ( fn n ) ) ) . 

Definition pretowerfunconstr ( pT pT' : pretower ) ( fn : forall n : nat , pT n -> pT' n ) 
( hn : forall n : nat , homot ( funcomp ( fn ( S n ) ) ( pretowerpn pT' n ) ) ( funcomp ( pretowerpn pT n ) ( fn n ) ) ) :
 pretowerfun pT pT' := tpair _ fn hn . 

Definition prefn { pT pT' : pretower } ( f : pretowerfun pT pT' ) ( n : nat ) : pT n -> pT' n := pr1 f n . 

Coercion prefn : pretowerfun >-> Funclass .  

Definition prehn { pT pT' : pretower }  ( f : pretowerfun pT pT' ) ( n : nat ) :
 homot ( funcomp ( prefn f ( S n ) ) ( pretowerpn pT' n ) ) ( funcomp ( pretowerpn pT n ) ( prefn f n ) ) := pr2 f n . 

Definition pretowerweq ( pT pT' : pretower ) : UU := total2 ( fun f : pretowerfun pT pT' => forall n : nat , isweq ( prefn f n ) ) . 

Definition pretoweridfun ( T : pretower ) : pretowerfun T T := 
pretowerfunconstr T T ( fun n => idfun _ ) ( fun n => fun z => idpath _ ) .

Definition pretowerfuncomp { T T' T'' : pretower } ( f : pretowerfun T T' ) ( g : pretowerfun T' T'' ) :
 pretowerfun T T'' := pretowerfunconstr T T'' ( fun n => funcomp ( f n ) ( g n ) ) 
( fun n => fun z => pathscomp0 ( prehn g n ( f ( S n ) z ) ) ( maponpaths ( g n ) ( prehn f n z ) ) ) . 









(** Pre-tower shifts *)

Definition pretoweroneshift ( pT : pretower )  : pretower := 
pretowerpair ( fun n => pT ( S n ) ) ( fun n => pretowerpn pT ( S n ) ) .   

Definition pretowerfunoneshift { pT pT' : pretower } ( f : pretowerfun pT pT' ) :
 pretowerfun ( pretoweroneshift pT ) ( pretoweroneshift pT' ) := 
pretowerfunconstr   ( pretoweroneshift pT ) ( pretoweroneshift pT' ) ( fun n => f ( S n ) ) ( fun n => prehn f ( S n ) ) . 

Definition pretoweroneshiftfunct { pT pT' : pretower } ( f : pretowerfun pT pT' ) : pretowerfun ( pretoweroneshift pT ) ( pretoweroneshift pT' ) .
Proof . intros.  refine ( tpair _ _ _ ) . 

intro n . exact ( pr1 f ( S n ) ) . 

intro n . exact ( pr2 f ( S n ) ) .  Defined.


Definition pretowernshift ( n : nat ) ( pT : pretower ) : pretower .
Proof. intros . induction n as [| n IHn] . exact pT . exact ( pretoweroneshift IHn ). Defined. 











(** Pre-tower pull-backs *) 


Definition pretowerpb_a ( pT : pretower ) { X : UU } ( f : X -> pT 0 ) ( n : nat ) :
 total2 ( fun pretowerpbsn : UU => pretowerpbsn -> pT n ) . 
Proof . intros . induction n .

split with X . exact f . 

split with ( hfp ( pr2 IHn ) ( pretowerpn pT n ) ) . exact ( hfppru ( pr2 IHn ) ( pretowerpn pT n ) ) .  Defined. 

Definition pretowerpb ( pT : pretower ) { X : UU } ( f : X -> pT 0 ) : pretower := 
pretowerpair ( fun n => pr1 ( pretowerpb_a pT f n ) ) ( fun n => hfpprl ( pr2 ( pretowerpb_a pT f n ) ) ( pretowerpn pT n ) ) .

Definition pretowerpbpr ( pT : pretower ) { X : UU } ( f : X -> pT 0 ) :
 pretowerfun ( pretowerpb pT f ) pT := pretowerfunconstr ( pretowerpb pT f ) pT ( fun n => pr2 ( pretowerpb_a pT f n ) ) 
( fun n => commhfp ( pr2 ( pretowerpb_a pT f n ) ) ( pretowerpn pT n ) ) . 



Definition pretowerfunct_a { pT' pT : pretower } { X X' : UU } ( g' : X' -> pT' 0 ) ( f' : pretowerfun pT' pT ) ( g : X' -> X ) 
( f : X -> pT 0 ) ( h : commsqstr g f g' ( f' 0 ) ) ( n : nat ) :
 total2 ( fun fto : pretowerpb pT' g' n -> pretowerpb pT f n => 
commsqstr  fto ( pretowerpbpr pT f n ) ( pretowerpbpr pT' g' n ) ( f' n ) ) .  
Proof. intros. induction n as [ | n IHn ] . 

refine ( tpair _ _ _ ) .  { exact g . } { exact h . }

refine ( tpair _ _ _ ) . 

{ exact ( hfpcube ( f' n ) ( pretowerpn pT' n ) ( pretowerpn pT n ) ( f' ( S n ) ) ( pretowerpbpr pT' g' n ) 
( pretowerpbpr pT f n ) ( pr1 IHn ) ( prehn f' n ) ( pr2 IHn ) ) . } 

{ exact ( fun z => idpath _ ) . } Defined. 


Definition pretowerpbfunct { pT' pT : pretower } { X' X : UU } ( g' : X' -> pT' 0 ) ( f' : pretowerfun pT' pT ) ( g : X' -> X ) 
( f : X -> pT 0 ) ( h : commsqstr g f g' ( f' 0 ) ) : pretowerfun ( pretowerpb pT' g' ) ( pretowerpb pT f ) . 
Proof. intros . split with ( fun n => pr1 ( pretowerfunct_a g' f' g f h n ) ) . intro n . intro xze . apply idpath . Defined. 


Definition pretowerpbfunct1 { pT' pT : pretower } { X' : UU } ( g' : X' -> pT' 0 ) ( f' : pretowerfun pT' pT ) :
 pretowerfun ( pretowerpb pT' g' ) ( pretowerpb pT ( funcomp g' ( f' 0 ) ) ) := 
pretowerpbfunct g' f' ( idfun X' ) ( funcomp g' ( f' 0 ) ) ( fun x => idpath _ ) . 


Definition doublepretowerpb_from ( pT : pretower ) { X X' : UU } ( g : X' -> X ) ( f : X -> pT 0 ) : 
pretowerfun ( pretowerpb ( pretowerpb pT f ) g ) ( pretowerpb pT ( funcomp g f ) ) := 
@pretowerpbfunct ( pretowerpb pT f ) pT X' X' g ( pretowerpbpr pT f ) ( idfun X' ) ( funcomp g f ) 
( fun x' : X' => idpath ( f ( g x' ) ) ) .  


Definition doublepretowerpb_to_a ( pT : pretower ) { X X' : UU } ( g : X' -> X ) ( f : X -> pT 0 ) ( n : nat ) :
 total2 ( fun fto : pretowerpb pT ( funcomp g f ) n -> pretowerpb ( pretowerpb pT f ) g n => 
homot ( pretowerpbpr pT ( funcomp g f ) n ) ( funcomp ( funcomp fto ( pretowerpbpr ( pretowerpb pT f ) g n ) ) 
( pretowerpbpr pT f n ) ) ) .
Proof. intros .  induction n as [ | n IHn ] .

{ split with ( fun x => x ) . intro . apply idpath . }

{ set ( fn := pretowerpbpr pT f n ) . set ( gn := pretowerpbpr ( pretowerpb pT f ) g n ) . set ( pn := pretowerpn pT n ) . 
refine ( tpair _ _ _ ) .  

  { intro xze .  set ( xze' := hfplhomot ( pr2 IHn )  ( pretowerpn pT n ) xze : 
hfp ( funcomp ( funcomp ( pr1 IHn ) gn ) fn ) pn  ) .  unfold  pretowerpb . unfold pretowerpb .  simpl . 
change ( hfp gn ( hfpprl fn pn ) ) . apply doublehfp_to . 
 apply ( hfppru ( pr1 IHn ) ( hfpprl ( funcomp gn fn ) pn ) ) .  apply doublehfp_to . apply xze' . }

  { intro xze . destruct xze as [ [ x z ] e ] . apply idpath . }} 

Defined . 


Definition doublepretowerpb_to ( pT : pretower ) { X X' : UU } ( g : X' -> X ) ( f : X -> pT 0 ) :
 pretowerfun ( pretowerpb pT ( funcomp g f ) ) ( pretowerpb ( pretowerpb pT f ) g ) . 
Proof. intros . refine ( pretowerfunconstr _ _ _ _ ) . 

{ intro n .  exact ( pr1 ( doublepretowerpb_to_a pT g f n ) ) . } 

{ intro n .  intro xze . destruct xze as [ [ x z ] e ] . simpl .  apply idpath . } 

Defined. 















(** Pre-tower pull-backs and pre-tower shift *)


(* Strict (substitutional) equality would simplify the proof of pretowerpboneshift considerably since the equality which we are
 trying to prove is a strict one and after showing that the first components of the dependent pairs are equal it would be easy to 
show that the second components are equal as well. *)


Definition pretowerbponeshift_aa { X X' Y Z : UU } ( f : X -> Y ) ( f' : X' -> Y ) ( g : Z -> Y ) ( e : paths X' X ) 
( h : paths f' ( funcomp ( pathstofun e ) f ) ) : 
total2 ( fun esn : paths ( hfp f' g ) ( hfp f g ) => 
dirprod ( paths ( hfppru f' g ) ( funcomp ( pathstofun esn ) ( hfppru f g ) ) ) 
( paths ( funcomp ( pathstofun ( pathsinv0 esn ) ) ( funcomp ( hfpprl f' g ) ( pathstofun e ) ) ) ( hfpprl f g ) ) )  . 
Proof. intros . destruct e . simpl . change ( paths f' f ) in h . destruct h . split with ( idpath _ ) .  split with ( idpath _ ) . 
apply idpath . Defined. 


Definition pretowerbponeshift_a ( pT : pretower ) { X : UU } ( f : X -> pT 0 ) ( n : nat ) : 
total2 ( fun en : paths ( pr1 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) ) 
( pr1 ( pretowerpb_a pT f ( S n ) ) ) => 
total2 ( fun h : paths ( pr2 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) ) 
( funcomp ( pathstofun en )  ( pr2 ( pretowerpb_a pT f ( S n ) ) ) ) => 
paths ( fun xx : ( hfp ( pr2 ( pretowerpb_a pT f ( S n ) ) ) ( pretowerpn pT ( S n ) ) ) => 
( pathstofun en ) ( ( hfpprl ( pr2 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) ) 
( pretowerpn pT ( S n ) ) ) 
( pathstofun ( pathsinv0 ( pr1 ( pretowerbponeshift_aa ( pr2 ( pretowerpb_a pT f ( S n ) ) ) 
( pr2 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) )  ( pretowerpn pT ( S n ) ) en h ) ) ) xx ) ) )

( hfpprl ( pr2 ( pretowerpb_a pT f ( S n ) ) ) ( pretowerpn pT ( S n ) ) ) ) ) . 
Proof. intros . induction n as [| n IHn]. 

split with ( idpath _ ) . split with ( idpath _ ) .  apply idpath . 



set (esn := pr1 ( pretowerbponeshift_aa ( pr2 ( pretowerpb_a pT f ( S n ) ) ) 
( pr2 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) ) 
( pretowerpn pT ( S n ) ) ( pr1 IHn ) ( pr1 ( pr2 IHn ) ) ) ) . 

set (hsn := pr1 (pr2 ( pretowerbponeshift_aa ( pr2 ( pretowerpb_a pT f ( S n ) ) ) 
( pr2 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) ) 
( pretowerpn pT ( S n ) ) ( pr1 IHn ) ( pr1 ( pr2 IHn ) ) ) ) ). 

set ( int := pr2 ( pr2 ( pretowerbponeshift_aa ( pr2 ( pretowerpb_a pT f ( S ( S n ) ) ) ) 
( pr2 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) ( S n ) ) ) 
( pretowerpn pT ( S ( S n ) ) ) esn hsn ) ) ) . 

split with esn. 
split with hsn.  
apply int.
Defined. 



Definition pretowerpboneshift ( pT : pretower ) { X : UU } ( f : X -> pT 0 ) : 
paths ( pretowerpb ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) ) ( pretoweroneshift ( pretowerpb pT f ) ) .  
Proof. intros .   apply ptintpathstopaths . split with (fun n => pr1 ( pretowerbponeshift_a pT f n ) ) .  intro n . 
 exact ( pr2 ( pr2 ( pretowerbponeshift_a pT f n ) ) ) .  Defined. 

(* In the following we have to construct functions between the pretowers which we have shown to be "equal" anew because the equality 
path which we have constructed can not be computed with due, at least in part, to the use of function extensionality in its 
cosntruction. *) 

Definition pretowerbponeshift_to_a ( pT : pretower ) { X : UU } ( f : X -> pT 0 ) ( n : nat ) : 
total2 ( fun en : ( pr1 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) ) -> 
( pr1 ( pretowerpb_a pT f ( S n ) ) ) => homot ( funcomp en ( pr2 ( pretowerpb_a pT f ( S n ) ) ) ) ( pr2 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) ) )  . 
Proof. intros .  induction n as [ | n IHn ] . 

split with ( idfun _ ) . apply idhomot . 

refine ( tpair _ _ _ ) . 

{refine ( hfpcube _ _ _ _ _ _ _ _ _ ) . 

exact ( idfun _ ) . 
exact ( idfun _ ) . 
exact ( pr1 IHn ) . 
exact ( idhomot _ ) . 
exact ( pr2 IHn ) . }

{refine ( hfpcube_h_down  _ _ _ _ _ _ _ _ _ ) . } Defined. 


Definition pretowerpboneshift_to ( pT : pretower ) { X : UU } ( f : X -> pT 0 ) : 
pretowerfun ( pretowerpb ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) ) ( pretoweroneshift ( pretowerpb pT f ) ) .
Proof. intros. refine ( tpair _ _ _ ) . 

exact ( fun n => pr1 ( pretowerbponeshift_to_a pT f n ) ) . 

intro n . refine ( hfpcube_h_front  _ _ _ _ _ _ _ _ _  ) .  Defined. 

Definition pretowerbponeshift_from_a ( pT : pretower ) { X : UU } ( f : X -> pT 0 ) ( n : nat ) : 
total2 ( fun en : ( pr1 ( pretowerpb_a pT f ( S n ) ) ) -> ( pr1 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) )
 => homot ( funcomp en ( pr2 ( pretowerpb_a ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) n ) ) ) ( pr2 ( pretowerpb_a pT f ( S n ) ) )  )  . 
Proof. intros .  induction n as [ | n IHn ] . 

split with ( idfun _ ) . apply idhomot . 

refine ( tpair _ _ _ ) . 

{refine ( hfpcube _ _ _ _ _ _ _ _ _ ) . 

exact ( idfun _ ) . 
exact ( idfun _ ) . 
exact ( pr1 IHn ) . 
exact ( idhomot _ ) . 
exact ( pr2 IHn ) . }

{refine ( hfpcube_h_down  _ _ _ _ _ _ _ _ _ ) . } Defined. 


Definition pretowerpboneshift_from ( pT : pretower ) { X : UU } ( f : X -> pT 0 ) : 
pretowerfun ( pretoweroneshift ( pretowerpb pT f ) ) ( pretowerpb ( pretoweroneshift pT ) ( hfppru f ( pretowerpn pT 0 ) ) ) .
Proof. intros. refine ( tpair _ _ _ ) . 

exact ( fun n => pr1 ( pretowerbponeshift_from_a pT f n ) ) . 

intro n . refine ( hfpcube_h_front  _ _ _ _ _ _ _ _ _  ) .  Defined. 


(** Step lemma *)

Lemma pretowerstep { Y X : UU } ( pT : pretower ) ( f : X -> pT 0 ) ( g : Y -> ( pretowerpb pT f ) 1 ) : 
pretowerfun ( pretowerpb ( pretoweroneshift pT ) ( funcomp g ( hfppru f ( pretowerpn pT 0 ) ) ) ) 
( pretowerpb ( pretoweroneshift ( pretowerpb pT f ) ) g ) . 
Proof. intros .  refine ( pretowerfuncomp ( doublepretowerpb_to _ _ _ ) _ ) . refine ( pretowerpbfunct _ _ _ _ _ ) .  

{refine ( pretowerpboneshift_to _ _ ) . }

{exact ( idfun _ ) . }

{exact ( idhomot _ ) . }

Defined.  






(** Pre-tower fibers *)



Definition pretfib { pT : pretower } ( t : pT 0 ) : pretower := pretoweroneshift ( pretowerpb pT ( fromunit t ) ) . 

Definition pretfibj { pT : pretower } ( t : pT 0 ) : pretowerfun ( pretfib t ) ( pretoweroneshift pT ) := 
pretowerfunoneshift ( pretowerpbpr pT ( fromunit t ) ) . 


Definition pretfibfunct { pT pT' : pretower } ( f : pretowerfun pT pT' ) ( t : pT 0 ) : 
pretowerfun ( pretfib t ) ( pretfib ( f 0 t ) ) .
Proof. intros.  apply pretowerfunoneshift.  
exact ( pretowerpbfunct ( fromunit t ) f ( idfun unit ) ( fromunit ( f 0 t ) ) ( fun _ : _ => idpath _ ) ) .  Defined. 


Definition pretfibtopretoweroneshift ( pT : pretower ) ( t0 : pT 0 ) : pretowerfun ( pretfib t0 ) ( pretoweroneshift pT ) := 
pretowerfunoneshift ( pretowerpbpr pT ( fromunit t0 ) ) . 


Definition pretfibofpretoweroneshift ( pT : pretower ) ( t1 : pT 1 ) : 
pretowerfun ( @pretfib ( pretoweroneshift pT ) t1 ) ( @pretfib ( @pretfib pT ( pretowerpn pT 0 t1 ) ) 
( tohfpfiber ( pretowerpn pT 0 ) t1 ) ) .
Proof.   intros . apply pretoweroneshiftfunct .  unfold pretfib . 

set ( e := pretowerpboneshift pT ( fromunit ( pretowerpn pT 0 t1 ) ) ) . 

exact ( pretowerstep pT ( fromunit ( pretowerpn pT 0 t1 ) ) (fromunit (tohfpfiber (pretowerpn pT 0) t1)) ) . Defined.










(** *** Towers of types - the coinductive definition. *)

CoInductive tower := towerconstr : forall T0 : UU, ( T0 -> tower ) -> tower .

Definition pr0 ( T : tower ) : UU .
Proof. intro . destruct T as [ T' S' ] . exact T' . Defined. 

Definition tfib { T : tower } ( t : pr0 T ) : tower .
Proof. intro. destruct T as [ T' S' ] . exact S' . Defined. 

Definition oneshift ( T : tower ) : tower := towerconstr ( total2 ( fun t : pr0 T => pr0 ( tfib t ) ) ) ( fun tf => tfib ( pr2 tf ) ) .

Definition nshift ( n : nat ) ( T : tower ) : tower .
Proof. intros . induction n as [| n IHn] . exact T . exact (oneshift IHn). Defined. 



(* Coq with the type-in-type patch gives the universe inconsistency message here! *) 

CoInductive towerfun : forall ( T T' : tower ) , UU := towerfunconstr : forall ( T T' : tower ) ( f0 : pr0 T -> pr0 T' ) 
( ff : forall t0 : pr0 T , towerfun ( tfib t0 ) ( tfib ( f0 t0 ) ) ) , towerfun T T' . 

Definition towerfunpr0 { T T' : tower } ( f : towerfun T T' ) : pr0 T -> pr0 T' .
Proof. intros T1 T2 f G . destruct f as [ T T' f0 ff ] .  exact ( f0 G ) . Defined. 

Definition towerfuntfib { T T' : tower } ( f : towerfun T T' ) ( t : pr0 T ) : towerfun ( tfib t ) ( tfib ( towerfunpr0 f t ) ) .
Proof. intros. destruct f as [ T T' f0 ff ] . exact ( ff t ).  Defined.

CoFixpoint toweridfun ( T : tower ) : towerfun T T := towerfunconstr T T ( fun x => x ) ( fun t0 => toweridfun ( tfib t0 ) ) .

CoFixpoint towerfuncomp { T T' T'' : tower } ( f : towerfun T T' ) ( g : towerfun T' T'' ) : towerfun T T'' := 
towerfunconstr T T'' ( fun x => towerfunpr0 g ( towerfunpr0 f x ) ) ( fun x : pr0 T => @towerfuncomp ( tfib x ) 
( tfib ( towerfunpr0 f x ) ) ( tfib ( towerfunpr0 g ( towerfunpr0 f x ) ) ) 
( towerfuntfib f x ) ( towerfuntfib g ( towerfunpr0 f x ) ) )  . 






(** *** Equivalence between towers and pre-towers *)

(** Towers from pre-towers *)



CoFixpoint towerfrompretower ( pT : pretower )  : tower := towerconstr ( prepr0 pT ) ( fun t => towerfrompretower ( @pretfib pT t ) ) .

CoFixpoint towerfrompretowerfun { pT pT' : pretower } ( f : pretowerfun pT pT' ) : towerfun ( towerfrompretower pT ) ( towerfrompretower pT' ) := towerfunconstr ( towerfrompretower pT ) ( towerfrompretower pT' )  ( f 0 ) ( fun t0 => @towerfrompretowerfun ( @pretfib pT t0 ) ( @pretfib pT' ( f 0 t0 ) ) ( pretowerfuntfib f t0 ) ) . 
Definition tfib_t_from_pt ( pT: pretower ) ( t : pT O ) : paths ( towerfrompretower ( @pretfib pT t ) ) ( @tfib ( towerfrompretower pT ) t ) . 
Proof. intros .   apply idpath . Defined .

Lemma oneshift_t_from_pt_to ( pT : pretower ) : towerfun ( towerfrompretower ( pretoweroneshift pT ) ) ( oneshift ( towerfrompretower pT ) ) . 
Proof. intro . cofix. split with ( tococonusf ( pretowerpn pT O ) ) .  intro t1 .  

set (tinhfiber := pr2 ( tococonusf ( pretowerpn pT O ) t1 )  : hfiber ( pretowerpn pT 0 ) ( pretowerpn pT 0 t1 ) ) . change (@tfib ( oneshift ( towerfrompretower pT ) ) (tococonusf (pretowerpn pT 0) t1 ) ) with (@tfib ( towerfrompretower ( @pretfib pT ( pretowerpn pT 0 t1 ) ) )  tinhfiber ) . 

apply ( fun f => @towerfuntfib ( towerfrompretower ( pretoweroneshift pT ) ) ( towerfrompretower (  @pretfib pT ( pretowerpn pT 0 t1 ) ) ) f t1 ) .   . simpl . 


  Defined. 


(** Pre-towers from towers *)

Definition Tn ( T : tower ) ( n : nat ) : UU := pr0 (nshift n T).

Coercion Tn : tower >-> Funclass . 

Lemma TSn ( T :tower ) ( n : nat ) : paths ( T ( S n ) ) ( total2 ( fun t : T n => pr0 ( tfib t ) ) ) .  
Proof. intros . apply idpath . Defined. 


Definition pn ( T : tower ) ( n : nat ) : T ( S n ) -> T n := @pr1 _ ( fun t : pr0 ( nshift n T ) => pr0 ( tfib t ) ) . 

Definition pretowerfromtower ( T : tower ) : pretower := pretowerpair ( fun n => T n ) ( fun n => pn T n ) . 


(** Pre-towers from towers from pre-towers *)

Definition TnpretopreTn ( pT : pretower ) ( n : nat ) : Tn ( towerfrompretower pT ) n  -> preTn pT n .
Proof. intros pT n .  induction n . 

intro x . exact x .

intro x . unfold towerfrompretower in x . unfold Tn in x .  simpl in x .  




Definition weqTnpre ( pT : pretower ) ( n : nat ) : weq ( towerfrompretower pT n ) ( preTn pT n ) . 
Proof. intros . 

assert   



Lemma pttpt_to_id_fun ( pT : pretower ) : pretowerfun ( pretowerfromtower ( towerfrompretower pT ) ) pT .
Proof. intro. 








Definition fiberfloor { n : nat } { T : tower } ( tn : T n ) := pr0 ( tfib tn ) . 

(* Useful formulas:

towerfloor (1+n) T := total2 ( fun G : towerfoloor n T => fiberfloor G ) 

@tfib (1+n) T ( tpair _ G G' ) := @tfib (tfib G) G'

*) 

Definition fiberfloortotowerfloor { n : nat } { T : tower } ( tn : T n ) ( t' : fiberfloor tn ) : T ( S n ) := tpair _ tn t' .















(** *** The type of functions berween towers *)


Definition towerfunfiberfloor { T T' : tower } ( f : towerfun T T' ) { G : pr0 T } : @fiberfloor 0 _ G -> @fiberfloor 0 _ ( towerfunpr0 f G ) := towerfunpr0 ( towerfuntfib f G ) .

Definition towerfunnshift { T T' : tower } ( n : nat ) ( f : towerfun T T' ) : towerfun ( nshift n T ) ( nshift n T' ) .
Proof.  intros . induction n as [ | n IHn ] .  exact f .  apply towerfunconstr with ( fun tf => tpair _ ( towerfunpr0 IHn (pr1 tf) ) ( towerfunfiberfloor IHn (pr2 tf) ) ) .  intro t0 . apply ( towerfuntfib ( towerfuntfib IHn ( pr1 t0 ) ) ( pr2 t0 ) ) . Defined. 

Definition towerfunonfloors { n : nat } { T T' : tower } ( f : towerfun T T' ) :  T n -> T' n := towerfunpr0 ( towerfunnshift n f ) . 

Definition towerfunontowersovers  { n : nat } { T T' : tower } ( f : towerfun T T' ) ( G : T n ) : towerfun ( tfib G ) ( tfib ( towerfunonfloors f G ) ) := towerfuntfib ( towerfunnshift n f ) G .


(** An example of a function between towers *)


CoFixpoint towerstrmap ( T : tower ) ( t0 : pr0 T ) : towerfun ( tfib t0 ) T := towerfunconstr _ _ ( fun x => t0 ) ( fun t1 => towerstrmap ( tfib t0 ) t1 ) .   
 

(** *** The type of homotopies between functions of towers *)















(* Some constructions related to tower shifts *)


Definition mnshiftfun ( m n : nat ) ( T : tower ) : towerfun ( nshift m ( nshift n T ) ) ( nshift ( m + n ) T ) .
Proof. intros . induction m . 

apply toweridfun . 

set ( onfloors := ( fun G' => tpair _ (towerfunpr0 IHm (pr1 G')) (towerfunfiberfloor IHm  (pr2 G' ) ) )  :  (nshift n T) (S m) -> T (S (m + n))) .   

split with onfloors . intro G .  apply ( towerfuntfib ( towerfuntfib IHm (pr1 G) ) (pr2 G) ) . Defined. 

Definition mnfloorfun { m n : nat } { T : tower } ( G : ( nshift n T ) m  ) : T ( m + n )  := towerfunpr0 ( mnshiftfun m n T ) G . 


Definition tfibtotop { n : nat } { T : tower } ( G : T n  ) : towerfun ( tfib G ) ( nshift  ( S n ) T ).
Proof. intros. 

split with ( fun G' : pr0 ( tfib G ) => tpair ( fun G : T n  => pr0 ( tfib G ) ) G G' ) .  

intro G' . apply toweridfun . Defined. 

Definition fiberfloortofloor { n m : nat } { T : tower } ( G : T n  ) ( G' : ( tfib G ) m  ) : T ( m + ( S n ) )  . 
Proof. intros. apply ( mnfloorfun ( towerfunonfloors ( tfibtotop G ) G' ) ) . Defined. 


(* Extending a tower with a unit type *)

Definition towerunitext ( T : tower ) : tower := towerconstr unit ( fun x : unit => T ) . 

(* Extended tower over a node G : T n *)

Definition tfibplus { n : nat } { T : tower } ( G : T n ) := towerconstr unit ( fun x => tfib G ) . 

Definition fromtfibplus { n : nat } { T : tower } ( G : T n ) : towerfun ( tfibplus G ) ( nshift n T ) .
Proof .  intros .  split with ( fun x => G ) . intro . apply ( toweridfun (tfib G) ) .  Defined. 



(* The type of carriers of B-systems - towers together with a one step ramification at each floor except for the ground floor. *)


Definition bsyscar := total2 ( fun T : tower => forall ( n : nat ) ( GT : T ( S n )  ) , UU ) . 
Definition bsyscarpair ( T : tower ) ( btilde : forall ( n : nat ) ( GT : T ( S n )  ) , UU ) : bsyscar := tpair _ T btilde . 

Definition bsyscartotower ( B : bsyscar ) := pr1 B .

Coercion bsyscartotower : bsyscar >-> tower.


Definition Btilde { n : nat } { B : bsyscar } ( GT : B ( S n ) ) : UU := pr2 B n GT . 

Definition bsyscarover { n : nat } { B : bsyscar } ( G : B n ) : bsyscar := bsyscarpair ( tfibplus G ) ( fun m : nat => fun DT : ( tfibplus G ) ( S m )  => @Btilde ( ( m + n ) ) B ( towerfunpr0 ( mnshiftfun ( S m ) n B ) ( towerfunonfloors ( fromtfibplus G ) DT ) ) ) .    




(* The type of functions between bsystemcarrier's *)

Definition bsyscarfun ( B B' : bsyscar ) := total2 ( fun f : towerfun B B' => forall ( n : nat ) ( GT : B ( S n ) ) , Btilde GT -> Btilde ( @towerfunonfloors (S n) _ _ f GT ) ) . 

Definition bsyscarfuntotowerfun ( B B' : bsyscar ) : bsyscarfun B B' -> towerfun B B' := pr1 .
Coercion bsyscarfuntotowerfun : bsyscarfun >-> towerfun .

Definition Bnfun { n : nat } { B B' : bsyscar } ( f : bsyscarfun B B' ) ( G : B n ) : B' n := @towerfunonfloors n _ _ f G .

Definition Btildefun { n : nat } { B B' : bsyscar } ( f : bsyscarfun B B' ) { GT : B (S n ) } ( t : Btilde GT ) : Btilde ( Bnfun f GT ) := pr2 f n GT t .

(* Structures on bsystemcarriers which together form the data of a B-system. *)

(* Operation Tops : ( Gamma, x:T |- ) => ( Gamma , Delta |- ) => ( Gamma, x:T, Delta |- ) *)

Definition Tops ( B : bsyscar ) := forall ( n : nat ) ( G : B n ) ( GT : pr0 ( tfib G ) ) , towerfun ( tfib G ) ( tfib GT ) .

(* Operation Ttildeops : ( Gamma, x:T |- ) => ( Gamma , Delta |- s : S ) => ( Gamma, x:T, Delta |- s : S ) *)

Definition Ttildeops ( B : bsyscar ) ( Top : Tops B ) := forall ( n m : nat ) ( G : towerfloor n B ) ( GT : tfib G ) ( GDS : towerfloor ( S m ) ( tfib G ) ) ( s : BT ( fiberfloortofloor ( pr1 GT ) GDS ) ) , BT ( fiberfloortofloor GT ( towerfunonfloors ( Top _ GT ) GDS ) ) .  

(* note - B for bsyscar, G : towerfloor n B , T : tfib G *)


(* Operation Sops : ( Gamma |- s : S ) => ( Gamma , x:S, Delta |- ) => ( Gamma, Delta[s/x] |- ) *)

Definition Sops ( B : bsyscar ) := forall ( n : nat ) ( G : towerfloor ( S n ) B ) ( s : BT G ) , towerfun ( @tfib (nshift (S n) B ) G ) ( @tfib (nshift n B ) ( pr1 G ) ) . 

(* Operation Stildeops : ( Gamma |- s : S ) => ( Gamma , x:S, Delta |- r : R ) => ( Gamma, Delta[s/x] |- r[s/x]:R[s/x]) *)

Definition Stildeops ( B : bsyscar ) ( Sop : Sops B ) := forall ( n m : nat ) ( GS : pr0 ( nshift ( S n ) B ) ) ( s : BT GS ) ( GSDR : towerfloor ( S m ) ( tfib GS ) ) ( r : BT ( fiberfloortofloor GS GSDR ) ) , BT ( fiberfloortofloor ( pr1 GS ) ( towerfunonfloors ( Sop _ _ s ) GSDR ) ) .  

(* Operation deltaops : ( Gamma, x:T |- ) => ( Gamma, x : T |- x : T ) *)

Definition deltaops ( B : bsyscar ) ( Top : Tops B ) := forall ( n : nat ) ( GT : towerfloor ( S n ) B ) , BT ( fiberfloortotowerfloor GT ( towerfunpr0 ( Top n GT ) ( pr2 GT )  ) ) .   






(* To be removed:

Definition pretfib_Tn_jn ( pT : pretower ) ( t : pT 0 ) ( n : nat ) : total2 ( fun pretfibn : UU => pretfibn -> pT ( S n ) ) .
Proof . intros . induction n .  

split with (hfiber ( pretowerpn pT O ) t ) .  exact pr1 . 

split with ( hfp ( pr2 IHn ) ( pretowerpn pT ( S n ) ) ) . exact ( hfppru ( pr2 IHn ) ( pretowerpn pT ( S n ) ) ) . Defined. 

Definition pretfib_Tn ( pT : pretower ) ( t : pT 0 ) ( n : nat ) : UU  := pr1 ( pretfib_Tn_jn pT t n ) . 

Definition pretfib_jn ( pT : pretower ) ( t : pT 0 ) ( n : nat ) : pretfib_Tn pT t n -> pT ( S n ) := pr2 (  pretfib_Tn_jn pT t n ) . 

Definition pretfib_pn ( pT : pretower ) ( t : pT 0 ) ( n : nat ) : pretfib_Tn pT t ( S n ) -> pretfib_Tn pT t n .
Proof. intros pT t n .  exact ( hfpprl ( pr2 ( pretfib_Tn_jn pT t n ) ) ( pretowerpn pT ( S n ) ) ) . Defined. 

Definition pretfib { pT : pretower } ( t : pT 0 ) : pretower := pretowerpair ( pretfib_Tn pT t ) ( pretfib_pn pT t ) . 

Lemma pr0pretfib ( pT : pretower ) ( t : pT 0 ) : paths ( pretfib t  0 ) ( hfiber ( pretowerpn pT O ) t ) . 
Proof. intros. apply idpath .  Defined. 

Definition pretowerfuntfib_a { pT pT' : pretower } ( f : pretowerfun pT pT' ) ( t : pT 0 ) ( n : nat ) : total2 ( fun funtfibn : ( pretfib t n ) -> ( pretfib ( f 0 t ) n ) => commsqstr ( f ( S n ) ) ( pretfibj ( f 0 t ) n ) ( pretfibj t n ) funtfibn ) .
Proof. intros pT pT' f t n . induction n as [ | n IHn ] .  

split with ( hfibersgtof' ( f 0 ) ( pretowerpn pT' 0 ) ( pretowerpn pT 0 ) ( f 1 ) ( prehn f 0 ) t ) . intro . About commsqstr .  apply idpath . ???


split with ( hfpcube ( f ( S n ) ) ( pretowerpn pT ( S n ) ) ( pretowerpn pT' ( S n ) ) ( f ( S ( S n ) ) )  ( pretfibj pT t n ) ( pretfibj pT' ( f 0 t ) n ) ( pr1 IHn ) ( prehn f ( S n ) ) ( pr2 IHn ) ) .  intro. apply idpath .  Defined. 

*)

(* To be erased *)

Definition freefunctions : UU := total2 ( fun XY : dirprod UU UU => ( pr1 XY -> pr2 XY ) ) . 

Definition freefunctionstriple { X Y : UU } ( f : X -> Y ) : freefunctions := tpair ( fun XY : dirprod UU UU => ( pr1 XY -> pr2 XY ) ) ( dirprodpair X Y ) f . 

Definition ptsteps ( pT : pretower ) ( n : nat ) : freefunctions := freefunctionstriple ( pretowerpn pT n ) . 

(* *)




(* End of the file bsystems.v *)