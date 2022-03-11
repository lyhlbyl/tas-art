%% ++++++++++++++++++++++++++++++++++++++++++++++++++++
%% Framework definition, this part should be invisiable for users
%% +++++++++++++ Framework Def Begin +++++++++++++
%% ----- General System Framework Definition -------
%% we assume perfect knowledge of the system, i.e. close world assumption for system status variable
%% system status perserve unless explicit changes 
%% inherit status unless being changed.
sys_status(Var, Val, I+1) :- 
	sys_var(Var), sys_status(Var, Val, I), 
	step(I), step(I+1), sys_evt(X, I), not -status_remains(Var, I+1) .
-status_remains(X, I) :- status_trans(sys_status(X, V, I)).
-status_remains(X, I) :- exvar(X), step(I), dom_impact(sys_status(X, SV, I)).

%% status transition makes immediate change only without exvars	
sys_status(X, V, I) :- status_trans(sys_status(X, V, I)), -exvar(X).
sys_status(X, SV, I) :- 
	status_trans(sys_status(X, V, I)), exvar(X), step(I),
	dom_impact(sys_status(X, SV, I)), not V = SV.



%% :- sys_status(Var, Val0, I), sys_status(Var, Val1, I), not Val0 = Val1. 
%% status_remains(X, I) :- not -status_remains(X, I), step(I), sys_var(X).

%% For each sys_evt, it can ocuur in the next step, keep generate steps until violation happens
occurs(X, I) | -occurs(X, I) :- sys_evt(X, I), step(I), allHolds(I).
-allHolds(I) :- -holds(Rq, I), req(Rq, _), step(I).
allHolds(I) :- not -allHolds(I), step(I).


%% But sys_evts can only occur in an atomic way
:- occurs(X, I), occurs(Y, I), X != Y.

%% delare exogenous variables, and we declare perfect knowledge of exogenous variable
-exvar(X) :- not exvar(X), sys_var(X).

if_has_exvar(R, Vars) :- req_vars(R, Vars).
if_has_exvar(R, sys_vars(V0,V1,V2)) :- if_has_exvar(R, sys_vars(V0,V1,V2,V3)), -exvar(V3).
if_has_exvar(R, sys_vars(V0,V1)) :- if_has_exvar(R, sys_vars(V0,V1,V2)), -exvar(V2).
if_has_exvar(R, sys_vars(V0)) :- if_has_exvar(R, sys_vars(V0,V1)), -exvar(V1).

-has_exvar(R) :- if_has_exvar(R, sys_vars(V0)), -exvar(V0).
has_exvar(R) :- if_has_exvar(R, sys_vars(V0,V1,V2,V3)), exvar(V3).
has_exvar(R) :- if_has_exvar(R, sys_vars(V0,V1,V2)), exvar(V2).
has_exvar(R) :- if_has_exvar(R, sys_vars(V0,V1)), exvar(V1).
has_exvar(R) :- if_has_exvar(R, sys_vars(V0)), exvar(V0).

%% %% ----- Req Def -------
%% note that only those subgoal that has not exogenous variables are considered as hyp.
%% hyp means the constraint is assumed to be satisfied by sys_evt definition, 
%% Thus, thoes traces that violate hpy will not be generated.
holds(X, I) :- step(I), req(X, hyp), not -holds(X, I).
-holds(X, I) :- step(I), req(X, hyp), not holds(X, I).
:- req(X, hyp), step(I), -holds(X, I).

req_typ(goal).
req_typ(subgoal).
req_typ(hyp).

req_has_subreq(X) :- req_decl(X), req_decl(Y), req_parent_of(X, Y).
-req_has_subreq(X) :- req_decl(X), not req_has_subreq(X).
req_is_subreq(X, Y) :- req_decl(X), req_decl(Y), req_parent_of(X, Y).
req_is_subreq(X, Z) :- req_decl(X), req_decl(Y), req_decl(Z), req_parent_of(X, Y), req_is_subreq(Y, Z).

%% branch node
req(X, goal) :- req_decl(X), req_has_subreq(X).
%% leaf node
req(X, subgoal) :- req_decl(X), -req_has_subreq(X).
%% only those leaf node requirement without exvars will be turned into hyp, 
%% i.e. constraint maintainted by sys_evts
req(X, hyp) :- req(X, subgoal), -has_exvar(X).

%% ----- Step Def -------
step(0..max_step).

%% ----- Init -------
%% only generate liters that satifies req
%% {sys_status(V, 0) : sys_var(V)}.
%% init_status(V) :- sys_status(V, 0).
%% init_status(-V) :- -sys_status(V, 0).
%% :- -holds(X, 0), req(X, _), step(0).

%% +++++++++++++ Framework Def End +++++++++++++
%% ++++++++++++++++++++++++++++++++++++++++++++++++++++