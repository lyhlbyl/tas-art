%% ----- Block Def -------

%% ----- General System Framework Definition -------
%% we assume perfect knowledge of the system, i.e. close world assumption for system status variable
sys_status(-Var, I) :- sys_var(Var), step(I), not sys_status(Var, I).
-sys_status(Var, I) :- sys_status(-Var, I).
%% system status perserve unless explicit changes 
sys_status(Var, I+1) :- 
	sys_var(Var), sys_status(Var, I), 
	step(I), step(I+1), not sys_status(-Var, I+1).

%% For each event, it can ocuur in the next step, keep generate steps until violation happens
occurs(X, I) | -occurs(X, I) :- event(X, I), not -holds(Inv, I), inv(Inv), step(I).

%% But events can only occur in an atomic way
:- occurs(X, I), occurs(Y, I), X != Y.

%% ----- Step Def -------
#const max_step=1.
step(0..max_step).
%% holds, occurs

%% ----- Sys Vars Def -------
%% Template: sys_var(VarName).
%% --------------------------
%% system variable definition
sys_var(cc).
sys_var(brake).


%% %% ----- Inv Def -------
holds(X, I) :- step(I), inv(X), not -holds(X, I).
%% -holds(X, I) :- step(I), inv(X), not holds(X, I).
%% :- inv(X), step(I), -holds(X, I).

%% Safety requirement: the brakes (brake) cannot be on while the cruise control (cc) is enabled.
%% -brake :- cc.
inv(safe_brake(brake, cc)).
-holds(safe_brake(brake, cc), I) :- step(I), sys_status(brake, I), sys_status(cc, I).



%% ----- Event Def -------
%% Template: 
%% event(Event, I) :- precond.
%% postcond(_, I+1) :- occur(Event, I).
%% --------------------------
%% Event: enable cc := on
event(enable_cc, I) :- step(I).
sys_status(cc, I+1) :- step(I), step(I+1), occurs(enable_cc, I).

%% Event: press brake brake := on
event(press_brake, I) :- step(I).
sys_status(brake, I+1) :- step(I), step(I+1), occurs(press_brake, I).

%% ----- Init -------
%% only generate liters that satifies inv
%% sys_status(brake, 0). 
%% sys_status(-cc, 0).
{sys_status(V, 0): sys_var(V)}.
:- -holds(X, 0), inv(X), step(0).

%% ----- check Def -------
warning :- -holds(X, I), inv(X), step(I).
:- not warning.

%% #program base.
#show occurs/2.
%% #show -occurs/2.
#show sys_status/2.
#show -holds/2.
