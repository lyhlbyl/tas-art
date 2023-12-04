%% lenses system definiction
%% f_in : STATE -> OUT
%% IN: WT not WT
%% OUT: WP, not WP
%% system var: WP
%% req WT == WP

%% ----- Block Def -------

%% ----- General System Framework Definition -------
%% system status perserve unless explicit changes 
sys_status(Var, I+1) :- 
	sys_var(Var), sys_status(Var, I), 
	step(I), step(I+1), not sys_status(-Var, I+1).

%% For each event, it can ocuur in the next step, keep generate steps until violation happens
occurs(f_in(X, I), I) | -occurs(f_in(X, I), I) :- f_in(X, I), allHolds(I), step(I).
%% occurs(f_in(X, I), I) :- f_in(X, I), allHolds(I), step(I).
-allHolds(I) :- -holds(req(Rq), I), req(Rq), step(I).
allHolds(I) :- not -allHolds(I), step(I).

%% Input can only occur in an atomic way
:- occurs(X, I), occurs(Y, I), X != Y.

%% ----- Step Def -------
#const max_step=5.
step(0..max_step).


%% ----- Input Vars Def -------
%% Template: f_in_var(ValValue).
%% --------------------------
%% system variable definition
f_in_var(wt).
f_in(X, I) :- step(I), f_in_var(X).
f_in(-X, I) :- step(I), f_in_var(X).

%% ----- Sys Vars Def -------
%% Template: sys_var(VarName).
%% --------------------------
%% system variable definition, note that input var is also sys var
sys_var(wp).
sys_var(X) :- f_in_var(X)


%% ----- Out Vars Def -------
%% Template: f_out_var(ValValue).
%% --------------------------
%% system variable definition
f_out_var(wp).
f_out_var(-wp).
f_out(X, I) :- sys_status(X, I).


%% ----- Event Def -------
%% Template: 
%% f_in(Event, I) :- precond.
%% sys_status(_, I+1) :- occur(Event, I).
%% --------------------------
sys_status(X, I+1) :- step(I), step(I+1), sys_var(wp), occurs(f_in(X, I), I).
sys_status(wp, I+1) :- step(I), step(I+1), sys_var(wp), occurs(f_in(wt, I), I).
sys_status(-wp, I+1) :- step(I), step(I+1), sys_var(wp), occurs(f_in(-wt, I), I).

%% ----- Req Def -------
req(eq_wq_wt).
-holds(req(eq_wq_wt), I) :- step(I), sys_status(wp, I), sys_status(-wt, I). 
-holds(req(eq_wq_wt), I) :- step(I), sys_status(-wp, I), sys_status(wt, I).

%% ----- Init -------
%% only generate liters that satifies inv
%% sys_status(brake, 0). 
%% sys_status(-cc, 0).
sys_status(-wp, 0).


%% ----- check Def -------
counter_example :- -holds(X, I), step(I).
:- not counter_example.

%% #program base.
#show occurs/2.
%% #show -occurs/2.
#show sys_status/2.
#show -holds/2.
%% #show f_in/2.
%% #show allHolds/1.