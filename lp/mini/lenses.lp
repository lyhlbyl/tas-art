
%% ++++++++++++++++++++++++++++++++++++++++++++++++++++
%% Framework definition, this part should be invisiable for users
%% +++++++++++++ Framework Def Begin +++++++++++++
%% ----- General System Framework Definition -------
sys_status(Var, Val, I+1) :- 
	sys_var(Var), sys_status(Var, Val, I), 
	step(I), step(I+1), sys_evt(X, I), not -sys_status(Var, I+1) .



%% :- sys_status(Var, Val0, I), sys_status(Var, Val1, I), not Val0 = Val1. 
%% status_remains(X, I) :- not -status_remains(X, I), step(I), sys_var(X).

%% For each sys_evt, it can ocuur in the next step, keep generate steps until violation happens
occurs(X, I) | -occurs(X, I) :- sys_evt(X, I), step(I), allHolds(I).
-allHolds(I) :- -holds(Rq, I), req(Rq, _), step(I).
allHolds(I) :- not -allHolds(I), step(I).


occurs(X,I) :- fin(X, I).

%% there can only be 1 input happen, i.e. in an atomic way
:- fin(X, I), fin(Y, I), X != Y.


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

%% +++++++++++++ Framework Def End +++++++++++++
%% ++++++++++++++++++++++++++++++++++++++++++++++++++++